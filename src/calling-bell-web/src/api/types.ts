export type ApiError={code:string;message:string}
export type Pagination={page:number;pageSize:number;totalCount:number;totalPages:number}
export type ApiResponse<T>={success:boolean;message:string;data:T|null;error:ApiError|null;pagination:Pagination|null}
export type HomeItem={id:number;name:string;slug:string|null;description:string|null;imageUrl:string|null;thumbnailUrl:string|null;mobileImageUrl:string|null;altText:string|null;businessCount:number|null;rating:number|null;reviewCount:number|null;isVerified:boolean;isSponsored:boolean;address:string|null;categoryName:string|null;targetUrl:string|null;phone:string|null;whatsApp:string|null}
export type HomeSection={sectionId:number;sectionType:string;title:string;subtitle:string|null;theme:string;displayOrder:number;items:HomeItem[]}
export type HomePage={sections:HomeSection[]}
export type DashboardHero={title:string;subtitle:string;backgroundImageUrl:string|null}
export type Dashboard={appName:string;tagline:string;hero:DashboardHero;categories:Category[];sections:HomeSection[]}
export type Category={categoryId:number;name:string;slug:string;description:string|null;imageUrl:string|null;thumbnailUrl:string|null;icon:string|null;businessCount:number}
export type BusinessSummary={businessId:number;businessName:string;slug:string;description:string|null;coverImageUrl:string|null;logoUrl:string|null;categoryName:string|null;address:string|null;cityName:string|null;areaName:string|null;rating:number;reviewCount:number;isVerified:boolean;isSponsored:boolean;phone:string|null;whatsApp:string|null}
export type BusinessImage={businessImageId:number;imageUrl:string;thumbnailUrl:string|null;altText:string|null;imageType:string;displayOrder:number;isPrimary:boolean}
export type BusinessDetails=BusinessSummary&{email:string|null;website:string|null;pincode:string|null;images:BusinessImage[]}
export type City={cityId:number;name:string};export type Area={areaId:number;cityId:number;name:string};export type LocationOptions={cities:City[];areas:Area[]}
export type BusinessRegistration={businessName:string;ownerName:string;categoryId:number;phone:string;whatsApp?:string;email?:string;website?:string;address:string;cityId?:number;areaId?:number;pincode?:string;description?:string}
export type BusinessRegistrationResult={businessId:number;slug:string;status:string}
export type AuthUser={userId:number;name:string;email:string;role:string};export type AuthResult={user:AuthUser;accessToken:string;expiresAtUtc:string}
export type NearbyBusiness={businessId:number;businessName:string;slug:string;categoryName:string|null;address:string|null;rating:number;reviewCount:number;isVerified:boolean;latitude:number;longitude:number;distanceKm:number;phone:string|null;imageUrl:string|null}
export type Review={reviewId:number;businessId:number;userId:number;userName:string;rating:number;review:string|null;createdDate:string;isApproved:boolean}
export type Booking={bookingId:number;businessId:number;customerId:number;businessName:string;serviceName:string|null;bookingDateUtc:string;notes:string|null;status:string}
export type Enquiry={enquiryId:number;businessId:number;customerId:number;businessName:string;message:string;status:string;createdDate:string}
export type Advertisement={advertisementId:number;title:string;imageUrl:string|null;targetUrl:string|null;categoryName:string|null;cityName:string|null;startDate:string;endDate:string;isActive:boolean;impressions:number;clicks:number}
export type PresignedUploadDto={blobName:string;uploadUrl:string;publicUrl:string}
