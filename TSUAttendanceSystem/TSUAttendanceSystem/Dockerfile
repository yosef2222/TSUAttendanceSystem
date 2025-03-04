FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TSUAttendanceSystem.csproj", "./"]
RUN dotnet restore "./TSUAttendanceSystem.csproj"
COPY . .
RUN dotnet build "./TSUAttendanceSystem.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./TSUAttendanceSystem.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# Ensure config is copied
COPY appsettings.json .  

# ✅ Install dotnet-ef globally
RUN dotnet tool install --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"

# ✅ Apply migrations before starting the API
ENTRYPOINT ["sh", "-c", "dotnet ef database update && dotnet TSUAttendanceSystem.dll"]
