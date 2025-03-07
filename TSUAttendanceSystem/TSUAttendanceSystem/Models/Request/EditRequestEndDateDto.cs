using System.ComponentModel.DataAnnotations;

namespace TSUAttendanceSystem.Models;

public class EditRequestEndDateDto
{
    [Required(ErrorMessage = "Absence end date is required.")]
    public DateTime AbsenceDateEnd { get; set; }
}