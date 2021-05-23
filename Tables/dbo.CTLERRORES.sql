CREATE TABLE [dbo].[CTLERRORES] (
  [ErrorID] [int] IDENTITY,
  [FechaHora] [varchar](16) NOT NULL,
  [Tabla] [varchar](16) NOT NULL,
  [UserName] [varchar](100) NULL,
  [ErrorNumber] [int] NULL,
  [ErrorState] [int] NULL,
  [ErrorSeverity] [int] NULL,
  [ErrorLine] [int] NULL,
  [ErrorProcedure] [varchar](max) NULL,
  [ErrorMessage] [varchar](max) NULL,
  [ErrorDateTime] [datetime] NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO