create database RevatureDatabase

use RevatureDatabase

create table tbl_Screeners
(
	scrId int primary key,
	scrFirstName varchar(255),
	scrLastName varchar(255)
)

create table tbl_Recruiters
(
	recId int primary key,
	recFirstName varchar(255),
	recLastName varchar(255)
)

create table tbl_States
(
	stateAbbrev varchar(2) primary key,
	stateFull varchar(50)
)

create table tbl_QualifiedLeads
(
	qlId int primary key,
	qlFirstName varchar(255),
	qlLastName varchar(255),
	qlUniversity varchar(255),
	qlMajor varchar(255),
	qlEmail varchar(255) unique,
	qlState varchar(2),
	constraint fk_QualifiedLeads_stateAbbrev foreign key(qlState) references tbl_States
)

create table tbl_ContactAttempts
(
	contId int primary key identity,
	recId int,
	qlId int,
	contDate date,
	contStartTime time,
	contEndTime time,
	contMethod varchar(255),
	constraint fk_ContactAttempts_recId foreign key(recId) references tbl_Recruiters,
	constraint fk_ContactAttempts_qlId foreign key(qlId) references tbl_QualifiedLeads
)

create table tbl_Screenings
(
	screeningId int primary key identity,
	scrId int,
	qlId int,
	screeningDate date,
	screeingStartTime time,
	screeningEndTime time,
	screeningType varchar(255),
	screeningQuestions int,
	screeningAnswers int,
	constraint fk_Screenings_scrId foreign key(scrId) references tbl_Screeners,
	constraint fk_Screenings_qlId foreign key(qlId) references tbl_QualifiedLeads
)

create table tbl_Offers
(
	offerId int primary key identity,
	scrId int,
	recId int,
	qlId int,
	offerExtDate date,
	offerActDate date,
	offerContactMethod varchar(255),
	offerAction varchar(255),
	constraint fk_Offers_scrId foreign key(scrId) references tbl_Screeners,
	constraint fk_Offers_recId foreign key(recId) references tbl_Recruiters,
	constraint fk_Offers_qlId foreign key(qlId) references tbl_QualifiedLeads
)
