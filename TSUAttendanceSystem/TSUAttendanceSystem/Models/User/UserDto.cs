using System.ComponentModel.DataAnnotations;

namespace TSUAttendanceSystem.Models;

public class UserDto
{
    [Required]
    [StringLength(50, MinimumLength = 3)]
    public string FullName { get; set; }

    [Required]
    public DateTime Birthday { get; set; }
    
    [Required]
    [EmailAddress]
    public string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 6)]
    public string Password { get; set; }
}
