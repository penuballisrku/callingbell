using CallingBell.Api.Contracts;
using CallingBell.Api.Data;
namespace CallingBell.Api.Services;
public sealed class PortalService(IPlatformRepository repository)
{
 public Task<AdminStatsDto> GetAdminStatsAsync(CancellationToken ct)=>repository.GetAdminStatsAsync(ct);
 public Task<BusinessOwnerStatsDto> GetBusinessOwnerStatsAsync(long userId,CancellationToken ct)=>repository.GetBusinessOwnerStatsAsync(userId,ct);
}