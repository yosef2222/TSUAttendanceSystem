using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Services.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


namespace TSUAttendanceSystem.Controllers;

[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase
{
    private readonly IUserService _userService;
    private readonly ApplicationDbContext _context;

    public UserController(IUserService userService, ApplicationDbContext context)
    {
        _userService = userService;
        _context = context;
    }

    [Authorize(Roles = "Admin,Dean")]
    [HttpGet("users")]
    public async Task<IActionResult> GetAllUsers([FromQuery] string? fullName)
    {
        var users = await _userService.GetAllUsers(fullName);
        return Ok(users);
    }
    

    [Authorize]
    [HttpGet("roles")]
    public async Task<IActionResult> GetUserRoles()
    {
        var userId = Guid.Parse(User.FindFirst("Id")?.Value);
        return await _userService.GetUserRoles(userId);
    }
}