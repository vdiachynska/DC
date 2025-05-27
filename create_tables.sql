CREATE DATABASE IF NOT EXISTS library;
USE library;

CREATE TABLE sections(
id int PRIMARY KEY AUTO_INCREMENT,
name varchar(30),
manager_id int,
founder varchar(40),
creation_date date,
books_quantity int
)

CREATE TABLE founders(
name varchar(40),
city varchar(30)
)

CREATE TABLE managers(
id int PRIMARY KEY,
full_name varchar(50),
birthdate date,
section_id int,
favourite_genre varchar(20),
favourite_book varchar(60),
salary int
)

CREATE TABLE departments(
name varchar(20),
headmen_name varchar(50),
is_under_reconstruction bool,
reconstruntion_fund int,
reconstruction_founder varchar(40)
)

CREATE TABLE books_borrowed(
 ISBN varchar(15) PRIMARY KEY,
 name varchar(60),
 genre varchar(20),
 year_of_release date,
 author varchar(50)
)