create database RevatureDW
use RevatureDW

create table dim_Date(
	dateID int primary key identity,
	dateDay int,
	engNameOfDay varchar(10),
	monthNumber int,
	engNameOfMonth varchar(15),
	yearNumber int
);

create table dim_QualifiedLeads(
	qualifiedLeadID int primary key identity,
	qlFirstName varchar(30),
	qlLastName varchar(30),
	universityName varchar(100),
	degree varchar(30),
	state varchar(30),
	twoStateCode char(2)
);

create table dim_Trainer(
	trainerID int primary key identity,
	trainerFirstName varchar(30),
	trainerLastName varchar(30)
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

create table fct_Batch(
	batchID int primary key identity,
	qualifiedLeadID int,
	trainerID int,
	startDateID int,
	endDateID int,

	constraint fk_batch_qualifiedLeadID foreign key (qualifiedLeadID) references dim_QualifiedLeads,
	constraint fk_batch_trainerID foreign key (trainerID) references dim_Trainer,
	constraint fk_batch_startDateID foreign key (startDateID) references dim_Date,
	constraint fk_batch_endDateID foreign key (endDateID) references dim_Date
);

create table fct_Training(
	trainingID int primary key identity,
	startDateID int,
	endDateID int,
	batchID int,
	trainerID int,
	numPeoplePerBatch int,
	numConcurrentBatches int,
	acceptanceRatePerPeriod int

	constraint fk_training_startDateID foreign key (startDateID) references dim_Date,
	constraint fk_training_endDateID foreign key (endDateID) references dim_Date,
	constraint fk_training_batchID foreign key (batchID) references fct_Batch,
	constraint fk_training_trainerID foreign key (trainerID) references dim_Trainer,
);

create table fct_Latency(
	latencyID int primary key identity,
	contactDateID int,
	screeningDateID int,
	offerDateID int,
	actionDateID int,
	actionType varchar(10),
	
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
	screensPerDay int,
	questionsAsked int,
	answersAccepted int,
	offerStatus varchar(10),

	constraint fk_screening_dateID foreign key (dateID) references dim_Date,
	constraint fk_screening_screenerID foreign key (screenerID) references dim_Screener,
	constraint fk_screening_qualifiedLeadID foreign key (qualifiedLeadID) references dim_QualifiedLeads,
	constraint fk_screening_screenTypeID foreign key (screenTypeID) references dim_ScreenType,
);


create table fct_ContactAttempt(
	contactAttemptID int primary key,
	qualifiedLeadID int,
	contactDateID int,
	contactTypeID int,

	constraint fk_contactAttempt_qualifiedLeadID foreign key (qualifiedLeadID) references dim_QualifiedLeads,
	constraint fk_contactAttempt_contactDateID foreign key (contactDateID) references dim_Date,
	constraint fk_contactAttempt_contactTypeID foreign key (contactTypeID) references dim_ContactType,
);

alter table fct_ContactAttempt ADD recruiterID int

ALTER TABLE fct_ContactAttempt ADD FOREIGN KEY (recruiterID) REFERENCES dim_Recruiter(recruiterID);

select * from dim_Date