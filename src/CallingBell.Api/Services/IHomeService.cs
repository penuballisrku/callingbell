using CallingBell.Api.Contracts;

namespace CallingBell.Api.Services;

public interface IHomeService
{
    Task<HomePageDto> GetHomeAsync(CancellationToken cancellationToken);
}
