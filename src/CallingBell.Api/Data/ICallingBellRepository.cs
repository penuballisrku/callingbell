using CallingBell.Api.Contracts;

namespace CallingBell.Api.Data;

public interface ICallingBellRepository
{
    Task<IReadOnlyList<HomeSectionRecord>> GetHomeSectionsAsync(CancellationToken cancellationToken);
    Task<IReadOnlyList<HomeItemDto>> GetHomeSectionItemsAsync(HomeSectionRecord section, CancellationToken cancellationToken);
    Task<IReadOnlyList<CategoryDto>> GetCategoriesAsync(CancellationToken cancellationToken);
    Task<(IReadOnlyList<BusinessSummaryDto> Items, int TotalCount)> SearchBusinessesAsync(string? query, string? categorySlug, int page, int pageSize, CancellationToken cancellationToken);
    Task<BusinessDetailsDto?> GetBusinessBySlugAsync(string slug, CancellationToken cancellationToken);
    Task<IReadOnlyList<BusinessImageDto>> GetBusinessImagesAsync(long businessId, CancellationToken cancellationToken);
    Task<LocationOptionsDto> GetLocationsAsync(CancellationToken cancellationToken);
    Task<long> CreateBusinessAsync(BusinessRegistrationRequest request, string slug, CancellationToken cancellationToken);
    Task<bool> CategoryExistsAsync(long categoryId, CancellationToken cancellationToken);
    Task<bool> CityExistsAsync(long cityId, CancellationToken cancellationToken);
    Task<bool> AreaBelongsToCityAsync(long areaId, long? cityId, CancellationToken cancellationToken);
    Task<bool> SlugExistsAsync(string slug, CancellationToken cancellationToken);
}

public sealed record HomeSectionRecord(
    long HomeSectionId,
    string SectionType,
    string Title,
    string? Subtitle,
    string Theme,
    int DisplayOrder,
    int MaxItems);
