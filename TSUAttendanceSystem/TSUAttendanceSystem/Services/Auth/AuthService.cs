using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Models.Users;

namespace TSUAttendanceSystem.Services.Auth;

public class AuthService : IAuthService
{
    private readonly ApplicationDbContext _context;
    private readonly JwtService _jwtService;

    public AuthService(ApplicationDbContext context, JwtService jwtService)
    {
        _context = context;
        _jwtService = jwtService;
    }

    public async Task<string> Register(UserDto request)
    {
        // Проверяем, существует ли пользователь с таким email
        if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            throw new InvalidOperationException("User already exists.");

        // Создаем нового пользователя
        var user = new User
        {
            Email = request.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
            FullName = request.FullName,
            Birthday = request.Birthday,
            Role = new Role
            {
                IsAdmin = false, // Администратор по умолчанию false
                IsTeacher = false, // Преподаватель по умолчанию false
                IsStudent = request.IsStudent, // Студент в зависимости от выбора пользователя
                IsDean = false // Декан по умолчанию false
            }
        };

        // Добавляем пользователя в базу данных
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        // Генерируем токен для нового пользователя
        return _jwtService.GenerateToken(user);
    }

    public async Task<string> Login(LoginDto loginDto)
    {
        // Ищем пользователя по email
        var user = await _context.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Email == loginDto.Email);

        // Проверяем, существует ли пользователь и совпадает ли пароль
        if (user == null || !BCrypt.Net.BCrypt.Verify(loginDto.Password, user.PasswordHash))
            throw new UnauthorizedAccessException("Invalid credentials.");

        // Генерируем токен для авторизованного пользователя
        return _jwtService.GenerateToken(user);
    }

    public async Task<UserProfileDto> GetProfile(Guid userId)
    {
        // Ищем пользователя по ID
        var user = await _context.Users.SingleOrDefaultAsync(u => u.Id == userId);

        // Если пользователь не найден, выбрасываем исключение
        if (user == null)
            throw new KeyNotFoundException("User not found.");

        // Возвращаем профиль пользователя
        return new UserProfileDto
        {
            FullName = user.FullName,
            Email = user.Email,
            BirthDate = user.Birthday
        };
    }

    public async Task<UserProfileDto> EditProfile(Guid userId, EditProfileDto request)
    {
        // Ищем пользователя по ID
        var user = await _context.Users.SingleOrDefaultAsync(u => u.Id == userId);

        // Если пользователь не найден, выбрасываем исключение
        if (user == null)
            throw new KeyNotFoundException("User not found.");

        // Обновляем данные пользователя
        user.FullName = request.FullName;
        user.Birthday = request.BirthDate;

        // Сохраняем изменения в базе данных
        _context.Users.Update(user);
        await _context.SaveChangesAsync();

        // Возвращаем обновленный профиль пользователя
        return new UserProfileDto
        {
            FullName = user.FullName,
            Email = user.Email,
            BirthDate = user.Birthday
        };
    }
}