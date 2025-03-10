# ✅ Base image for running the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5000

# ✅ Build stage (contains .NET SDK)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# ✅ Install dotnet-ef in the build stage
RUN dotnet tool install --global dotnet-ef
ENV PATH="${PATH}:/root/.dotnet/tools"

# ✅ Copy project file and restore dependencies
COPY TSUAttendanceSystem/TSUAttendanceSystem/*.csproj ./TSUAttendanceSystem/
WORKDIR /src/TSUAttendanceSystem
RUN dotnet restore "./TSUAttendanceSystem.csproj"

# ✅ Copy the entire project and build
COPY TSUAttendanceSystem/TSUAttendanceSystem/ ./TSUAttendanceSystem/
WORKDIR /src/TSUAttendanceSystem
RUN dotnet build "./TSUAttendanceSystem.csproj" -c Release -o /app/build

# ✅ Publish the app
FROM build AS publish
RUN dotnet publish "./TSUAttendanceSystem.csproj" -c Release -o /app/publish

# ✅ Migration stage: Run migrations before final runtime
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS migration
WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=build /root/.dotnet /root/.dotnet
ENV PATH="${PATH}:/root/.dotnet/tools"

# ✅ Apply database migrations
RUN dotnet ef database update

# ✅ Final runtime stage (only contains .NET runtime)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# ✅ Start the API
ENTRYPOINT ["dotnet", "TSUAttendanceSystem.dll"]
