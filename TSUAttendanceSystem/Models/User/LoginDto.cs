using System.ComponentModel.DataAnnotations;

namespace TSUAttendanceSystem.Models;

public class LoginDto
{
    [Required]
    [EmailAddress]
    public string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 6)]
    public string Password { get; set; }
}
