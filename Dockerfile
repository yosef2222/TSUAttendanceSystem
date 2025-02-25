# Use the official .NET runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["AttendanceTracker.csproj", "./"]
RUN dotnet restore "./AttendanceTracker.csproj"
COPY . .
RUN dotnet build "./AttendanceTracker.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "./AttendanceTracker.csproj" -c Release -o /app/publish

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AttendanceTracker.dll"]
