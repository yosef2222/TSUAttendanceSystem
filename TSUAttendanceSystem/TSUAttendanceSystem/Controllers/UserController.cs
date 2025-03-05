using CampusCourses1.Controllers;
using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Services.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace TSUAttendanceSystem.Controllers;


[ApiController]
[Route("[controller]")]
public class UserController : BaseController
{
    private readonly IUserService _userService;

    public UserController(IUserService userService, ApplicationDbContext context) : base(context)
    {
        _userService = userService;
    }

    [Authorize]
    [HttpGet("users")]
    public async Task<IActionResult> GetAllUsers()
    {
        // Получаем ID текущего пользователя из токена
        var userId = Guid.Parse(User.FindFirst("Id")?.Value);
        var user = await _context.Users
            .Include(u => u.Role)
            .SingleOrDefaultAsync(u => u.Id == userId);

        // Проверяем, является ли текущий пользователь администратором
        if (user == null || !user.Role.IsAdmin)
        {
            return new ForbidResult(); // Запрещаем доступ, если пользователь не администратор
        }

        // Возвращаем список всех пользователей с их ролями
        return await _userService.GetAllUsers();
    }

    [Authorize]
    [HttpGet("roles")]
    public async Task<IActionResult> GetUserRoles()
    {
        // Получаем ID текущего пользователя из токена
        var userId = Guid.Parse(User.FindFirst("Id")?.Value);

        // Возвращаем роли текущего пользователя
        return await _userService.GetUserRoles(userId);
    }
}