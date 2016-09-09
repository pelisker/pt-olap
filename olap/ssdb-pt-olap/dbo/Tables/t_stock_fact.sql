CREATE TABLE [dbo].[t_stock_fact] (
    [date]     INT              NULL,
    [tovar]    UNIQUEIDENTIFIER NOT NULL,
    [store]    UNIQUEIDENTIFIER NOT NULL,
    [quantity] INT              NOT NULL
);

