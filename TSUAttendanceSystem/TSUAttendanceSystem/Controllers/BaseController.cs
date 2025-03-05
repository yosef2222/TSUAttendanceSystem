using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;

namespace CampusCourses1.Controllers
{
    public class BaseController : ControllerBase
    {
        protected readonly ApplicationDbContext _context;

        public BaseController(ApplicationDbContext context)
        {
            _context = context;
        }
        
        protected async Task<bool> IsUserAdmin()
        {
            var userId = Guid.Parse(User.FindFirst("Id")?.Value); 
            var user = await _context.Users
                .Include(u => u.Role) 
                .SingleOrDefaultAsync(u => u.Id == userId);

            return user?.Role?.IsAdmin ?? false; 
        }
    }
}