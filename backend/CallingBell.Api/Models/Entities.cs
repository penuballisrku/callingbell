namespace CallingBell.Api.Models;
public sealed class Category{public long Id{get;set;}public string Name{get;set;}="";public string Icon{get;set;}="";public int BusinessCount{get;set;}public bool IsActive{get;set;}=true;}
public sealed class Business{public long Id{get;set;}public string Name{get;set;}="";public string Category{get;set;}="";public string ImageUrl{get;set;}="";public decimal Rating{get;set;}public int ReviewCount{get;set;}public decimal DistanceKm{get;set;}public bool IsVerified{get;set;}public bool IsSponsored{get;set;}public string Address{get;set;}="";public bool IsActive{get;set;}=true;}
public sealed class TrendingService{public long Id{get;set;}public string Name{get;set;}="";public int Searches{get;set;}public string ImageUrl{get;set;}="";public bool IsActive{get;set;}=true;}
public sealed class NearbyBusiness{public long Id{get;set;}public string Name{get;set;}="";public string Category{get;set;}="";public decimal DistanceKm{get;set;}}
public sealed class Banner{public long Id{get;set;}public string Title{get;set;}="";public string Subtitle{get;set;}="";public string ImageUrl{get;set;}="";public string CtaText{get;set;}="Search";public bool IsActive{get;set;}=true;}
public sealed class DashboardDto{public BannerDto? Banner{get;init;}public IReadOnlyList<CategoryDto> Categories{get;init;}=[];public IReadOnlyList<BusinessDto> FeaturedBusinesses{get;init;}=[];public IReadOnlyList<TrendingServiceDto> TrendingServices{get;init;}=[];public IReadOnlyList<NearbyBusinessDto> NearbyBusinesses{get;init;}=[];}
public record BannerDto(long Id,string Title,string Subtitle,string ImageUrl,string CtaText);
public record CategoryDto(long Id,string Name,string Icon,int BusinessCount);
public record BusinessDto(long Id,string Name,string Category,string ImageUrl,decimal Rating,int ReviewCount,decimal DistanceKm,bool Verified,bool Sponsored,string Address);
public record TrendingServiceDto(long Id,string Name,int Searches,string ImageUrl);
public record NearbyBusinessDto(long Id,string Name,string Category,decimal DistanceKm);
public record ApiResponse<T>(bool Success,string Message,T? Data,IReadOnlyList<ApiError> Errors);
public record ApiError(string Code,string Message);