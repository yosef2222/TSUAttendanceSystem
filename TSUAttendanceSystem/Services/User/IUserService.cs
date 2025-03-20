namespace TSUAttendanceSystem.Services.Auth;

using Microsoft.AspNetCore.Mvc;
using TSUAttendanceSystem.Models;
public interface IUserService
{
    Task<List<User>> GetAllUsers(string? fullName); 
    Task<IActionResult> GetUserRoles(Guid userId); 
}