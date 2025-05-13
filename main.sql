create database HospitalDB;
go
use HospitalDB;
go

create table Doctor
(
    DoctorID int primary key,
    DoctorName varchar(50),
    DoctorSpeciality varchar(50),
    DoctorSalary int
);

use master;
go
drop database HospitalDB;
go