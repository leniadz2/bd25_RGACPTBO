CREATE TABLE [dbo].[T_new11] (
  [secuencial] [int] IDENTITY,
  [Mall] [varchar](50) NULL,
  [Retail] [varchar](50) NULL,
  [Caja] [varchar](50) NULL,
  [CodCom] [varchar](50) NULL,
  [codcta] [varchar](11) NULL,
  [dia] [varchar](2) NULL,
  [mes] [varchar](2) NULL,
  [anho] [varchar](4) NULL,
  [HHMM] [varchar](4) NULL,
  [posid] [varchar](6) NULL,
  [nroco] [varchar](6) NULL,
  [TotSoles] [varchar](50) NULL,
  [precTotEnt] [int] NULL,
  [precTotDec] [numeric](10, 4) NULL,
  [precTot] [numeric](10, 4) NULL,
  [DetLineas] [varchar](8000) NULL,
  [Periodo] [varchar](6) NULL,
  PRIMARY KEY CLUSTERED ([secuencial])
)
ON [PRIMARY]
GO