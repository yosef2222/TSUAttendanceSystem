using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TSUAttendanceSystem.Services.Role;

namespace TSUAttendanceSystem.Controllers;

[Authorize(Roles = "Admin,Dean")]
[Route("api/[controller]")]
[ApiController]
public class RolesController : ControllerBase
{
    private readonly IRolesService _rolesService;

    public RolesController(IRolesService rolesService)
    {
        _rolesService = rolesService;
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("grant-dean/{userId}")]
    public async Task<IActionResult> GrantDeanRole(Guid userId)
    {
        try
        {
            var result = await _rolesService.GrantDeanRoleAsync(userId);
            return Ok(new { message = result });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }

    [Authorize(Roles = "Admin,Dean")]
    [HttpPut("grant-teacher/{userId}")]
    public async Task<IActionResult> GrantTeacherRole(Guid userId)
    {
        try
        {
            var result = await _rolesService.GrantTeacherRoleAsync(userId);
            return Ok(new { message = result });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }
}