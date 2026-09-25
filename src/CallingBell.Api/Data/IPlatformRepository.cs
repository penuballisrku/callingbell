using CallingBell.Api.Contracts;

namespace CallingBell.Api.Data;

public interface IPlatformRepository
{
    Task<(long UserId, string Name, string Email, string Role, string PasswordHash)?> FindUserByEmailAsync(string email, CancellationToken ct);
    Task<AuthUserDto> CreateUserAsync(string name, string email, string passwordHash, CancellationToken ct);
    Task<IReadOnlyList<NearbyBusinessDto>> GetNearbyBusinessesAsync(double latitude, double longitude, double radiusKm, long? categoryId, int page, int pageSize, CancellationToken ct);
    Task<IReadOnlyList<ReviewDto>> GetReviewsAsync(long businessId, int page, int pageSize, CancellationToken ct);
    Task<long> CreateReviewAsync(long userId, ReviewRequest request, CancellationToken ct);
    Task<long> CreateBookingAsync(long userId, BookingRequest request, CancellationToken ct);
    Task<IReadOnlyList<BookingDto>> GetBookingsAsync(long userId, CancellationToken ct);
    Task<long> CreateEnquiryAsync(long userId, EnquiryRequest request, CancellationToken ct);
    Task<IReadOnlyList<EnquiryDto>> GetEnquiriesAsync(long userId, CancellationToken ct);
    Task<long> CreateLeadAsync(long? customerId, long? businessId, string message, CancellationToken ct);
    Task<IReadOnlyList<LeadDto>> GetBusinessLeadsAsync(long businessId, CancellationToken ct);
    Task<IReadOnlyList<AdvertisementDto>> GetActiveAdvertisementsAsync(long? categoryId, long? cityId, CancellationToken ct);
    Task<long> CreateAdvertisementAsync(long userId, AdvertisementRequest request, CancellationToken ct);
    Task TrackAdvertisementAsync(long advertisementId, bool click, CancellationToken ct);
}
