using CallingBell.Api.Contracts;
using Dapper;

namespace CallingBell.Api.Data;

public sealed class CallingBellRepository(ISqlConnectionFactory connectionFactory) : ICallingBellRepository
{
    public async Task<IReadOnlyList<HomeSectionRecord>> GetHomeSectionsAsync(CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT HomeSectionId, SectionType, Title, Subtitle, Theme, DisplayOrder, MaxItems
            FROM dbo.HomeSections
            WHERE IsActive = 1
              AND (StartDate IS NULL OR StartDate <= SYSUTCDATETIME())
              AND (EndDate IS NULL OR EndDate >= SYSUTCDATETIME())
            ORDER BY DisplayOrder, HomeSectionId;
            """;

        await using var connection = connectionFactory.CreateConnection();
        var rows = await connection.QueryAsync<HomeSectionRecord>(new CommandDefinition(sql, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<IReadOnlyList<HomeItemDto>> GetHomeSectionItemsAsync(HomeSectionRecord section, CancellationToken cancellationToken)
    {
        var command = CreateHomeSectionItemsCommand(section, cancellationToken);
        await using var connection = connectionFactory.CreateConnection();
        var rows = await connection.QueryAsync<HomeItemDto>(command);
        return rows.AsList();
    }

    public async Task<IReadOnlyList<CategoryDto>> GetCategoriesAsync(CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT c.CategoryId, c.Name, c.Slug, c.Description, c.ImageUrl, c.ThumbnailUrl, c.Icon,
                   COUNT(b.BusinessId) AS BusinessCount
            FROM dbo.Categories c
            LEFT JOIN dbo.Businesses b ON b.CategoryId = c.CategoryId AND b.IsActive = 1
            WHERE c.IsActive = 1
            GROUP BY c.CategoryId, c.Name, c.Slug, c.Description, c.ImageUrl, c.ThumbnailUrl, c.Icon, c.DisplayOrder
            ORDER BY c.DisplayOrder, c.Name;
            """;

        await using var connection = connectionFactory.CreateConnection();
        var rows = await connection.QueryAsync<CategoryDto>(new CommandDefinition(sql, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<(IReadOnlyList<BusinessSummaryDto> Items, int TotalCount)> SearchBusinessesAsync(
        string? query,
        string? categorySlug,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        const string countSql = """
            SELECT COUNT_BIG(1)
            FROM dbo.Businesses b
            INNER JOIN dbo.Categories c ON c.CategoryId = b.CategoryId
            WHERE b.IsActive = 1
              AND (@Query IS NULL OR b.BusinessName LIKE '%' + @Query + '%' OR b.Description LIKE '%' + @Query + '%')
              AND (@CategorySlug IS NULL OR c.Slug = @CategorySlug);
            """;

        const string pageSql = """
            SELECT b.BusinessId, b.BusinessName, b.Slug, b.Description, b.CoverImageUrl, b.LogoUrl,
                   c.Name AS CategoryName, b.Address, city.Name AS CityName, area.Name AS AreaName,
                   b.Rating, b.ReviewCount, b.IsVerified, b.IsSponsored, b.Phone, b.WhatsApp
            FROM dbo.Businesses b
            INNER JOIN dbo.Categories c ON c.CategoryId = b.CategoryId
            LEFT JOIN dbo.Cities city ON city.CityId = b.CityId
            LEFT JOIN dbo.Areas area ON area.AreaId = b.AreaId
            WHERE b.IsActive = 1
              AND (@Query IS NULL OR b.BusinessName LIKE '%' + @Query + '%' OR b.Description LIKE '%' + @Query + '%')
              AND (@CategorySlug IS NULL OR c.Slug = @CategorySlug)
            ORDER BY b.IsSponsored DESC, b.IsVerified DESC, b.Rating DESC, b.BusinessName
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
            """;

        var parameters = new { Query = query, CategorySlug = categorySlug, Offset = (page - 1) * pageSize, PageSize = pageSize };
        await using var connection = connectionFactory.CreateConnection();
        var totalCount = await connection.ExecuteScalarAsync<long>(new CommandDefinition(countSql, parameters, cancellationToken: cancellationToken));
        var items = await connection.QueryAsync<BusinessSummaryDto>(new CommandDefinition(pageSql, parameters, cancellationToken: cancellationToken));
        return (items.AsList(), checked((int)totalCount));
    }

    public async Task<BusinessDetailsDto?> GetBusinessBySlugAsync(string slug, CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT b.BusinessId, b.BusinessName, b.Slug, b.Description, b.CoverImageUrl, b.LogoUrl,
                   c.Name AS CategoryName, b.Address, city.Name AS CityName, area.Name AS AreaName, b.Pincode,
                   b.Rating, b.ReviewCount, b.IsVerified, b.IsSponsored, b.Phone, b.WhatsApp, b.Email, b.Website
            FROM dbo.Businesses b
            INNER JOIN dbo.Categories c ON c.CategoryId = b.CategoryId
            LEFT JOIN dbo.Cities city ON city.CityId = b.CityId
            LEFT JOIN dbo.Areas area ON area.AreaId = b.AreaId
            WHERE b.IsActive = 1 AND b.Slug = @Slug;
            """;

        await using var connection = connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<BusinessDetailsDto>(new CommandDefinition(sql, new { Slug = slug }, cancellationToken: cancellationToken));
    }

    public async Task<IReadOnlyList<BusinessImageDto>> GetBusinessImagesAsync(long businessId, CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT BusinessImageId, ImageUrl, ThumbnailUrl, AltText, ImageType, DisplayOrder, IsPrimary
            FROM dbo.BusinessImages
            WHERE BusinessId = @BusinessId AND IsActive = 1
            ORDER BY IsPrimary DESC, DisplayOrder, BusinessImageId;
            """;

        await using var connection = connectionFactory.CreateConnection();
        var rows = await connection.QueryAsync<BusinessImageDto>(new CommandDefinition(sql, new { BusinessId = businessId }, cancellationToken: cancellationToken));
        return rows.AsList();
    }

    public async Task<LocationOptionsDto> GetLocationsAsync(CancellationToken cancellationToken)
    {
        const string citySql = "SELECT CityId, Name FROM dbo.Cities WHERE IsActive = 1 ORDER BY Name;";
        const string areaSql = "SELECT AreaId, CityId, Name FROM dbo.Areas WHERE IsActive = 1 ORDER BY Name;";

        await using var connection = connectionFactory.CreateConnection();
        var cities = await connection.QueryAsync<CityDto>(new CommandDefinition(citySql, cancellationToken: cancellationToken));
        var areas = await connection.QueryAsync<AreaDto>(new CommandDefinition(areaSql, cancellationToken: cancellationToken));
        return new LocationOptionsDto(cities.AsList(), areas.AsList());
    }

    public async Task<long> CreateBusinessAsync(BusinessRegistrationRequest request, string slug, CancellationToken cancellationToken)
    {
        const string sql = """
            INSERT INTO dbo.Businesses
                (BusinessName, Slug, OwnerName, CategoryId, Description, Phone, WhatsApp, Email, Website,
                 Address, CityId, AreaId, Pincode, Rating, ReviewCount, IsVerified, IsSponsored, IsActive, CreatedDate, UpdatedDate)
            OUTPUT INSERTED.BusinessId
            VALUES
                (@BusinessName, @Slug, @OwnerName, @CategoryId, @Description, @Phone, @WhatsApp, @Email, @Website,
                 @Address, @CityId, @AreaId, @Pincode, 0, 0, 0, 0, 0, SYSUTCDATETIME(), SYSUTCDATETIME());
            """;

        var parameters = new
        {
            request.BusinessName,
            Slug = slug,
            request.OwnerName,
            request.CategoryId,
            request.Description,
            request.Phone,
            request.WhatsApp,
            request.Email,
            request.Website,
            request.Address,
            request.CityId,
            request.AreaId,
            request.Pincode
        };

        await using var connection = connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<long>(new CommandDefinition(sql, parameters, cancellationToken: cancellationToken));
    }

    public Task<bool> CategoryExistsAsync(long categoryId, CancellationToken cancellationToken) =>
        ExistsAsync("SELECT CAST(CASE WHEN EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryId = @Id AND IsActive = 1) THEN 1 ELSE 0 END AS bit);", categoryId, cancellationToken);

    public Task<bool> CityExistsAsync(long cityId, CancellationToken cancellationToken) =>
        ExistsAsync("SELECT CAST(CASE WHEN EXISTS (SELECT 1 FROM dbo.Cities WHERE CityId = @Id AND IsActive = 1) THEN 1 ELSE 0 END AS bit);", cityId, cancellationToken);

    public async Task<bool> AreaBelongsToCityAsync(long areaId, long? cityId, CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT CAST(CASE WHEN EXISTS
                (SELECT 1 FROM dbo.Areas WHERE AreaId = @AreaId AND CityId = @CityId AND IsActive = 1)
                THEN 1 ELSE 0 END AS bit);
            """;

        await using var connection = connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<bool>(new CommandDefinition(sql, new { AreaId = areaId, CityId = cityId }, cancellationToken: cancellationToken));
    }

    public Task<bool> SlugExistsAsync(string slug, CancellationToken cancellationToken) =>
        ExistsAsync("SELECT CAST(CASE WHEN EXISTS (SELECT 1 FROM dbo.Businesses WHERE Slug = @Id) THEN 1 ELSE 0 END AS bit);", slug, cancellationToken);

    private async Task<bool> ExistsAsync(string sql, object id, CancellationToken cancellationToken)
    {
        await using var connection = connectionFactory.CreateConnection();
        return await connection.ExecuteScalarAsync<bool>(new CommandDefinition(sql, new { Id = id }, cancellationToken: cancellationToken));
    }

    private static CommandDefinition CreateHomeSectionItemsCommand(HomeSectionRecord section, CancellationToken cancellationToken)
    {
        var parameters = new { SectionId = section.HomeSectionId, MaxItems = Math.Clamp(section.MaxItems, 1, 50) };
        var normalizedType = section.SectionType.Trim().ToUpperInvariant();

        var sql = normalizedType switch
        {
            "CATEGORY_GRID" or "POPULAR_SEARCH" or "WEDDING" or "BEAUTY_SPA" or "REPAIR" or "DAILY_NEEDS" or "HEALTHCARE" => """
                SELECT TOP (@MaxItems)
                       c.CategoryId AS Id, c.Name, c.Slug, c.Description, c.ImageUrl, c.ThumbnailUrl, c.MobileImageUrl,
                       c.AltText, COUNT(b.BusinessId) AS BusinessCount,
                       CAST(NULL AS decimal(3,2)) AS Rating, CAST(NULL AS int) AS ReviewCount,
                       CAST(0 AS bit) AS IsVerified, CAST(0 AS bit) AS IsSponsored,
                       CAST(NULL AS nvarchar(500)) AS Address, CAST(NULL AS nvarchar(160)) AS CategoryName,
                       CAST(NULL AS nvarchar(500)) AS TargetUrl, CAST(NULL AS nvarchar(30)) AS Phone,
                       CAST(NULL AS nvarchar(30)) AS WhatsApp
                FROM dbo.HomeSectionItems hsi
                INNER JOIN dbo.Categories c ON c.CategoryId = hsi.CategoryId
                LEFT JOIN dbo.Businesses b ON b.CategoryId = c.CategoryId AND b.IsActive = 1
                WHERE hsi.HomeSectionId = @SectionId AND hsi.IsActive = 1 AND c.IsActive = 1
                GROUP BY c.CategoryId, c.Name, c.Slug, c.Description, c.ImageUrl, c.ThumbnailUrl, c.MobileImageUrl,
                         c.AltText, hsi.DisplayOrder
                ORDER BY hsi.DisplayOrder, c.Name;
                """,
            "BANNER" or "ADVERTISEMENT" => """
                SELECT TOP (@MaxItems)
                       banner.BannerId AS Id, banner.Title AS Name, CAST(NULL AS nvarchar(160)) AS Slug,
                       banner.Subtitle AS Description, banner.ImageUrl, banner.ThumbnailUrl, banner.MobileImageUrl,
                       banner.AltText, CAST(NULL AS int) AS BusinessCount, CAST(NULL AS decimal(3,2)) AS Rating,
                       CAST(NULL AS int) AS ReviewCount, CAST(0 AS bit) AS IsVerified, CAST(0 AS bit) AS IsSponsored,
                       CAST(NULL AS nvarchar(500)) AS Address, CAST(NULL AS nvarchar(160)) AS CategoryName,
                       banner.TargetUrl, CAST(NULL AS nvarchar(30)) AS Phone, CAST(NULL AS nvarchar(30)) AS WhatsApp
                FROM dbo.HomeSectionItems hsi
                INNER JOIN dbo.Banners banner ON banner.BannerId = hsi.BannerId
                WHERE hsi.HomeSectionId = @SectionId AND hsi.IsActive = 1 AND banner.IsActive = 1
                  AND (banner.StartDate IS NULL OR banner.StartDate <= SYSUTCDATETIME())
                  AND (banner.EndDate IS NULL OR banner.EndDate >= SYSUTCDATETIME())
                ORDER BY hsi.DisplayOrder, banner.BannerId;
                """,
            _ => """
                SELECT TOP (@MaxItems)
                       b.BusinessId AS Id, b.BusinessName AS Name, b.Slug, b.Description,
                       COALESCE(primaryImage.ImageUrl, b.CoverImageUrl) AS ImageUrl,
                       COALESCE(primaryImage.ThumbnailUrl, b.CoverImageUrl) AS ThumbnailUrl,
                       CAST(NULL AS nvarchar(500)) AS MobileImageUrl, primaryImage.AltText,
                       CAST(NULL AS int) AS BusinessCount, b.Rating, b.ReviewCount, b.IsVerified, b.IsSponsored,
                       b.Address, c.Name AS CategoryName, CAST(NULL AS nvarchar(500)) AS TargetUrl, b.Phone, b.WhatsApp
                FROM dbo.HomeSectionItems hsi
                INNER JOIN dbo.Businesses b ON b.BusinessId = hsi.BusinessId
                INNER JOIN dbo.Categories c ON c.CategoryId = b.CategoryId
                OUTER APPLY (
                    SELECT TOP (1) ImageUrl, ThumbnailUrl, AltText
                    FROM dbo.BusinessImages
                    WHERE BusinessId = b.BusinessId AND IsActive = 1
                    ORDER BY IsPrimary DESC, DisplayOrder, BusinessImageId
                ) primaryImage
                WHERE hsi.HomeSectionId = @SectionId AND hsi.IsActive = 1 AND b.IsActive = 1
                ORDER BY hsi.DisplayOrder, b.BusinessName;
                """
        };

        return new CommandDefinition(sql, parameters, cancellationToken: cancellationToken);
    }
}
