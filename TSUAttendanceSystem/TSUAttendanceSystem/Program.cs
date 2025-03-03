var builder = WebApplication.CreateBuilder(args);

builder.WebHost.UseUrls("http://*:5000");
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment() || app.Environment.IsProduction())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();


app.MapGet("/", () => Results.Ok("✅ API is running successfully inside Docker!"));

app.Run();