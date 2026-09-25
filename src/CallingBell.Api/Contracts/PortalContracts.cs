namespace CallingBell.Api.Contracts;
public sealed record AdminStatsDto(long Users,long Businesses,long Leads,long Bookings,long Enquiries,long Advertisements);
public sealed record BusinessOwnerStatsDto(long Businesses,long Leads,long Bookings,long Enquiries);