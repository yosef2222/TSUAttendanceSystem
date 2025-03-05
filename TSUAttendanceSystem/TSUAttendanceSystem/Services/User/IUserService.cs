namespace TSUAttendanceSystem.Services.Auth;

using Microsoft.AspNetCore.Mvc;

public interface IUserService
{
    Task<IActionResult> GetAllUsers(); // Метод для получения всех пользователей с их ролями
    Task<IActionResult> GetUserRoles(Guid userId); // Метод для получения ролей конкретного пользователя
}