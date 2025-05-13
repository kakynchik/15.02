create database HospitalDB;
go
use HospitalDB;
go

--1.
create table Departments
(
    DepartmentID int primary key identity (1, 1) not null,
    DepartmentName varchar(100) not null unique check (DepartmentName <> ''),
);
go

--2.
create table Doctors
(
    DoctorID int primary key identity (1, 1) not null,
    DoctorName varchar(100) not null check (DoctorName <> ''),
    DoctorSurname varchar(100) not null check (DoctorSurname <> ''),
    DoctorSalary money not null check (DoctorSalary > 0),
    DoctorPremium money not null check (DoctorPremium >= 0) default 0,
);
go

--5.
create table Specializations
(
    SpecializationID int primary key identity (1, 1) not null,
    SpecializationName varchar(100) not null unique check (SpecializationName <> ''),
);
go

--6.
create table Sponsors
(
    SponsorID int primary key identity (1, 1) not null,
    SponsorName varchar(100) not null check (SponsorName <> '') unique,
);
go

--7.
create table Vacations
(
    VacationID int primary key identity (1, 1) not null,
    VacationStartDate date not null,
    VacationEndDate date not null check (VacationEndDate <= getdate()),
    DoctorID int not null foreign key references Doctors (DoctorID),
);
go

--8.
create table Wards
(
    WardID int primary key identity (1, 1) not null,
    WardName varchar(100) not null check (WardName <> '') unique,
    DepartmentID int not null foreign key references Departments (DepartmentID),
);
go

--4.
create table Donations
(
    DonationID int primary key identity (1, 1) not null,
    DonationAmount money not null check (DonationAmount > 0),
    DonationDate date not null check (DonationDate <= getdate()) default getdate(),
    DepartmentID int not null foreign key references Departments (DepartmentID),
    SponsorID int not null foreign key references Sponsors (SponsorID),
);
go

--3.
create table DoctorsSpecializations
(
    DoctorSpecializationID int primary key identity (1, 1) not null,
    DoctorID int not null foreign key references Doctors (DoctorID),
    SpecializationID int not null foreign key references Specializations (SpecializationID),
);
go

insert into Departments (DepartmentName) values
                                             ('Cardiology'),
                                             ('Neurology'),
                                             ('Oncology'),
                                             ('Pediatrics'),
                                             ('Psychiatry'),
                                             ('Surgery');
go

insert into Doctors (DoctorName, DoctorSurname, DoctorSalary, DoctorPremium) values
                                                                                 ('John', 'Doe', 1000, 100),
                                                                                 ('Jane', 'Doe', 1200, 200),
                                                                                 ('Jack', 'Smith', 1500, 300),
                                                                                 ('Jill', 'Smith', 1300, 250),
                                                                                 ('Jim', 'Brown', 1100, 150),
                                                                                 ('Jill', 'Brown', 1400, 250);
go

insert into Specializations (SpecializationName) values
                                                     ('Cardiologist'),
                                                     ('Neurologist'),
                                                     ('Oncologist'),
                                                     ('Pediatrician'),
                                                     ('Psychiatrist'),
                                                     ('Surgeon');
go

insert into DoctorsSpecializations (DoctorID, SpecializationID) values
                                                                    (1, 1),
                                                                    (2, 2),
                                                                    (3, 3),
                                                                    (4, 4),
                                                                    (5, 5),
                                                                    (6, 6);
go

insert into Donations (DonationAmount, DepartmentID, SponsorID) values
                                                                    (1000, 1, 1),
                                                                    (2000, 2, 2),
                                                                    (3000, 3, 3),
                                                                    (4000, 4, 4),
                                                                    (5000, 5, 5),
                                                                    (6000, 6, 6);
go

insert into Sponsors (SponsorName) values
                                       ('John Doe'),
                                       ('Jane Doe'),
                                       ('Jack Smith'),
                                       ('Jill Smith'),
                                       ('Jim Brown'),
                                       ('Jill Brown');
go

insert into Vacations (VacationStartDate, VacationEndDate, DoctorID) values
                                                                         ('2020-01-01', '2020-01-10', 1),
                                                                         ('2020-02-01', '2020-02-10', 2),
                                                                         ('2020-03-01', '2020-03-10', 3),
                                                                         ('2020-04-01', '2020-04-10', 4),
                                                                         ('2020-05-01', '2020-05-10', 5),
                                                                         ('2020-06-01', '2020-06-10', 6);
go

insert into Wards (WardName, DepartmentID) values
                                               ('Cardiology Ward', 1),
                                               ('Neurology Ward', 2),
                                               ('Oncology Ward', 3),
                                               ('Pediatrics Ward', 4),
                                               ('Psychiatry Ward', 5),
                                               ('Surgery Ward', 6);
go

select * from Departments;
select * from Doctors;
select * from DoctorsSpecializations;
select * from Donations;
select * from Specializations;
select * from Sponsors;
select * from Vacations;
select * from Wards;

select DoctorName + ' ' + DoctorSurname as DoctorFullName, SpecializationName  from Doctors, Specializations, DoctorsSpecializations
where Doctors.DoctorID = DoctorsSpecializations.DoctorID
go

select d.DoctorSurname, (d.DoctorSalary + d.DoctorPremium) as DoctorMoney from Doctors d
                                                                                   left join Vacations v on d.DoctorID = v.DoctorID
where v.DoctorID is null
go

select w.WardName from Wards w
                           join Departments D on w.DepartmentID = D.DepartmentID
where D.DepartmentName = 'Cardiology'
go

select d.DepartmentName from Departments d
                                 join Donations D2 on d.DepartmentID = D2.DepartmentID
                                 join Sponsors S on D2.SponsorID = S.SponsorID
where S.SponsorName = 'John Doe'
go

select d.DepartmentName, s.SponsorName, dn.DonationAmount, dn.DonationDate from Donations dn
                                                                                    join Departments d on dn.DepartmentID = d.DepartmentID
                                                                                    join Sponsors s on dn.SponsorID = s.SponsorID
where dn.DonationDate >= dateadd(month, -1, getdate())
go

select d.DoctorSurname, dep.DepartmentName from Doctors d
                                                    join Departments dep on d.DoctorID = dep.DepartmentID
where datename(month, getdate()) = 'January'
go

select w.WardName, d.DepartmentName from Doctors doc
                                             join Wards w on doc.DoctorID = w.DepartmentID
                                             join Departments d on w.DepartmentID = d.DepartmentID
where doc.DoctorName = 'Helen' and doc.DoctorSurname = 'Williams';
go

select dn.DepartmentName, d.DoctorName, d.DoctorSurname from Departments dn
                                                                 join Donations D on dn.DepartmentID = D.DepartmentID
                                                                 join Doctors d on dn.DepartmentID = d.DoctorID
where d.DoctorSalary > 10000
go