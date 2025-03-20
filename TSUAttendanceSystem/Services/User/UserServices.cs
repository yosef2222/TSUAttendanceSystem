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

    public async Task<List<User>> GetAllUsers(string? fullName)
    {
        var usersQuery = _context.Users
            .Include(u => u.Role)
            .AsQueryable();

        if (!string.IsNullOrEmpty(fullName))
        {
            usersQuery = usersQuery.Where(u => u.FullName.Contains(fullName));
        }

        var users = await usersQuery
            .Select(u => new User
            {
                Id = u.Id,
                FullName = u.FullName,
                Email = u.Email,
                Role = u.Role 
            })
            .ToListAsync();

        return users;
    }


    public async Task<IActionResult> GetUserRoles(Guid userId)
    {
        var user = await _context.Users
            .Include(u => u.Role)
            .SingleOrDefaultAsync(u => u.Id == userId);
        
        if (user == null)
        {
            return new NotFoundObjectResult("User not found.");
        }
        
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