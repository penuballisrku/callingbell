using CallingBell.Api.Contracts;
using CallingBell.Api.Data;

namespace CallingBell.Api.Services;

public sealed class HomeService(ICallingBellRepository repository) : IHomeService
{
    public async Task<HomePageDto> GetHomeAsync(CancellationToken cancellationToken)
    {
        var sections = await repository.GetHomeSectionsAsync(cancellationToken);
        var result = new List<HomeSectionDto>(sections.Count);

        foreach (var section in sections)
        {
            var items = await repository.GetHomeSectionItemsAsync(section, cancellationToken);
            result.Add(new HomeSectionDto(
                section.HomeSectionId,
                section.SectionType,
                section.Title,
                section.Subtitle,
                section.Theme,
                section.DisplayOrder,
                items));
        }

        return new HomePageDto(result);
    }
}
