CREATE TABLE [dbo].[t_tovars_dim] (
    [id]      UNIQUEIDENTIFIER NOT NULL,
    [name]    VARCHAR (500)    NOT NULL,
    [brand]   VARCHAR (500)    NOT NULL,
    [cat_1]   VARCHAR (500)    NULL,
    [cat_2]   VARCHAR (500)    NULL,
    [cat_3]   VARCHAR (500)    NULL,
    [cat_4]   VARCHAR (500)    NULL,
    [IDcat_1] VARCHAR (11)     NULL,
    [IDcat_2] VARCHAR (11)     NULL,
    [IDcat_3] VARCHAR (11)     NULL,
    [IDcat_4] VARCHAR (11)     NULL
);



