namespace CallingBell.Api.Contracts;

public sealed record ApiError(string Code, string Message);

public sealed record PaginationDto(int Page, int PageSize, int TotalCount)
{
    public int TotalPages => TotalCount == 0 ? 0 : (int)Math.Ceiling(TotalCount / (double)PageSize);
}

public sealed record ApiResponse<T>(bool Success, string Message, T? Data, ApiError? Error = null, PaginationDto? Pagination = null)
{
    public static ApiResponse<T> Ok(T data, string message = "Success", PaginationDto? pagination = null) =>
        new(true, message, data, null, pagination);

    public static ApiResponse<T> Fail(string code, string message) =>
        new(false, message, default, new ApiError(code, message));
}
