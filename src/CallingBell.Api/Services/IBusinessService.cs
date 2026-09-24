using CallingBell.Api.Contracts;

namespace CallingBell.Api.Services;

public interface IBusinessService
{
    Task<IReadOnlyList<CategoryDto>> GetCategoriesAsync(CancellationToken cancellationToken);
    Task<PagedResult<BusinessSummaryDto>> SearchBusinessesAsync(string? query, string? categorySlug, int page, int pageSize, CancellationToken cancellationToken);
    Task<BusinessDetailsDto?> GetBusinessBySlugAsync(string slug, CancellationToken cancellationToken);
    Task<LocationOptionsDto> GetLocationsAsync(CancellationToken cancellationToken);
    Task<BusinessRegistrationResult> RegisterBusinessAsync(BusinessRegistrationRequest request, CancellationToken cancellationToken);
}
