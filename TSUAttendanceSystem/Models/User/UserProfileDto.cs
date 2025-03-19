namespace TSUAttendanceSystem.Models.Users;

public class UserProfileDto
{
    public string FullName { get; set; }
    public string Email { get; set; }
    public DateTime BirthDate { get; set; }
    public string GroupNumber { get; set; }
}