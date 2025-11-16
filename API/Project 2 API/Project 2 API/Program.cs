using Microsoft.EntityFrameworkCore;
using Project_2_API.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("myString");
builder.Services.AddDbContext<Project2DatabaseContext>(option =>
{
option.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString));
});

builder.Services.AddCors(option =>{
    option.AddPolicy("AllowFlutterApp", policy =>{
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
        });
    });

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwaggerUI(option =>
    {
        option.SwaggerEndpoint("/openapi/v1.json", "Project 2 API");
    });
}

app.UseAuthorization();

app.MapControllers();

app.UseCors("AllowFlutterApp");

app.Run();
