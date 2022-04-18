﻿CREATE TABLE [dbo].[provider] (
    [provider_id]                 INT           NOT NULL,
    [provider_name]               VARCHAR (255) NULL,
    [NPI]                         VARCHAR (20)  NULL,
    [DEA]                         VARCHAR (20)  NULL,
    [specialty_concept_id]        INT           NULL,
    [care_site_id]                INT           NULL,
    [year_of_birth]               INT           NULL,
    [gender_concept_id]           INT           NULL,
    [provider_source_value]       VARCHAR (50)  NULL,
    [specialty_source_value]      VARCHAR (50)  NULL,
    [specialty_source_concept_id] INT           NULL,
    [gender_source_value]         VARCHAR (50)  NULL,
    [gender_source_concept_id]    INT           NULL,
    CONSTRAINT [xpk_provider] PRIMARY KEY NONCLUSTERED ([provider_id] ASC),
    CONSTRAINT [fpk_provider_care_site] FOREIGN KEY ([care_site_id]) REFERENCES [dbo].[care_site] ([care_site_id]),
    CONSTRAINT [fpk_provider_gender] FOREIGN KEY ([gender_concept_id]) REFERENCES [dbo].[concept] ([concept_id]),
    CONSTRAINT [fpk_provider_gender_s] FOREIGN KEY ([gender_source_concept_id]) REFERENCES [dbo].[concept] ([concept_id]),
    CONSTRAINT [fpk_provider_specialty] FOREIGN KEY ([specialty_concept_id]) REFERENCES [dbo].[concept] ([concept_id]),
    CONSTRAINT [fpk_provider_specialty_s] FOREIGN KEY ([specialty_source_concept_id]) REFERENCES [dbo].[concept] ([concept_id])
);

