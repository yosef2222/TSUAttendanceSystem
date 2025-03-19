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
        var userId = Guid.Parse(User.FindFirst("Id")?.Value);
        var user = await _context.Users
            .Include(u => u.Role)
            .SingleOrDefaultAsync(u => u.Id == userId);
        
        if (user == null || !user.Role.IsAdmin)
        {
            return new ForbidResult(); 
        }
        
        return await _userService.GetAllUsers();
    }

    [Authorize]
    [HttpGet("roles")]
    public async Task<IActionResult> GetUserRoles()
    {
        var userId = Guid.Parse(User.FindFirst("Id")?.Value);
        
        return await _userService.GetUserRoles(userId);
    }
}