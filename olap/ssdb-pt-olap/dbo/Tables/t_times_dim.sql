CREATE TABLE [dbo].[t_times_dim] (
    [id]           INT           NOT NULL,
    [date]         DATE          NOT NULL,
    [day]          INT           NULL,
    [week]         VARCHAR (50)  NULL,
    [weekNum]      VARCHAR (50)  NULL,
    [month]        VARCHAR (50)  NULL,
    [monthNum]     NVARCHAR (50) NULL,
    [DayOfWeek]    VARCHAR (50)  NULL,
    [DayOfWeekNum] NVARCHAR (50) NULL,
    [year]         INT           NULL,
    [dateName]     VARCHAR (10)  NULL,
    CONSTRAINT [PK_times_dim] PRIMARY KEY CLUSTERED ([id] ASC)
);



