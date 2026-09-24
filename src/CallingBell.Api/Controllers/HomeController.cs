using CallingBell.Api.Contracts;
using CallingBell.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace CallingBell.Api.Controllers;

[ApiController]
[Route("api/v1/home")]
public sealed class HomeController(IHomeService homeService) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(ApiResponse<HomePageDto>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<HomePageDto>>> Get(CancellationToken cancellationToken)
    {
        var home = await homeService.GetHomeAsync(cancellationToken);
        return Ok(ApiResponse<HomePageDto>.Ok(home));
    }
}
