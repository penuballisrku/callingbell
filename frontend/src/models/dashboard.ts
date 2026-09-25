export interface Category{id:number;name:string;icon:string;businessCount:number}
export interface Business{id:number;name:string;category:string;imageUrl:string;rating:number;reviewCount:number;distanceKm:number;verified:boolean;sponsored:boolean;address:string}
export interface TrendingService{id:number;name:string;searches:number;imageUrl:string}
export interface NearbyBusiness{id:number;name:string;category:string;distanceKm:number}
export interface Banner{id:number;title:string;subtitle:string;imageUrl:string;ctaText:string}
export interface DashboardData{banner:Banner|null;categories:Category[];featuredBusinesses:Business[];trendingServices:TrendingService[];nearbyBusinesses:NearbyBusiness[]}