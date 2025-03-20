using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Services.Requests;

namespace TSUAttendanceSystem.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class RequestsController : ControllerBase
{
    private readonly IRequestsService _requestsService;

    public RequestsController(IRequestsService requestsService)
    {
        _requestsService = requestsService;
    }
    
    [Authorize(Roles = "Student, Admin")]
    [HttpPost("create")]
    public async Task<IActionResult> CreateRequest([FromForm] CreateRequestDto requestDto, [FromForm] List<IFormFile> files)
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized("Invalid token: User ID not found or is invalid.");
        }

        var request = await _requestsService.CreateRequestAsync(userId.Value, requestDto, files);
        return CreatedAtAction(nameof(GetMyRequests), new { id = request.Id }, request);
    }

    [Authorize(Roles = "Student, Admin")]
    [HttpGet("my")]
    public async Task<IActionResult> GetMyRequests()
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized("Invalid token: User ID not found or is invalid.");

        var requests = await _requestsService.GetMyRequestsAsync(userId.Value);
        return Ok(requests);
    }

    [Authorize(Roles = "Admin, Dean")]
    [HttpGet("pending")]
    public async Task<IActionResult> GetPendingRequests([FromQuery] string? groupNumber)
    {
        var requests = await _requestsService.GetPendingRequestsAsync(groupNumber);

        return Ok(requests);
    }


    [Authorize(Roles = "Student, Admin")]
    [HttpPut("{id}/edit-end-date")]
    public async Task<IActionResult> EditRequestEndDate(Guid id, [FromForm] EditRequestEndDateDto requestDto, [FromForm] List<IFormFile> files)
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized("Invalid token: User ID not found or is invalid.");
        }

        var request = await _requestsService.EditRequestEndDateAsync(userId.Value, id, requestDto, files);
        return Ok(request);
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

        var result = await _requestsService.ReviewRequestAsync(userId.Value, id, reviewDto);
        return Ok(result);
    }

    [Authorize]
    [HttpGet("{requestId}/files/{fileId}")]
    public async Task<IActionResult> GetFile(Guid requestId, Guid fileId)
    {
        var file = await _requestsService.GetFileAsync(requestId, fileId);
        return File(file.Data, file.ContentType, file.FileName);
    }

    private Guid? GetUserId()
    {
        var userIdClaim = User.FindFirst("Id")?.Value;
        if (string.IsNullOrEmpty(userIdClaim))
        {
            return null;
        }

        if (!Guid.TryParse(userIdClaim, out var userId))
        {
            return null;
        }

        return userId;
    }

    [Authorize(Roles = "Admin, Dean, Teacher")]
    [HttpGet("approved")]
    public async Task<ActionResult<List<RequestDetailsDto>>> GetApprovedRequests([FromQuery] string? groupNumber)
    {
        var requests = await _requestsService.GetApprovedRequestsAsync(groupNumber);

        return Ok(requests);
    }


}