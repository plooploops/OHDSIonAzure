﻿CREATE TABLE [dbo].[person] (
    [person_id]                   INT           NOT NULL,
    [gender_concept_id]           INT           NOT NULL,
    [year_of_birth]               INT           NOT NULL,
    [month_of_birth]              INT           NULL,
    [day_of_birth]                INT           NULL,
    [birth_datetime]              DATETIME2 (7) NULL,
    [race_concept_id]             INT           NOT NULL,
    [ethnicity_concept_id]        INT           NOT NULL,
    [location_id]                 INT           NULL,
    [provider_id]                 INT           NULL,
    [care_site_id]                INT           NULL,
    [person_source_value]         VARCHAR (50)  NULL,
    [gender_source_value]         VARCHAR (50)  NULL,
    [gender_source_concept_id]    INT           NULL,
    [race_source_value]           VARCHAR (50)  NULL,
    [race_source_concept_id]      INT           NULL,
    [ethnicity_source_value]      VARCHAR (50)  NULL,
    [ethnicity_source_concept_id] INT           NULL
);

