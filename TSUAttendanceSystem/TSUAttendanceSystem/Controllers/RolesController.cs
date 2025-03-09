using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;

namespace TSUAttendanceSystem.Controllers;

[Authorize(Roles = "Admin,Dean")]
[Route("api/[controller]")]
[ApiController]
public class RolesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public RolesController(ApplicationDbContext context)
    {
        _context = context;
    }
    
    [Authorize(Roles = "Admin")]
    [HttpPut("grant-dean/{userId}")]
    public async Task<IActionResult> GrantDeanRole(Guid userId)
    {
        var user = await _context.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound("User not found.");

        user.Role.IsDean = true;
        await _context.SaveChangesAsync();

        return Ok(new { message = $"User {user.FullName} is now a Dean." });
    }

    [Authorize(Roles = "Admin,Dean")]
    [HttpPut("grant-teacher/{userId}")]
    public async Task<IActionResult> GrantTeacherRole(Guid userId)
    {
        var user = await _context.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == userId);
        if (user == null) return NotFound("User not found.");

        user.Role.IsTeacher = true;
        await _context.SaveChangesAsync();

        return Ok(new { message = $"User {user.FullName} is now a Teacher." });
    }
}
