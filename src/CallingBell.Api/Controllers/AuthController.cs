using CallingBell.Api.Contracts;
using CallingBell.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace CallingBell.Api.Controllers;

[ApiController,Route("api/v1/auth")]
public sealed class AuthController(AuthService authService):ControllerBase
{
    [HttpPost("register")] public async Task<ActionResult<ApiResponse<AuthResultDto>>> Register(RegisterRequest request,CancellationToken ct)=>Ok(ApiResponse<AuthResultDto>.Ok(await authService.RegisterAsync(request,ct),"Registration successful"));
    [HttpPost("login")] public async Task<ActionResult<ApiResponse<AuthResultDto>>> Login(LoginRequest request,CancellationToken ct)=>Ok(ApiResponse<AuthResultDto>.Ok(await authService.LoginAsync(request,ct),"Login successful"));
}
