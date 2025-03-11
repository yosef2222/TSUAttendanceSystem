using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Models.Enums;
namespace TSUAttendanceSystem.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class RequestsController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public RequestsController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpPost]
    public async Task<IActionResult> CreateRequest([FromForm] CreateRequestDto requestDto, [FromForm] List<IFormFile> files)
    {
        if (requestDto.AbsenceDateStart > requestDto.AbsenceDateEnd)
        {
            return BadRequest("AbsenceDateStart cannot be later than AbsenceDateEnd.");
        }

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
        
        if (files != null && files.Any())
        {
            foreach (var file in files)
            {
                if (file.Length > 0)
                {
                    using var memoryStream = new MemoryStream();
                    await file.CopyToAsync(memoryStream);

                    var uploadedFile = new FileDocument
                    {
                        Id = Guid.NewGuid(),
                        FileName = file.FileName,
                        ContentType = file.ContentType,
                        Data = memoryStream.ToArray(),
                        RequestId = request.Id
                    };

                    _context.Files.Add(uploadedFile);
                }
            }
            await _context.SaveChangesAsync();
        }

        return CreatedAtAction(nameof(GetMyRequests), new { id = request.Id }, request);
    }

    
    [Authorize(Roles = "Student, Teacher, Admin")]
    [HttpGet("my")]
    public async Task<IActionResult> GetMyRequests()
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized("Invalid token: User ID not found or is invalid.");

        var requests = await _context.Requests
            .Where(r => r.StudentId == userId.Value)
            .Include(r => r.Files) 
            .Select(r => new RequestDetailsDto
            {
                Id = r.Id,
                Reason = r.Reason,
                AbsenceDateStart = r.AbsenceDateStart,
                AbsenceDateEnd = r.AbsenceDateEnd,
                Status = r.Status,
                StudentFullName = r.Student.FullName,
                ReviewedByFullName = r.ReviewedBy != null ? r.ReviewedBy.FullName : null,
                FileIds = r.Files.Select(f => f.Id).ToList() 
            })
            .ToListAsync();

        return Ok(requests);
    }
    
    [Authorize(Roles = "Admin, Dean")]
    [HttpGet("pending")]
    public async Task<IActionResult> GetPendingRequests()
    {
        var requests = await _context.Requests
            .Where(r => r.Status == RequestStatus.Pending)
            .Include(r => r.Student)
            .Include(r => r.ReviewedBy)
            .Include(r => r.Files) 
            .Select(r => new RequestDetailsDto
            {
                Id = r.Id,
                Reason = r.Reason,
                AbsenceDateStart = r.AbsenceDateStart,
                AbsenceDateEnd = r.AbsenceDateEnd,
                Status = r.Status,
                StudentFullName = r.Student.FullName,
                ReviewedByFullName = r.ReviewedBy != null ? r.ReviewedBy.FullName : null,
                FileIds = r.Files.Select(f => f.Id).ToList() 
            })
            .ToListAsync();

        return Ok(requests);
    }

    [Authorize(Roles = "Student, Teacher, Admin")]
    [HttpPut("{id}/edit-end-date")]
    public async Task<IActionResult> EditRequestEndDate(Guid id, [FromForm] EditRequestEndDateDto requestDto, [FromForm] List<IFormFile> files)
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

        if (request.StudentId != userId.Value)
        {
            return Forbid("You can only edit your own requests.");
        }

        if (request.AbsenceDateStart > requestDto.AbsenceDateEnd)
        {
            return BadRequest("AbsenceDateStart cannot be later than AbsenceDateEnd.");
        }

        request.AbsenceDateEnd = requestDto.AbsenceDateEnd;
        request.Status = RequestStatus.Pending;

        _context.Requests.Update(request);
        
        if (files != null && files.Any())
        {
            foreach (var file in files)
            {
                if (file.Length > 0)
                {
                    using var memoryStream = new MemoryStream();
                    await file.CopyToAsync(memoryStream);

                    var uploadedFile = new FileDocument
                    {
                        Id = Guid.NewGuid(),
                        FileName = file.FileName,
                        ContentType = file.ContentType,
                        Data = memoryStream.ToArray(),
                        RequestId = request.Id
                    };

                    _context.Files.Add(uploadedFile);
                }
            }
        }

        await _context.SaveChangesAsync();

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

        var request = await _context.Requests
            .Include(r => r.Student)
            .Include(r => r.ReviewedBy)
            .FirstOrDefaultAsync(r => r.Id == id);

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
        
        var result = new RequestDetailsDto
        {
            Id = request.Id,
            Reason = request.Reason,
            AbsenceDateStart = request.AbsenceDateStart,
            AbsenceDateEnd = request.AbsenceDateEnd,
            Status = request.Status,
            StudentFullName = request.Student.FullName,
            ReviewedByFullName = request.ReviewedBy?.FullName
        };

        return Ok(result);
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
    
    [Authorize]
    [HttpGet("{requestId}/files/{fileId}")]
    public async Task<IActionResult> GetFile(Guid requestId, Guid fileId)
    {
        var file = await _context.Files
            .Where(f => f.RequestId == requestId && f.Id == fileId)
            .FirstOrDefaultAsync();

        if (file == null)
            return NotFound("File not found.");

        return File(file.Data, file.ContentType, file.FileName);
    }
}