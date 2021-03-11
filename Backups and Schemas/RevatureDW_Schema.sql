create database RevatureDW
GO
use RevatureDW
GO
create table dim_Date(
	dateID int primary key identity,
	dateDay int,
	engNameOfDay varchar(10),
	monthNumber int,
	engNameOfMonth varchar(15),
	yearNumber int,
	date date
);

create table dim_QualifiedLeads(
	qualifiedLeadID int primary key identity,
	qlFirstName varchar(30),
	qlLastName varchar(30),
	universityName varchar(100),
	degree varchar(30),
	state varchar(30),
	twoStateCode char(2),
	stem bit
);

create table dim_Recruiter(
	recruiterID int primary key identity,
	recruiterFirstName varchar(30),
	recruiterLastName varchar(30)
);

create table dim_Screener(
	screenerID int primary key identity,
	screenerFirstName varchar(30),
	screenerLastName varchar(30)
);

create table dim_ContactType(
	contactTypeID int primary key identity,
	contactType varchar(20)
);

create table dim_ScreenType(
	screenTypeID int primary key identity,
	screenType varchar(20)
);

create table fct_Training(
	trainingID int primary key identity,
	startDateID int,
	endDateID int,
	waitingPeriod int,
	numPeoplePerBatch int,
	numConcurrentBatches int,
	acceptanceRatePerPeriod numeric(3,2),

	constraint fk_training_startDateID foreign key (startDateID) references dim_Date,
	constraint fk_training_endDateID foreign key (endDateID) references dim_Date
);

create table fct_Latency(
	latencyID int primary key identity,
	qlId int,
	contactDateID int,
	screeningDateID int,
	offerDateID int,
	actionDateID int,
	actionType varchar(10),
	
	constraint fk_latency_qlId foreign key (qlId) references dim_QualifiedLeads,
	constraint fk_latency_contactDateID foreign key (contactDateID) references dim_Date,
	constraint fk_latency_screeningDateID foreign key (screeningDateID) references dim_Date,
	constraint fk_latency_offerDateID foreign key (offerDateID) references dim_Date,
	constraint fk_latency_actionDateID foreign key (actionDateID) references dim_Date,
);

create table fct_Offers(
	offerID int primary key identity,
	contactTypeID int,
	offerStartDateID int,
	offerActionDateID int,
	qualifiedLeadID int,
	recruiterID int,
	screenerID int,
	action varchar(10),

	constraint fk_offers_contactTypeID foreign key (contactTypeID) references dim_ContactType,
	constraint fk_offers_offerStartDateID foreign key (offerStartDateID) references dim_Date,
	constraint fk_offers_offerActionDateID foreign key (offerActionDateID) references dim_Date,
	constraint fk_offers_qualifiedID foreign key (qualifiedLeadID) references dim_QualifiedLeads,
	constraint fk_offers_recruiterID foreign key (recruiterID) references dim_Recruiter,
	constraint fk_offers_screenerID foreign key (screenerID) references dim_Screener
);

create table fct_Recruitment(
	recruitmentID int primary key identity,
	recruiterID int,
	dateID int,
	communicationAttemptsPerDay int,

	constraint fk_recruitment_recruiterID foreign key (recruiterID) references dim_Recruiter,
	constraint fk_recruitment_dateID foreign key (dateID) references dim_Date,
);

create table fct_Screening(
	screeningID int primary key identity,
	dateID int,
	screenerID int,
	qualifiedLeadID int,
	screenTypeID int,
	questionsAsked int,
	answersAccepted int,
	offerStatus varchar(10),

	constraint fk_screening_dateID foreign key (dateID) references dim_Date,
	constraint fk_screening_screenerID foreign key (screenerID) references dim_Screener,
	constraint fk_screening_qualifiedLeadID foreign key (qualifiedLeadID) references dim_QualifiedLeads,
	constraint fk_screening_screenTypeID foreign key (screenTypeID) references dim_ScreenType,
);

create table fct_ScreenerUtilization(
    utilizationID int primary key identity(1,1),
    screenerID int not null,
    dateID int not null,
    screeningsCompleted int not null,
    utilizationRate decimal(9,2)

    constraint fk_screenerUtilization_screenerID foreign key(screenerID) references dim_Screener,
    constraint fk_screenerUtilization_dateID foreign key(dateID) references dim_Date
);



create table fct_ContactAttempt(
	contactAttemptID int primary key,
	qualifiedLeadID int,
	contactDateID int,
	contactTypeID int,
	recruiterID int,

	constraint fk_contactAttempt_qualifiedLeadID foreign key (qualifiedLeadID) references dim_QualifiedLeads,
	constraint fk_contactAttempt_contactDateID foreign key (contactDateID) references dim_Date,
	constraint fk_contactAttempt_contactTypeID foreign key (contactTypeID) references dim_ContactType,
	constraint fk_contactAttempt_recruiterID foreign key (recruiterID) references dim_Recruiter
);