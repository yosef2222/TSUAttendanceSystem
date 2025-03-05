
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace TSUAttendanceSystem.Models;

public class JwtService
{
    private readonly string _secret;
    private readonly string _issuer;
    private readonly string _audience;
    private readonly int _tokenLifetimeInHours;

    public JwtService(IConfiguration config)
    {
        _secret = config["Jwt:Key"] ?? throw new InvalidOperationException("JWT Secret is not configured");
        _issuer = config["Jwt:Issuer"] ?? throw new InvalidOperationException("JWT Issuer is not configured");
        _audience = config["Jwt:Audience"] ?? throw new InvalidOperationException("JWT Audience is not configured");
        _tokenLifetimeInHours = int.Parse(config["Jwt:TokenLifetimeInHours"] ?? "1");
    }

    public string GenerateToken(User user)
    {
        if (user == null) throw new ArgumentNullException(nameof(user));

        var claims = new List<Claim>
        {
            new Claim("Id", user.Id.ToString()),
            new Claim(JwtRegisteredClaimNames.Sub, user.FullName ?? string.Empty),
            new Claim(JwtRegisteredClaimNames.Email, user.Email ?? string.Empty),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        if (user.Role != null)
        {
            if (user.Role.IsAdmin) claims.Add(new Claim(ClaimTypes.Role, "Admin"));
            if (user.Role.IsTeacher) claims.Add(new Claim(ClaimTypes.Role, "Teacher"));
            if (user.Role.IsStudent) claims.Add(new Claim(ClaimTypes.Role, "Student"));
            if (user.Role.IsDean) claims.Add(new Claim(ClaimTypes.Role, "Dean"));
        }

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_secret));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _issuer,
            audience: _audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: DateTime.UtcNow.AddHours(_tokenLifetimeInHours),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
