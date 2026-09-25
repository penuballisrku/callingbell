using System.Security.Claims;
using CallingBell.Api.Contracts;
using CallingBell.Api.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CallingBell.Api.Controllers;

[ApiController,Route("api/v1")]
public sealed class PlatformController(IPlatformRepository repository):ControllerBase
{
    private long UserId=>long.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier)??User.FindFirstValue(ClaimTypes.NameIdentifier),out var id)?id:0;

    [HttpGet("businesses/nearby")]
    public async Task<ActionResult<ApiResponse<IReadOnlyList<NearbyBusinessDto>>>> Nearby(double latitude,double longitude,double radiusKm=10,long? categoryId=null,int page=1,int pageSize=20,CancellationToken ct=default)
        =>Ok(ApiResponse<IReadOnlyList<NearbyBusinessDto>>.Ok(await repository.GetNearbyBusinessesAsync(latitude,longitude,Math.Clamp(radiusKm,0.5,100),categoryId,page,pageSize,ct)));

    [HttpGet("businesses/{businessId:long}/reviews")]
    public async Task<ActionResult<ApiResponse<IReadOnlyList<ReviewDto>>>> Reviews(long businessId,int page=1,int pageSize=20,CancellationToken ct=default)
        =>Ok(ApiResponse<IReadOnlyList<ReviewDto>>.Ok(await repository.GetReviewsAsync(businessId,page,pageSize,ct)));

    [Authorize,HttpPost("reviews")]
    public async Task<ActionResult<ApiResponse<long>>> CreateReview(ReviewRequest request,CancellationToken ct)=>Ok(ApiResponse<long>.Ok(await repository.CreateReviewAsync(UserId,request,ct),"Review submitted for moderation"));

    [Authorize,HttpGet("bookings")]
    public async Task<ActionResult<ApiResponse<IReadOnlyList<BookingDto>>>> Bookings(CancellationToken ct)=>Ok(ApiResponse<IReadOnlyList<BookingDto>>.Ok(await repository.GetBookingsAsync(UserId,ct)));

    [Authorize,HttpPost("bookings")]
    public async Task<ActionResult<ApiResponse<long>>> CreateBooking(BookingRequest request,CancellationToken ct)=>Ok(ApiResponse<long>.Ok(await repository.CreateBookingAsync(UserId,request,ct),"Booking created"));

    [Authorize,HttpGet("enquiries")]
    public async Task<ActionResult<ApiResponse<IReadOnlyList<EnquiryDto>>>> Enquiries(CancellationToken ct)=>Ok(ApiResponse<IReadOnlyList<EnquiryDto>>.Ok(await repository.GetEnquiriesAsync(UserId,ct)));

    [Authorize,HttpPost("enquiries")]
    public async Task<ActionResult<ApiResponse<long>>> CreateEnquiry(EnquiryRequest request,CancellationToken ct)=>Ok(ApiResponse<long>.Ok(await repository.CreateEnquiryAsync(UserId,request,ct),"Enquiry submitted"));

    [Authorize,HttpGet("businesses/{businessId:long}/leads")]
    public async Task<ActionResult<ApiResponse<IReadOnlyList<LeadDto>>>> Leads(long businessId,CancellationToken ct)=>Ok(ApiResponse<IReadOnlyList<LeadDto>>.Ok(await repository.GetBusinessLeadsAsync(businessId,ct)));

    [HttpGet("advertisements")]
    public async Task<ActionResult<ApiResponse<IReadOnlyList<AdvertisementDto>>>> Advertisements(long? categoryId,long? cityId,CancellationToken ct)=>Ok(ApiResponse<IReadOnlyList<AdvertisementDto>>.Ok(await repository.GetActiveAdvertisementsAsync(categoryId,cityId,ct)));

    [Authorize,HttpPost("advertisements")]
    public async Task<ActionResult<ApiResponse<long>>> CreateAdvertisement(AdvertisementRequest request,CancellationToken ct)=>Ok(ApiResponse<long>.Ok(await repository.CreateAdvertisementAsync(UserId,request,ct),"Advertisement created"));

    [HttpPost("advertisements/{advertisementId:long}/impression")]
    public async Task<ActionResult<ApiResponse<object>>> Impression(long advertisementId,CancellationToken ct){await repository.TrackAdvertisementAsync(advertisementId,false,ct);return Ok(ApiResponse<object>.Ok(new{}));}

    [HttpPost("advertisements/{advertisementId:long}/click")]
    public async Task<ActionResult<ApiResponse<object>>> Click(long advertisementId,CancellationToken ct){await repository.TrackAdvertisementAsync(advertisementId,true,ct);return Ok(ApiResponse<object>.Ok(new{}));}
}
