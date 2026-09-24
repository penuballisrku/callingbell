using CallingBell.Api.Contracts;
using CallingBell.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace CallingBell.Api.Controllers;

[ApiController]
[Route("api/v1/businesses")]
public sealed class BusinessesController(IBusinessService businessService) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(ApiResponse<IReadOnlyList<BusinessSummaryDto>>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<IReadOnlyList<BusinessSummaryDto>>>> Search(
        [FromQuery] string? query,
        [FromQuery] string? categorySlug,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 12,
        CancellationToken cancellationToken = default)
    {
        var result = await businessService.SearchBusinessesAsync(query, categorySlug, page, pageSize, cancellationToken);
        return Ok(ApiResponse<IReadOnlyList<BusinessSummaryDto>>.Ok(result.Items, pagination: result.Pagination));
    }

    [HttpGet("{slug}")]
    [ProducesResponseType(typeof(ApiResponse<BusinessDetailsDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ApiResponse<BusinessDetailsDto>>> GetBySlug(string slug, CancellationToken cancellationToken)
    {
        var business = await businessService.GetBusinessBySlugAsync(slug, cancellationToken);
        if (business is null)
        {
            return NotFound(ApiResponse<object>.Fail("BUSINESS_NOT_FOUND", "The requested business was not found."));
        }

        return Ok(ApiResponse<BusinessDetailsDto>.Ok(business));
    }

    [HttpPost]
    [ProducesResponseType(typeof(ApiResponse<BusinessRegistrationResult>), StatusCodes.Status201Created)]
    public async Task<ActionResult<ApiResponse<BusinessRegistrationResult>>> Create(
        [FromBody] BusinessRegistrationRequest request,
        CancellationToken cancellationToken)
    {
        var result = await businessService.RegisterBusinessAsync(request, cancellationToken);
        return CreatedAtAction(nameof(GetBySlug), new { slug = result.Slug }, ApiResponse<BusinessRegistrationResult>.Ok(result, "Business submitted for review."));
    }
}
