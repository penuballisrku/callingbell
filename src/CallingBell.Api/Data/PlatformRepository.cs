using CallingBell.Api.Contracts;
using Dapper;

namespace CallingBell.Api.Data;

public sealed class PlatformRepository(ISqlConnectionFactory factory) : IPlatformRepository
{
    public async Task<(long UserId, string Name, string Email, string Role, string PasswordHash)?> FindUserByEmailAsync(string email, CancellationToken ct)
    {
        const string sql = """
            SELECT TOP (1) u.UserId, u.Name, u.Email, COALESCE(r.Name,'Customer') AS Role, u.PasswordHash
            FROM dbo.Users u
            LEFT JOIN dbo.UserRoles ur ON ur.UserId = u.UserId
            LEFT JOIN dbo.Roles r ON r.RoleId = ur.RoleId
            WHERE u.Email = @Email AND u.IsActive = 1;
            """;
        await using var db = factory.CreateConnection();
        return await db.QuerySingleOrDefaultAsync<(long UserId, string Name, string Email, string Role, string PasswordHash)>(new CommandDefinition(sql, new { Email = email }, cancellationToken: ct));
    }

    public async Task<AuthUserDto> CreateUserAsync(string name, string email, string passwordHash, CancellationToken ct)
    {
        const string sql = """
            SET XACT_ABORT ON;
            BEGIN TRAN;
            INSERT dbo.Users(Name, Email, PasswordHash, IsActive, CreatedDate, UpdatedDate)
            OUTPUT INSERTED.UserId
            VALUES(@Name,@Email,@PasswordHash,1,SYSUTCDATETIME(),SYSUTCDATETIME());
            DECLARE @UserId BIGINT = SCOPE_IDENTITY();
            INSERT dbo.UserRoles(UserId,RoleId) SELECT @UserId,RoleId FROM dbo.Roles WHERE Name='Customer';
            COMMIT;
            """;
        await using var db = factory.CreateConnection();
        var id = await db.ExecuteScalarAsync<long>(new CommandDefinition(sql, new { Name=name, Email=email, PasswordHash=passwordHash }, cancellationToken: ct));
        return new AuthUserDto(id, name, email, "Customer");
    }

    public async Task<IReadOnlyList<NearbyBusinessDto>> GetNearbyBusinessesAsync(double latitude, double longitude, double radiusKm, long? categoryId, int page, int pageSize, CancellationToken ct)
    {
        const string sql = """
            SELECT b.BusinessId, b.BusinessName, b.Slug, c.Name AS CategoryName, b.Address, b.Rating, b.ReviewCount,
                   b.IsVerified, CAST(b.Latitude AS float) Latitude, CAST(b.Longitude AS float) Longitude,
                   6371.0 * ACOS(CASE WHEN ABS((SIN(RADIANS(@Latitude))*SIN(RADIANS(b.Latitude))) +
                     (COS(RADIANS(@Latitude))*COS(RADIANS(b.Latitude))*COS(RADIANS(b.Longitude-@Longitude)))) > 1
                     THEN SIGN((SIN(RADIANS(@Latitude))*SIN(RADIANS(b.Latitude))) +
                     (COS(RADIANS(@Latitude))*COS(RADIANS(b.Latitude))*COS(RADIANS(b.Longitude-@Longitude))))
                     ELSE (SIN(RADIANS(@Latitude))*SIN(RADIANS(b.Latitude))) +
                     (COS(RADIANS(@Latitude))*COS(RADIANS(b.Latitude))*COS(RADIANS(b.Longitude-@Longitude))) END) AS DistanceKm,
                   b.Phone, b.CoverImageUrl AS ImageUrl
            FROM dbo.Businesses b
            INNER JOIN dbo.Categories c ON c.CategoryId=b.CategoryId
            WHERE b.IsActive=1 AND b.Latitude IS NOT NULL AND b.Longitude IS NOT NULL
              AND (@CategoryId IS NULL OR b.CategoryId=@CategoryId)
            ORDER BY DistanceKm, b.IsSponsored DESC, b.Rating DESC
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
            """;
        await using var db = factory.CreateConnection();
        var rows = await db.QueryAsync<NearbyBusinessDto>(new CommandDefinition(sql, new { Latitude=latitude, Longitude=longitude, CategoryId=categoryId, Offset=(Math.Max(page,1)-1)*Math.Clamp(pageSize,1,50), PageSize=Math.Clamp(pageSize,1,50) }, cancellationToken: ct));
        return rows.AsList();
    }

    public async Task<IReadOnlyList<ReviewDto>> GetReviewsAsync(long businessId,int page,int pageSize,CancellationToken ct)
    {
        const string sql="SELECT r.ReviewId,r.BusinessId,r.UserId,u.Name UserName,r.Rating,r.Review,r.CreatedDate,r.IsApproved FROM dbo.Reviews r INNER JOIN dbo.Users u ON u.UserId=r.UserId WHERE r.BusinessId=@BusinessId AND r.IsApproved=1 ORDER BY r.CreatedDate DESC OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";
        await using var db=factory.CreateConnection();
        var rows=await db.QueryAsync<ReviewDto>(new CommandDefinition(sql,new{BusinessId=businessId,Offset=(Math.Max(page,1)-1)*Math.Clamp(pageSize,1,50),PageSize=Math.Clamp(pageSize,1,50)},cancellationToken:ct));
        return rows.AsList();
    }

    public async Task<long> CreateReviewAsync(long userId,ReviewRequest request,CancellationToken ct)
    {
        const string sql="INSERT dbo.Reviews(BusinessId,UserId,Rating,Review,IsApproved,CreatedDate,UpdatedDate) OUTPUT INSERTED.ReviewId VALUES(@BusinessId,@UserId,@Rating,@Review,0,SYSUTCDATETIME(),SYSUTCDATETIME());";
        await using var db=factory.CreateConnection();
        return await db.ExecuteScalarAsync<long>(new CommandDefinition(sql,new{request.BusinessId,UserId=userId,request.Rating,request.Review},cancellationToken:ct));
    }

    public async Task<long> CreateBookingAsync(long userId,BookingRequest request,CancellationToken ct)
    {
        const string sql="INSERT dbo.Bookings(BusinessId,CustomerId,ServiceId,BookingDateUtc,Notes,Status,CreatedDate,UpdatedDate) OUTPUT INSERTED.BookingId VALUES(@BusinessId,@CustomerId,@ServiceId,@BookingDateUtc,@Notes,'Pending',SYSUTCDATETIME(),SYSUTCDATETIME());";
        await using var db=factory.CreateConnection();
        return await db.ExecuteScalarAsync<long>(new CommandDefinition(sql,new{request.BusinessId,CustomerId=userId,request.ServiceId,request.BookingDateUtc,request.Notes},cancellationToken:ct));
    }

    public async Task<IReadOnlyList<BookingDto>> GetBookingsAsync(long userId,CancellationToken ct)
    {
        const string sql="SELECT b.BookingId,b.BusinessId,b.CustomerId,x.BusinessName,s.Name ServiceName,b.BookingDateUtc,b.Notes,b.Status FROM dbo.Bookings b INNER JOIN dbo.Businesses x ON x.BusinessId=b.BusinessId LEFT JOIN dbo.Services s ON s.ServiceId=b.ServiceId WHERE b.CustomerId=@UserId ORDER BY b.BookingDateUtc DESC;";
        await using var db=factory.CreateConnection();
        var rows=await db.QueryAsync<BookingDto>(new CommandDefinition(sql,new{UserId=userId},cancellationToken:ct)); return rows.AsList();
    }

    public async Task<long> CreateEnquiryAsync(long userId,EnquiryRequest request,CancellationToken ct)
    {
        const string sql="INSERT dbo.Enquiries(BusinessId,CustomerId,Message,Status,CreatedDate,UpdatedDate) OUTPUT INSERTED.EnquiryId VALUES(@BusinessId,@CustomerId,@Message,'New',SYSUTCDATETIME(),SYSUTCDATETIME());";
        await using var db=factory.CreateConnection(); return await db.ExecuteScalarAsync<long>(new CommandDefinition(sql,new{request.BusinessId,CustomerId=userId,request.Message},cancellationToken:ct));
    }

    public async Task<IReadOnlyList<EnquiryDto>> GetEnquiriesAsync(long userId,CancellationToken ct)
    {
        const string sql="SELECT e.EnquiryId,e.BusinessId,e.CustomerId,b.BusinessName,e.Message,e.Status,e.CreatedDate FROM dbo.Enquiries e INNER JOIN dbo.Businesses b ON b.BusinessId=e.BusinessId WHERE e.CustomerId=@UserId ORDER BY e.CreatedDate DESC;";
        await using var db=factory.CreateConnection(); var rows=await db.QueryAsync<EnquiryDto>(new CommandDefinition(sql,new{UserId=userId},cancellationToken:ct)); return rows.AsList();
    }

    public async Task<long> CreateLeadAsync(long? customerId,long? businessId,string message,CancellationToken ct)
    {
        const string sql="INSERT dbo.Leads(CustomerId,BusinessId,Message,Status,CreatedDate,UpdatedDate) OUTPUT INSERTED.LeadId VALUES(@CustomerId,@BusinessId,@Message,'New',SYSUTCDATETIME(),SYSUTCDATETIME());";
        await using var db=factory.CreateConnection(); return await db.ExecuteScalarAsync<long>(new CommandDefinition(sql,new{customerId,businessId,message},cancellationToken:ct));
    }

    public async Task<IReadOnlyList<LeadDto>> GetBusinessLeadsAsync(long businessId,CancellationToken ct)
    {
        const string sql="SELECT l.LeadId,l.BusinessId,l.CustomerId,b.BusinessName,l.Message,l.Status,l.CreatedDate FROM dbo.Leads l LEFT JOIN dbo.Businesses b ON b.BusinessId=l.BusinessId WHERE l.BusinessId=@BusinessId ORDER BY l.CreatedDate DESC;";
        await using var db=factory.CreateConnection(); var rows=await db.QueryAsync<LeadDto>(new CommandDefinition(sql,new{businessId},cancellationToken:ct)); return rows.AsList();
    }

    public async Task<IReadOnlyList<AdvertisementDto>> GetActiveAdvertisementsAsync(long? categoryId,long? cityId,CancellationToken ct)
    {
        const string sql="SELECT a.AdvertisementId,a.Title,a.ImageUrl,a.TargetUrl,c.Name CategoryName,ci.Name CityName,a.StartDate,a.EndDate,a.IsActive,a.Impressions,a.Clicks FROM dbo.Advertisements a LEFT JOIN dbo.Categories c ON c.CategoryId=a.CategoryId LEFT JOIN dbo.Cities ci ON ci.CityId=a.CityId WHERE a.IsActive=1 AND a.StartDate<=SYSUTCDATETIME() AND a.EndDate>=SYSUTCDATETIME() AND (@CategoryId IS NULL OR a.CategoryId=@CategoryId) AND (@CityId IS NULL OR a.CityId=@CityId) ORDER BY a.Impressions-a.Clicks,a.AdvertisementId DESC;";
        await using var db=factory.CreateConnection(); var rows=await db.QueryAsync<AdvertisementDto>(new CommandDefinition(sql,new{categoryId,cityId},cancellationToken:ct)); return rows.AsList();
    }

    public async Task<long> CreateAdvertisementAsync(long userId,AdvertisementRequest request,CancellationToken ct)
    {
        const string sql="INSERT dbo.Advertisements(Title,ImageUrl,TargetUrl,CategoryId,CityId,StartDate,EndDate,IsActive,Impressions,Clicks,CreatedByUserId,CreatedDate,UpdatedDate) OUTPUT INSERTED.AdvertisementId VALUES(@Title,@ImageUrl,@TargetUrl,@CategoryId,@CityId,@StartDate,@EndDate,1,0,0,@UserId,SYSUTCDATETIME(),SYSUTCDATETIME());";
        await using var db=factory.CreateConnection(); return await db.ExecuteScalarAsync<long>(new CommandDefinition(sql,new{request.Title,request.ImageUrl,request.TargetUrl,request.CategoryId,request.CityId,request.StartDate,request.EndDate,UserId=userId},cancellationToken:ct));
    }

    public async Task TrackAdvertisementAsync(long advertisementId,bool click,CancellationToken ct)
    {
        var column=click?"Clicks":"Impressions";
        var sql=$"UPDATE dbo.Advertisements SET {column}={column}+1 WHERE AdvertisementId=@AdvertisementId;";
        await using var db=factory.CreateConnection(); await db.ExecuteAsync(new CommandDefinition(sql,new{AdvertisementId=advertisementId},cancellationToken:ct));
    }
}
