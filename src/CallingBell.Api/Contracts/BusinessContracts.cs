using System.ComponentModel.DataAnnotations;

namespace CallingBell.Api.Contracts;

public sealed record BusinessSummaryDto(
    long BusinessId,
    string BusinessName,
    string Slug,
    string? Description,
    string? CoverImageUrl,
    string? LogoUrl,
    string? CategoryName,
    string? Address,
    string? CityName,
    string? AreaName,
    decimal Rating,
    int ReviewCount,
    bool IsVerified,
    bool IsSponsored,
    string? Phone,
    string? WhatsApp);

public sealed record BusinessImageDto(
    long BusinessImageId,
    string ImageUrl,
    string? ThumbnailUrl,
    string? AltText,
    string ImageType,
    int DisplayOrder,
    bool IsPrimary);

public sealed record BusinessDetailsDto(
    long BusinessId,
    string BusinessName,
    string Slug,
    string? Description,
    string? CoverImageUrl,
    string? LogoUrl,
    string? CategoryName,
    string? Address,
    string? CityName,
    string? AreaName,
    string? Pincode,
    decimal Rating,
    int ReviewCount,
    bool IsVerified,
    bool IsSponsored,
    string? Phone,
    string? WhatsApp,
    string? Email,
    string? Website,
    IReadOnlyList<BusinessImageDto> Images);

public sealed record PagedResult<T>(IReadOnlyList<T> Items, PaginationDto Pagination);

public sealed record CityDto(long CityId, string Name);

public sealed record AreaDto(long AreaId, long CityId, string Name);

public sealed record LocationOptionsDto(IReadOnlyList<CityDto> Cities, IReadOnlyList<AreaDto> Areas);

public sealed class BusinessRegistrationRequest
{
    [Required, StringLength(160)]
    public string BusinessName { get; init; } = string.Empty;

    [Required, StringLength(120)]
    public string OwnerName { get; init; } = string.Empty;

    [Range(1, long.MaxValue)]
    public long CategoryId { get; init; }

    [Required, StringLength(30)]
    public string Phone { get; init; } = string.Empty;

    [StringLength(30)]
    public string? WhatsApp { get; init; }

    [EmailAddress, StringLength(254)]
    public string? Email { get; init; }

    [Url, StringLength(500)]
    public string? Website { get; init; }

    [Required, StringLength(500)]
    public string Address { get; init; } = string.Empty;

    public long? CityId { get; init; }

    public long? AreaId { get; init; }

    [StringLength(12)]
    public string? Pincode { get; init; }

    [StringLength(4000)]
    public string? Description { get; init; }
}

public sealed record BusinessRegistrationResult(long BusinessId, string Slug, string Status);
