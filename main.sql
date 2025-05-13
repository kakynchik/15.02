create database AcademyDB;
go
use AcademyDB;
go

create table Curators
(
    CuratorsID int primary key identity (1, 1) not null,
    CuratorsName varchar(100) not null check (CuratorsName <> ''),
    CuratorsSurname varchar(100) not null check (CuratorsSurname <> ''),
);
go

create table Faculties
(
    FacultyID int primary key identity (1, 1) not null,
    FacultyName varchar(100) not null check (FacultyName <> ''),
    FacultyFinancing money not null check (FacultyFinancing > 0) default 0,
);
go

create table Departments
(
    DepartmentID int primary key identity (1, 1) not null,
    DepartmentName varchar(100) not null unique check (DepartmentName <> ''),
    DepartmentFinancing money not null check (DepartmentFinancing > 0) default 0,
    FacultyID int not null foreign key references Faculties (FacultyID),
);
go

create table Groups
(
    GroupID int primary key identity (1, 1) not null,
    GroupName varchar(100) not null check (GroupName <> ''),
    GroupYear int not null check (GroupYear between 1 and 5),
    DepartmentID int not null foreign key references Departments (DepartmentID),
);
go

create table GroupsCurators
(
    GroupCuratorsID int primary key identity (1, 1) not null,
    CuratorID int not null foreign key references Curators (CuratorsID),
    GroupID int not null foreign key references Groups (GroupID),
);
go

create table GroupsLectures
(
    GroupsLecturesID int primary key identity (1, 1) not null,
    GroupID int not null foreign key references Groups (GroupID),
    LectureID int not null foreign key references Lectures (LectureID),
);
go

create table Lectures
(
    LectureID int primary key identity (1, 1) not null,
    LectureRoom varchar(100) not null check (LectureRoom <> ''),
    SubjectID int not null foreign key references Subjects (SubjectID),
    TeacherID int not null foreign key references Teachers (TeacherID),
);
go

create table Subjects
(
    SubjectID int primary key identity (1, 1) not null,
    SubjectName varchar(100) not null unique check (SubjectName <> '') unique,
);
go

create table Teachers
(
    TeacherID int primary key identity (1, 1) not null,
    TeacherName varchar(100) not null check (TeacherName <> ''),
    TeacherSurname varchar(100) not null check (TeacherSurname <> ''),
    TeacherSalary money not null check (TeacherSalary > 0),
);
go

insert into Curators (CuratorsName, CuratorsSurname) values
('Ivan', 'Ivanov'),
('Petr', 'Petrov'),
('Sidor', 'Sidorov'),
('Vasiliy', 'Vasiliev'),
('Alex', 'Alexeev');
go

insert into Faculties (FacultyName, FacultyFinancing) values
('Faculty of Computer Science', 100000),
('Faculty of Mathematics', 200000),
('Faculty of Physics', 300000),
('Faculty of Chemistry', 400000),
('Faculty of Biology', 500000);
go

insert into Departments (DepartmentName, DepartmentFinancing, FacultyID) values
('Department of Computer Science', 10000, 1),
('Department of Mathematics', 20000, 2),
('Department of Physics', 30000, 3),
('Department of Chemistry', 40000, 4),
('Department of Biology', 50000, 5);
go

insert into Groups (GroupName, GroupYear, DepartmentID) values
('CS-101', 1, 1),
('CS-102', 1, 1),
('CS-201', 2, 1),
('CS-202', 2, 1),
('CS-301', 3, 1);
go

insert into GroupsCurators (CuratorID, GroupID) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
go

insert into GroupsLectures (GroupID, LectureID) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
go

insert into Subjects (SubjectName) values
('Mathematics'),
('Physics'),
('Chemistry'),
('Biology'),
('Computer Science');
go

insert into Teachers (TeacherName, TeacherSurname, TeacherSalary) values
('Ivan', 'Ivanov', 1000),
('Petr', 'Petrov', 2000),
('Sidor', 'Sidorov', 3000),
('Vasiliy', 'Vasiliev', 4000),
('Alex', 'Alexeev', 5000);
go

insert into Lectures (LectureRoom, SubjectID, TeacherID) values
('101', 1, 1),
('102', 2, 2),
('103', 3, 3),
('104', 4, 4),
('105', 5, 5);
go

select * from Curators;
select * from Faculties;
select * from Departments;
select * from Groups;
select * from GroupsCurators;
select * from GroupsLectures;
select * from Lectures;
select * from Subjects;
select * from Teachers;

select t.TeacherName, t.TeacherSurname, g.GroupName
from Teachers t, Groups g;
go

select
    t.TeacherName,
    t.TeacherSurname,
    g.GroupName
from
    Teachers t,
    Groups g;
go

select
    c.CuratorsSurname,
    g.GroupName
from
    Curators c
        join
    GroupsCurators gc on c.CuratorsID = gc.CuratorID
        join
    Groups g on gc.GroupID = g.GroupID;
go

select
    t.TeacherName,
    t.TeacherSurname
from
    Teachers t
        join
    Lectures l on t.TeacherID = l.TeacherID
        join
    GroupsLectures gl on l.LectureID = gl.LectureID
        join
    Groups g on gl.GroupID = g.GroupID
where
    g.GroupName = 'P107';
go

select
    t.TeacherSurname,
    f.FacultyName
from
    Teachers t
        join
    Lectures l on t.TeacherID = l.TeacherID
        join
    Subjects s on l.SubjectID = s.SubjectID
        join
    Departments d on s.SubjectID = d.DepartmentID
        join
    Faculties f on d.FacultyID = f.FacultyID;
go

select
    t.TeacherSurname,
    f.FacultyName
from
    Teachers t
        join
    Lectures l on t.TeacherID = l.TeacherID
        join
    Subjects s on l.SubjectID = s.SubjectID
        join
    Departments d on s.SubjectID = d.DepartmentID
        join
    Faculties f on d.FacultyID = f.FacultyID;

select
    d.DepartmentName,
    g.GroupName
from
    Departments d
        join
    Groups g on d.DepartmentID = g.DepartmentID;

select
    d.DepartmentName,
    g.GroupName
from
    Departments d
        join
    Groups g on d.DepartmentID = g.DepartmentID;

select
    s.SubjectName
from
    Subjects s
        join
    Lectures l on s.SubjectID = l.SubjectID
        join
    Teachers t on l.TeacherID = t.TeacherID
where
    t.TeacherName = 'Samantha' and t.TeacherSurname = 'Adams';

select
    s.SubjectName
from
    Subjects s
        join
    Lectures l on s.SubjectID = l.SubjectID
        join
    Teachers t on l.TeacherID = t.TeacherID
where
    t.TeacherName = 'Samantha' and t.TeacherSurname = 'Adams';

select
    d.DepartmentName
from
    Departments d
        join
    Subjects s on d.DepartmentID = s.SubjectID
where
    s.SubjectName = 'Database Theory';

select
    g.GroupName
from
    Groups g
        join
    Departments d on g.DepartmentID = d.DepartmentID
        join
    Faculties f on d.FacultyID = f.FacultyID
where
    f.FacultyName = 'Computer Science';

select
    g.GroupName,
    f.FacultyName
from
    Groups g
        join
    Departments d on g.DepartmentID = d.DepartmentID
        join
    Faculties f on d.FacultyID = f.FacultyID
where
    g.GroupYear = 5;

select
    g.GroupName,
    f.FacultyName
from
    Groups g
        join
    Departments d on g.DepartmentID = d.DepartmentID
        join
    Faculties f on d.FacultyID = f.FacultyID
where
    g.GroupYear = 5;

select
    t.TeacherName + ' ' + t.TeacherSurname as TeacherFullName,
    s.SubjectName,
    g.GroupName
from
    Teachers t
        join
    Lectures l on t.TeacherID = l.TeacherID
        join
    Subjects s on l.SubjectID = s.SubjectID
        join
    GroupsLectures gl on l.LectureID = gl.LectureID
        join
    Groups g on gl.GroupID = g.GroupID
where
    l.LectureRoom = 'B103';

use master;
go
drop database AcademyDB;
go