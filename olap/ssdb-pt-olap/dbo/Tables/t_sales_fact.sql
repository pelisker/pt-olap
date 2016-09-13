CREATE TABLE [dbo].[t_sales_fact] (
    [ID]        INT              IDENTITY (1, 1) NOT NULL,
    [date]      INT              NOT NULL,
    [numberDoc] UNIQUEIDENTIFIER NOT NULL,
    [statusDoc] UNIQUEIDENTIFIER NOT NULL,
    [unit]      UNIQUEIDENTIFIER NOT NULL,
    [tovar]     UNIQUEIDENTIFIER NOT NULL,
    [quantity]  INT              NULL,
    [amount]    MONEY            NULL,
    CONSTRAINT [PK_t_trans] PRIMARY KEY CLUSTERED ([ID] ASC)
);



