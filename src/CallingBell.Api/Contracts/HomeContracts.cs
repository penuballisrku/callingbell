namespace CallingBell.Api.Contracts;

public sealed record HomePageDto(IReadOnlyList<HomeSectionDto> Sections);

public sealed record HomeSectionDto(
    long SectionId,
    string SectionType,
    string Title,
    string? Subtitle,
    string Theme,
    int DisplayOrder,
    IReadOnlyList<HomeItemDto> Items);

public sealed record HomeItemDto(
    long Id,
    string Name,
    string? Slug,
    string? Description,
    string? ImageUrl,
    string? ThumbnailUrl,
    string? MobileImageUrl,
    string? AltText,
    int? BusinessCount,
    decimal? Rating,
    int? ReviewCount,
    bool IsVerified,
    bool IsSponsored,
    string? Address,
    string? CategoryName,
    string? TargetUrl,
    string? Phone,
    string? WhatsApp);

public sealed record CategoryDto(
    long CategoryId,
    string Name,
    string Slug,
    string? Description,
    string? ImageUrl,
    string? ThumbnailUrl,
    string? Icon,
    int BusinessCount);
