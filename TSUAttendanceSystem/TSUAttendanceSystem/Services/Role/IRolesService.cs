namespace TSUAttendanceSystem.Services.Role;

public interface IRolesService
{
    Task<string> GrantDeanRoleAsync(Guid userId);
    Task<string> GrantTeacherRoleAsync(Guid userId);
}