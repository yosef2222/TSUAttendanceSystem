using System;
using System.ComponentModel.DataAnnotations;

namespace TSUAttendanceSystem.Models;

public class CurrentDateAttribute : ValidationAttribute
{
    public override bool IsValid(object value)
    {
        if (value is DateTime date)
        {
            return date <= DateTime.Now;
        }
        return false;
    }
}