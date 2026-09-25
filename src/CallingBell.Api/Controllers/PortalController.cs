using System.Security.Claims;
using CallingBell.Api.Contracts;
using CallingBell.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace CallingBell.Api.Controllers;
[ApiController,Route("api/v1/portal"),Authorize]
public sealed class PortalController(PortalService service):ControllerBase
{
 [HttpGet("admin"),Authorize(Roles="SuperAdmin,Admin")]
 public async Task<ActionResult<ApiResponse<AdminStatsDto>>> Admin(CancellationToken ct)=>Ok(ApiResponse<AdminStatsDto>.Ok(await service.GetAdminStatsAsync(ct)));
 [HttpGet("business-owner"),Authorize(Roles="BusinessOwner")]
 public async Task<ActionResult<ApiResponse<BusinessOwnerStatsDto>>> Owner(CancellationToken ct)
 {
  if(!long.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier),out var userId))return Unauthorized();
  return Ok(ApiResponse<BusinessOwnerStatsDto>.Ok(await service.GetBusinessOwnerStatsAsync(userId,ct)));
 }
}