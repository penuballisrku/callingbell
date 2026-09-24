using System.Globalization;
using System.Text;
using CallingBell.Api.Contracts;
using CallingBell.Api.Data;

namespace CallingBell.Api.Services;

public sealed class BusinessService(ICallingBellRepository repository) : IBusinessService
{
    private const int MaximumPageSize = 50;

    public Task<IReadOnlyList<CategoryDto>> GetCategoriesAsync(CancellationToken cancellationToken) =>
        repository.GetCategoriesAsync(cancellationToken);

    public async Task<PagedResult<BusinessSummaryDto>> SearchBusinessesAsync(
        string? query,
        string? categorySlug,
        int page,
        int pageSize,
        CancellationToken cancellationToken)
    {
        var safePage = Math.Max(page, 1);
        var safePageSize = Math.Clamp(pageSize, 1, MaximumPageSize);
        var normalizedQuery = NormalizeOptional(query, 120);
        var normalizedCategorySlug = NormalizeOptional(categorySlug, 160);
        var result = await repository.SearchBusinessesAsync(normalizedQuery, normalizedCategorySlug, safePage, safePageSize, cancellationToken);
        return new PagedResult<BusinessSummaryDto>(result.Items, new PaginationDto(safePage, safePageSize, result.TotalCount));
    }

    public async Task<BusinessDetailsDto?> GetBusinessBySlugAsync(string slug, CancellationToken cancellationToken)
    {
        var business = await repository.GetBusinessBySlugAsync(slug.Trim(), cancellationToken);
        if (business is null)
        {
            return null;
        }

        var images = await repository.GetBusinessImagesAsync(business.BusinessId, cancellationToken);
        return business with { Images = images };
    }

    public Task<LocationOptionsDto> GetLocationsAsync(CancellationToken cancellationToken) =>
        repository.GetLocationsAsync(cancellationToken);

    public async Task<BusinessRegistrationResult> RegisterBusinessAsync(BusinessRegistrationRequest request, CancellationToken cancellationToken)
    {
        if (!await repository.CategoryExistsAsync(request.CategoryId, cancellationToken))
        {
            throw new BusinessValidationException("CATEGORY_NOT_FOUND", "Select an active category.");
        }

        if (request.CityId.HasValue && !await repository.CityExistsAsync(request.CityId.Value, cancellationToken))
        {
            throw new BusinessValidationException("CITY_NOT_FOUND", "Select an active city.");
        }

        if (request.AreaId.HasValue && !await repository.AreaBelongsToCityAsync(request.AreaId.Value, request.CityId, cancellationToken))
        {
            throw new BusinessValidationException("AREA_NOT_FOUND", "Select an area that belongs to the selected city.");
        }

        var slug = CreateSlug(request.BusinessName);
        var candidate = slug;
        var suffix = 2;
        while (await repository.SlugExistsAsync(candidate, cancellationToken))
        {
            candidate = $"{slug}-{suffix}";
            suffix++;
        }

        var businessId = await repository.CreateBusinessAsync(request, candidate, cancellationToken);
        return new BusinessRegistrationResult(businessId, candidate, "PENDING_REVIEW");
    }

    private static string? NormalizeOptional(string? value, int maximumLength)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        return value.Trim()[..Math.Min(value.Trim().Length, maximumLength)];
    }

    private static string CreateSlug(string value)
    {
        var normalized = value.Normalize(NormalizationForm.FormD);
        var builder = new StringBuilder(normalized.Length);
        var pendingDash = false;

        foreach (var character in normalized)
        {
            if (CharUnicodeInfo.GetUnicodeCategory(character) == UnicodeCategory.NonSpacingMark)
            {
                continue;
            }

            if (char.IsLetterOrDigit(character))
            {
                if (pendingDash && builder.Length > 0)
                {
                    builder.Append('-');
                }

                builder.Append(char.ToLowerInvariant(character));
                pendingDash = false;
            }
            else
            {
                pendingDash = builder.Length > 0;
            }
        }

        return builder.Length == 0 ? "business" : builder.ToString()[..Math.Min(builder.Length, 140)];
    }
}

public sealed class BusinessValidationException(string code, string message) : Exception(message)
{
    public string Code { get; } = code;
}
