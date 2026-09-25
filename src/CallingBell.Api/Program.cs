using CallingBell.Api.Contracts;
using CallingBell.Api.Data;
using CallingBell.Api.Middleware;
using CallingBell.Api.Services;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.InvalidModelStateResponseFactory = context =>
    {
        var message = context.ModelState.Values
            .SelectMany(value => value.Errors)
            .Select(error => string.IsNullOrWhiteSpace(error.ErrorMessage) ? "The request is invalid." : error.ErrorMessage)
            .FirstOrDefault() ?? "The request is invalid.";

        return new BadRequestObjectResult(ApiResponse<object>.Fail("VALIDATION_FAILED", message));
    };
});
builder.Services.AddOpenApi();
builder.Services.AddHealthChecks();
builder.Services.AddSingleton<ISqlConnectionFactory, SqlConnectionFactory>();
builder.Services.AddScoped<ICallingBellRepository, CallingBellRepository>();
builder.Services.AddScoped<IHomeService, HomeService>();
builder.Services.AddScoped<IDashboardService, DashboardService>();
builder.Services.AddScoped<IBusinessService, BusinessService>();

var allowedOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
builder.Services.AddCors(options =>
{
    options.AddPolicy("CallingBell", policy =>
    {
        if (allowedOrigins.Length > 0)
        {
            policy.WithOrigins(allowedOrigins).AllowAnyHeader().AllowAnyMethod();
        }
        else
        {
            policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
        }
    });
});

var app = builder.Build();

app.UseMiddleware<ApiExceptionMiddleware>();
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}
else
{
    app.UseHttpsRedirection();
}

app.UseCors("CallingBell");
app.UseAuthorization();
app.MapHealthChecks("/health");
app.MapControllers();
app.Run();

public partial class Program;
