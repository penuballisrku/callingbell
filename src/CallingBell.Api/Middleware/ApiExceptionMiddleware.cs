using CallingBell.Api.Contracts;
using CallingBell.Api.Data;
using CallingBell.Api.Services;
using Microsoft.Data.SqlClient;

namespace CallingBell.Api.Middleware;

public sealed class ApiExceptionMiddleware(RequestDelegate next, ILogger<ApiExceptionMiddleware> logger)
{
    public async Task Invoke(HttpContext context)
    {
        try
        {
            await next(context);
        }
        catch (DatabaseConfigurationException exception)
        {
            logger.LogWarning(exception, "Calling Bell database configuration is unavailable.");
            await WriteErrorAsync(context, StatusCodes.Status503ServiceUnavailable, "DATABASE_UNAVAILABLE", "Service data is temporarily unavailable.");
        }
        catch (SqlException exception)
        {
            logger.LogError(exception, "Calling Bell database operation failed.");
            await WriteErrorAsync(context, StatusCodes.Status503ServiceUnavailable, "DATABASE_UNAVAILABLE", "Service data is temporarily unavailable.");
        }
        catch (BusinessValidationException exception)
        {
            await WriteErrorAsync(context, StatusCodes.Status400BadRequest, exception.Code, exception.Message);
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "Unhandled application error.");
            await WriteErrorAsync(context, StatusCodes.Status500InternalServerError, "INTERNAL_ERROR", "An unexpected error occurred.");
        }
    }

    private static async Task WriteErrorAsync(HttpContext context, int statusCode, string code, string message)
    {
        if (context.Response.HasStarted)
        {
            return;
        }

        context.Response.StatusCode = statusCode;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(ApiResponse<object>.Fail(code, message));
    }
}
