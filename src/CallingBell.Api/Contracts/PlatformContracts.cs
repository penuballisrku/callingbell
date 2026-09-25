using System.ComponentModel.DataAnnotations;

namespace CallingBell.Api.Contracts;

public sealed record AuthUserDto(long UserId, string Name, string Email, string Role);
public sealed record AuthResultDto(AuthUserDto User, string AccessToken, DateTime ExpiresAtUtc);

public sealed class RegisterRequest
{
    [Required, StringLength(120)] public string Name { get; init; } = "";
    [Required, EmailAddress, StringLength(254)] public string Email { get; init; } = "";
    [Required, StringLength(128, MinimumLength = 8)] public string Password { get; init; } = "";
}
public sealed class LoginRequest
{
    [Required, EmailAddress] public string Email { get; init; } = "";
    [Required] public string Password { get; init; } = "";
}

public sealed record NearbyBusinessDto(
    long BusinessId, string BusinessName, string Slug, string? CategoryName,
    string? Address, decimal Rating, int ReviewCount, bool IsVerified,
    double Latitude, double Longitude, double DistanceKm, string? Phone, string? ImageUrl);

public sealed record ReviewDto(long ReviewId, long BusinessId, long UserId, string UserName, int Rating, string? Review, DateTime CreatedDate, bool IsApproved);
public sealed class ReviewRequest
{
    [Range(1, long.MaxValue)] public long BusinessId { get; init; }
    [Range(1, 5)] public int Rating { get; init; }
    [StringLength(4000)] public string? Review { get; init; }
}

public enum BookingStatus { Pending, Confirmed, InProgress, Completed, Cancelled, Rejected, NoShow }
public sealed record BookingDto(long BookingId, long BusinessId, long CustomerId, string BusinessName, string? ServiceName, DateTime BookingDateUtc, string? Notes, string Status);
public sealed class BookingRequest
{
    [Range(1, long.MaxValue)] public long BusinessId { get; init; }
    public long? ServiceId { get; init; }
    public DateTime BookingDateUtc { get; init; }
    [StringLength(2000)] public string? Notes { get; init; }
}

public sealed record EnquiryDto(long EnquiryId, long BusinessId, long CustomerId, string BusinessName, string Message, string Status, DateTime CreatedDate);
public sealed class EnquiryRequest
{
    [Range(1, long.MaxValue)] public long BusinessId { get; init; }
    [Required, StringLength(4000)] public string Message { get; init; } = "";
}

public sealed record LeadDto(long LeadId, long? BusinessId, long? CustomerId, string? BusinessName, string Message, string Status, DateTime CreatedDate);
public sealed record AdvertisementDto(long AdvertisementId, string Title, string? ImageUrl, string? TargetUrl, string? CategoryName, string? CityName, DateTime StartDate, DateTime EndDate, bool IsActive, long Impressions, long Clicks);
public sealed class AdvertisementRequest
{
    [Required, StringLength(200)] public string Title { get; init; } = "";
    [StringLength(500)] public string? ImageUrl { get; init; }
    [Url, StringLength(1000)] public string? TargetUrl { get; init; }
    public long? CategoryId { get; init; }
    public long? CityId { get; init; }
    public DateTime StartDate { get; init; }
    public DateTime EndDate { get; init; }
}

public sealed record PresignedUploadDto(string BlobName, string UploadUrl, string PublicUrl);
