using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;

namespace TSUAttendanceSystem.Services.Role;

public class RolesService : IRolesService
{
    private readonly ApplicationDbContext _context;

    public RolesService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<string> GrantDeanRoleAsync(Guid userId)
    {
        var user = await _context.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            throw new KeyNotFoundException("User not found.");
        }

        user.Role.IsDean = true;
        await _context.SaveChangesAsync();

        return $"User {user.FullName} is now a Dean.";
    }

    public async Task<string> GrantTeacherRoleAsync(Guid userId)
    {
        var user = await _context.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            throw new KeyNotFoundException("User not found.");
        }

        user.Role.IsTeacher = true;
        await _context.SaveChangesAsync();

        return $"User {user.FullName} is now a Teacher.";
    }
}