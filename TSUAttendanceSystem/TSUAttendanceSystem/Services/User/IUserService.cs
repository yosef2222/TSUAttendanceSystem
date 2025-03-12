namespace TSUAttendanceSystem.Services.Auth;

using Microsoft.AspNetCore.Mvc;

public interface IUserService
{
    Task<IActionResult> GetAllUsers(); 
    Task<IActionResult> GetUserRoles(Guid userId); 
}