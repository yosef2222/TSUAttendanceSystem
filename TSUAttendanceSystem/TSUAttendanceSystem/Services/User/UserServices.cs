using TSUAttendanceSystem.Services.Auth;

namespace TSUAttendanceSystem.Services;

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Models;

public class UserService : IUserService
{
    private readonly ApplicationDbContext _context;

    public UserService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IActionResult> GetAllUsers()
    {
        // Получаем всех пользователей с их ролями
        var users = await _context.Users
            .Include(u => u.Role)
            .Select(u => new
            {
                Id = u.Id,
                FullName = u.FullName,
                Email = u.Email,
                Role = new
                {
                    IsStudent = u.Role.IsStudent,
                    IsTeacher = u.Role.IsTeacher,
                    IsAdmin = u.Role.IsAdmin,
                    IsDean = u.Role.IsDean
                }
            })
            .ToListAsync();

        // Возвращаем список пользователей с их ролями
        return new OkObjectResult(users);
    }

    public async Task<IActionResult> GetUserRoles(Guid userId)
    {
        // Ищем пользователя по ID
        var user = await _context.Users
            .Include(u => u.Role)
            .SingleOrDefaultAsync(u => u.Id == userId);

        // Если пользователь не найден, возвращаем ошибку 404
        if (user == null)
        {
            return new NotFoundObjectResult("User not found.");
        }

        // Возвращаем роли пользователя
        var roles = new
        {
            IsStudent = user.Role.IsStudent,
            IsTeacher = user.Role.IsTeacher,
            IsAdmin = user.Role.IsAdmin,
            IsDean = user.Role.IsDean
        };

        return new OkObjectResult(roles);
    }
}