using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Models.Enums;
using TSUAttendanceSystem.Services.Auth;

namespace TSUAttendanceSystem.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class RequestsController : ControllerBase
{
    private readonly ApplicationDbContext _context;
    private readonly IAuthService _authService;

    public RequestsController(ApplicationDbContext context, IAuthService authService)
    {
        _context = context;
        _authService = authService;
    }

    [Authorize(Roles = "Student, Teacher")]
    [HttpPost]
    public async Task<IActionResult> CreateRequest([FromBody] CreateRequestDto requestDto)
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized("Invalid token: User ID not found or is invalid.");
        }

        var request = new Request
        {
            Id = Guid.NewGuid(),
            StudentId = userId.Value,
            Reason = requestDto.Reason,
            AbsenceDateStart = requestDto.AbsenceDateStart,
            AbsenceDateEnd = requestDto.AbsenceDateEnd,
            Status = RequestStatus.Pending
        };

        _context.Requests.Add(request);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetMyRequests), new { id = request.Id }, request);
    }

    [Authorize(Roles = "Student, Teacher")]
    [HttpGet("my")]
    public async Task<IActionResult> GetMyRequests()
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized("Invalid token: User ID not found or is invalid.");
        }

        var requests = await _context.Requests
            .Where(r => r.StudentId == userId.Value)
            .ToListAsync();

        return Ok(requests);
    }

    [Authorize(Roles = "Admin,Dean")]
    [HttpGet("pending")]
    public async Task<IActionResult> GetPendingRequests()
    {
        var requests = await _context.Requests
            .Where(r => r.Status == RequestStatus.Pending)
            .Include(r => r.Student)
            .ToListAsync();

        return Ok(requests);
    }

    [Authorize(Roles = "Admin,Dean")]
    [HttpPut("{id}/review")]
    public async Task<IActionResult> ReviewRequest(Guid id, [FromBody] ReviewRequestDto reviewDto)
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized("Invalid token: User ID not found or is invalid.");
        }

        var request = await _context.Requests.FindAsync(id);
        if (request == null)
        {
            return NotFound("Request not found.");
        }

        if (request.Status != RequestStatus.Pending)
        {
            return BadRequest("This request has already been reviewed.");
        }

        request.Status = reviewDto.Approve ? RequestStatus.Approved : RequestStatus.Rejected;
        request.ReviewedById = userId.Value;

        await _context.SaveChangesAsync();
        return Ok(request);
    }

    private Guid? GetUserId()
    {
        var userIdClaim = User.FindFirst("Id")?.Value; // Получаем значение claim "Id"
        if (string.IsNullOrEmpty(userIdClaim))
        {
            return null; // Если claim отсутствует, возвращаем null
        }

        if (!Guid.TryParse(userIdClaim, out var userId))
        {
            return null; // Если значение не является корректным GUID, возвращаем null
        }

        return userId;
    }
}