using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Models.Users;
using TSUAttendanceSystem.Services.Auth;

namespace TSUAttendanceSystem.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [AllowAnonymous]
    [HttpPost("register")]
    public async Task<IActionResult> Register(UserDto request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState); // Возвращаем ошибки валидации
        }

        try
        {
            var token = await _authService.Register(request);
            return Ok(new { Token = token });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [AllowAnonymous]
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginDto loginDto)
    {
        try
        {
            // Авторизуем пользователя и получаем токен
            var token = await _authService.Login(loginDto);
            return Ok(new { Token = token });
        }
        catch (UnauthorizedAccessException ex)
        {
            // Обрабатываем ошибку, если учетные данные неверны
            return Unauthorized(ex.Message);
        }
    }

    [Authorize]
    [HttpGet("profile")]
    public async Task<IActionResult> GetProfile()
    {
        // Получаем ID пользователя из токена
        var userIdClaim = User.FindFirst("Id")?.Value;
        if (string.IsNullOrEmpty(userIdClaim))
            return Unauthorized("Invalid token: User ID not found.");

        var userId = Guid.Parse(userIdClaim);

        try
        {
            // Получаем профиль пользователя
            var profile = await _authService.GetProfile(userId);
            return Ok(profile);
        }
        catch (KeyNotFoundException ex)
        {
            // Обрабатываем ошибку, если пользователь не найден
            return NotFound(ex.Message);
        }
    }

    [Authorize]
    [HttpPut("profile")]
    public async Task<IActionResult> EditProfile(EditProfileDto request)
    {
        // Получаем ID пользователя из токена
        var userIdClaim = User.FindFirst("Id")?.Value;
        if (string.IsNullOrEmpty(userIdClaim))
            return Unauthorized("Invalid token: User ID not found.");

        var userId = Guid.Parse(userIdClaim);

        try
        {
            // Редактируем профиль пользователя
            var profile = await _authService.EditProfile(userId, request);
            return Ok(profile);
        }
        catch (KeyNotFoundException ex)
        {
            // Обрабатываем ошибку, если пользователь не найден
            return NotFound(ex.Message);
        }
    }
}