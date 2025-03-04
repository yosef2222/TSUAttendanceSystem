
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Models.Users;

namespace TSUAttendanceSystem.Services.Auth;

public interface IAuthService
{
    Task<string> Register(UserDto request);
    Task<string> Login(LoginDto loginDto);
    Task<UserProfileDto> GetProfile(Guid userId);
    Task<UserProfileDto> EditProfile(Guid userId, EditProfileDto request);
}