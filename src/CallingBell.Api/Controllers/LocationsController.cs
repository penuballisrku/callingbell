using CallingBell.Api.Contracts;
using CallingBell.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace CallingBell.Api.Controllers;

[ApiController]
[Route("api/v1/locations")]
public sealed class LocationsController(IBusinessService businessService) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(ApiResponse<LocationOptionsDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<LocationOptionsDto>>> Get(CancellationToken cancellationToken)
    {
        var locations = await businessService.GetLocationsAsync(cancellationToken);
        return Ok(ApiResponse<LocationOptionsDto>.Ok(locations));
    }
}
