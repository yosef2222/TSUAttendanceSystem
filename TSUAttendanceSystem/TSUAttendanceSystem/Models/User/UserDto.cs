using System.ComponentModel.DataAnnotations;

namespace TSUAttendanceSystem.Models;

public class UserDto
{
    [Required]
    [StringLength(50, MinimumLength = 3)]
    public string FullName { get; set; }

    [Required]
    [DataType(DataType.Date)]
    [CurrentDate(ErrorMessage = "Birthday cannot be in the future.")]
    public DateTime Birthday { get; set; }

    [Required]
    [EmailAddress]
    public string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 6)]
    [RegularExpression(@"^(?=.*\d).+$", ErrorMessage = "Password must contain at least one digit.")]
    public string Password { get; set; }

    [Required(ErrorMessage = "IsStudent field is required.")]
    public bool IsStudent { get; set; }
}