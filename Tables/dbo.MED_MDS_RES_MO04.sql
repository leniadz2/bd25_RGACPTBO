﻿CREATE TABLE [dbo].[MED_MDS_RES_MO04] (
  [AutoID] [int] IDENTITY,
  [CodCom] [varchar](6) COLLATE Modern_Spanish_CI_AS NULL,
  [Tipo] [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
  [NumTipo] [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
  [FecTx] [varchar](8) COLLATE Modern_Spanish_CI_AS NULL,
  [HoraTx] [varchar](6) COLLATE Modern_Spanish_CI_AS NULL,
  [IDPos] [varchar](6) COLLATE Modern_Spanish_CI_AS NULL,
  [SecPos] [varchar](6) COLLATE Modern_Spanish_CI_AS NULL,
  [DetLineas] [varchar](4096) COLLATE Modern_Spanish_CI_AS NULL,
  [NumSerie] [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
  [NumFac] [int] NULL,
  [Nombre] [varchar](35) COLLATE Modern_Spanish_CI_AS NULL,
  [Doc_ID] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
  [SaldPuntos] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
  [AcumPuntos] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
  [VencPuntos] [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
  [TotSoles] [varchar](7) COLLATE Modern_Spanish_CI_AS NULL,
  [Flag_Operacion] [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
  [Mensaje_Resp] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
  [Flag_Retorno] [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
  [Estado] [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
  [Cons_Mens_Resp] [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
  [Cons_Flag_Ret] [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
  [PreAf_Bonus] [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
  [Fec_Reg] [datetime] NULL,
  [Fec_Act] [datetime] NULL
)
ON [PRIMARY]
GO