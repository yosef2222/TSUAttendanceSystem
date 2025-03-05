using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Services.Auth;

var builder = WebApplication.CreateBuilder(args);

// ✅ Set app to listen on port 5000 in Docker
builder.WebHost.UseUrls("http://*:5000");

// ✅ Load configuration
var configuration = builder.Configuration;

// ✅ Ensure JWT Key exists (to avoid crashes)
var jwtKey = configuration["Jwt:Key"];
if (string.IsNullOrEmpty(jwtKey))
{
    throw new InvalidOperationException("🚨 JWT Secret is not configured! Set 'Jwt:Key' in appsettings.json or environment variables.");
}

// ✅ Register services
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ✅ Database connection with retry logic
var connectionString = configuration.GetConnectionString("DefaultConnection") 
    ?? throw new InvalidOperationException("🚨 Database connection string is missing!");

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseMySql(connectionString,
        new MySqlServerVersion(new Version(5, 7, 0)),
        mysqlOptions => mysqlOptions.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null)
    ));

// ✅ Dependency injection for authentication services
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddSingleton<JwtService>();

// ✅ Configure JWT authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = configuration["Jwt:Issuer"] ?? "defaultIssuer",
            ValidAudience = configuration["Jwt:Audience"] ?? "defaultAudience",
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

var app = builder.Build();

// ✅ Apply database migrations automatically inside Docker
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    dbContext.Database.Migrate(); // Apply any pending migrations
}

// ✅ Middleware pipeline
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

if (app.Environment.IsDevelopment() || app.Environment.IsProduction())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// ✅ Health check endpoint
app.MapGet("/", () => Results.Ok("✅ API is running successfully inside Docker!"));

app.Run();
