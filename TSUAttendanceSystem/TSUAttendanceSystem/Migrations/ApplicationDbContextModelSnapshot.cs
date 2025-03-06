﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using TSUAttendanceSystem.Data;

#nullable disable

namespace TSUAttendanceSystem.Migrations
{
    [DbContext(typeof(ApplicationDbContext))]
    partial class ApplicationDbContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.2")
                .HasAnnotation("Relational:MaxIdentifierLength", 64);

            MySqlModelBuilderExtensions.AutoIncrementColumns(modelBuilder);

            modelBuilder.Entity("TSUAttendanceSystem.Models.Request", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("char(36)");

                    b.Property<DateTime>("AbsenceDateEnd")
                        .HasColumnType("datetime(6)");

                    b.Property<DateTime>("AbsenceDateStart")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("Reason")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<Guid?>("ReviewedById")
                        .HasColumnType("char(36)");

                    b.Property<int>("Status")
                        .HasColumnType("int");

                    b.Property<Guid>("StudentId")
                        .HasColumnType("char(36)");

                    b.HasKey("Id");

                    b.HasIndex("ReviewedById");

                    b.HasIndex("StudentId");

                    b.ToTable("Requests");
                });

            modelBuilder.Entity("TSUAttendanceSystem.Models.Role", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("char(36)");

                    b.Property<bool>("IsAdmin")
                        .HasColumnType("tinyint(1)");

                    b.Property<bool>("IsDean")
                        .HasColumnType("tinyint(1)");

                    b.Property<bool>("IsStudent")
                        .HasColumnType("tinyint(1)");

                    b.Property<bool>("IsTeacher")
                        .HasColumnType("tinyint(1)");

                    b.Property<Guid>("UserId")
                        .HasColumnType("char(36)");

                    b.HasKey("Id");

                    b.HasIndex("UserId")
                        .IsUnique();

                    b.ToTable("Roles");
                });

            modelBuilder.Entity("TSUAttendanceSystem.Models.User", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("char(36)");

                    b.Property<DateTime>("Birthday")
                        .HasColumnType("datetime(6)");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("FullName")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("longtext");

                    b.HasKey("Id");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("TSUAttendanceSystem.Models.Request", b =>
                {
                    b.HasOne("TSUAttendanceSystem.Models.User", "ReviewedBy")
                        .WithMany("ReviewedRequests")
                        .HasForeignKey("ReviewedById")
                        .OnDelete(DeleteBehavior.SetNull);

                    b.HasOne("TSUAttendanceSystem.Models.User", "Student")
                        .WithMany("Requests")
                        .HasForeignKey("StudentId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("ReviewedBy");

                    b.Navigation("Student");
                });

            modelBuilder.Entity("TSUAttendanceSystem.Models.Role", b =>
                {
                    b.HasOne("TSUAttendanceSystem.Models.User", "User")
                        .WithOne("Role")
                        .HasForeignKey("TSUAttendanceSystem.Models.Role", "UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("User");
                });

            modelBuilder.Entity("TSUAttendanceSystem.Models.User", b =>
                {
                    b.Navigation("Requests");

                    b.Navigation("ReviewedRequests");

                    b.Navigation("Role")
                        .IsRequired();
                });
#pragma warning restore 612, 618
        }
    }
}
