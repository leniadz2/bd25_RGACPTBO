CREATE TABLE [dbo].[T_new04] (
  [secuencial] [int] NOT NULL,
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
  [cabecera] [varchar](135) NOT NULL,
  [ITEMDESC] [varchar](32) NULL,
  [ITEMNRO] [int] NULL,
  [preciotot] [numeric](10, 4) NULL,
  [codprodit] [varchar](14) NULL,
  [cantit] [varchar](8) NULL,
  [signoit] [varchar](1) NULL,
  [precioit] [varchar](6) NULL,
  [precioitem] [numeric](10, 4) NULL
)
ON [PRIMARY]
GO