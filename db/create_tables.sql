CREATE TABLE [dbo].[jobs]
(
	[id] [int] NOT NULL,
	[job] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[jobs] ADD PRIMARY KEY CLUSTERED 
(
	[id] ASC
)
GO
CREATE TABLE [dbo].[departments]
(
	[id] [int] NOT NULL,
	[department] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[departments] ADD PRIMARY KEY CLUSTERED 
(
	[id] ASC
)
GO
CREATE TABLE [dbo].[hired_employees]
(
	[id] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[datetime] [nvarchar](50) NOT NULL,
	[department_id] [int] NOT NULL,
	[job_id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[hired_employees] ADD PRIMARY KEY CLUSTERED 
(
	[id] ASC
)