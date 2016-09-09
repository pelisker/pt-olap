CREATE TABLE [dbo].[t_sales_fact] (
    [ID]             INT              IDENTITY (1, 1) NOT NULL,
    [date]           INT              NOT NULL,
    [tovar]          UNIQUEIDENTIFIER NOT NULL,
    [unit]           UNIQUEIDENTIFIER NOT NULL,
    [quantity_sale]  INT              NULL,
    [amount_sale]    MONEY            NULL,
    [quantity_order] INT              NULL,
    [amount_order]   MONEY            NULL,
    CONSTRAINT [PK_t_trans] PRIMARY KEY CLUSTERED ([ID] ASC)
);

