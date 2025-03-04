using System.ComponentModel.DataAnnotations;

namespace TSUAttendanceSystem.Models.Users;

public class EditProfileDto
{
    [Required]
    public string FullName { get; set; }

    [Required]
    public DateTime BirthDate { get; set; }
}
