using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using CallingBell.Api.Contracts;
using CallingBell.Api.Data;
using Microsoft.IdentityModel.Tokens;

namespace CallingBell.Api.Services;

public sealed class AuthService(IPlatformRepository repository,IConfiguration configuration)
{
    public async Task<AuthResultDto> RegisterAsync(RegisterRequest request,CancellationToken ct)
    {
        var email=request.Email.Trim().ToLowerInvariant();
        if(await repository.FindUserByEmailAsync(email,ct) is not null) throw new BusinessValidationException("EMAIL_EXISTS","An account with this email already exists.");
        var user=await repository.CreateUserAsync(request.Name.Trim(),email,HashPassword(request.Password),ct);
        return IssueToken(user);
    }

    public async Task<AuthResultDto> LoginAsync(LoginRequest request,CancellationToken ct)
    {
        var user=await repository.FindUserByEmailAsync(request.Email.Trim().ToLowerInvariant(),ct);
        if(user is null || !VerifyPassword(request.Password,user.Value.PasswordHash)) throw new BusinessValidationException("INVALID_CREDENTIALS","Email or password is incorrect.");
        return IssueToken(new AuthUserDto(user.Value.UserId,user.Value.Name,user.Value.Email,user.Value.Role));
    }

    private AuthResultDto IssueToken(AuthUserDto user)
    {
        var key=configuration["Jwt:Key"];
        if(string.IsNullOrWhiteSpace(key)||key.Length<32) throw new BusinessValidationException("JWT_NOT_CONFIGURED","Authentication is not configured.");
        var minutes=int.TryParse(configuration["Jwt:AccessTokenMinutes"],out var value)?value:60;
        var expires=DateTime.UtcNow.AddMinutes(minutes);
        var claims=new[]{new Claim(JwtRegisteredClaimNames.Sub,user.UserId.ToString()),new Claim(JwtRegisteredClaimNames.Email,user.Email),new Claim(ClaimTypes.Name,user.Name),new Claim(ClaimTypes.Role,user.Role)};
        var credentials=new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key)),SecurityAlgorithms.HmacSha256);
        var token=new JwtSecurityToken(claims:claims,expires:expires,signingCredentials:credentials);
        return new AuthResultDto(user,new JwtSecurityTokenHandler().WriteToken(token),expires);
    }

    private static string HashPassword(string password)
    {
        Span<byte> salt=stackalloc byte[16]; RandomNumberGenerator.Fill(salt);
        var hash=Rfc2898DeriveBytes.Pbkdf2(password,salt,120000,HashAlgorithmName.SHA256,32);
        return $"v1.{Convert.ToBase64String(salt)}.{Convert.ToBase64String(hash)}";
    }

    private static bool VerifyPassword(string password,string encoded)
    {
        var parts=encoded.Split('.');
        if(parts.Length!=3||parts[0]!="v1") return false;
        var salt=Convert.FromBase64String(parts[1]); var expected=Convert.FromBase64String(parts[2]);
        var actual=Rfc2898DeriveBytes.Pbkdf2(password,salt,120000,HashAlgorithmName.SHA256,expected.Length);
        return CryptographicOperations.FixedTimeEquals(actual,expected);
    }
}
