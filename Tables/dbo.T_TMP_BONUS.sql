﻿CREATE TABLE [dbo].[T_TMP_BONUS] (
  [AutoID] [int] NULL,
  [CodCom] [varchar](6) NULL,
  [Tipo] [varchar](5) NULL,
  [NumTipo] [varchar](20) NULL,
  [FecTx] [varchar](8) NULL,
  [HoraTx] [varchar](6) NULL,
  [IDPos] [varchar](6) NULL,
  [SecPos] [varchar](6) NULL,
  [DetLineas] [varchar](8000) NULL,
  [NumSerie] [varchar](4) NULL,
  [NumFac] [int] NULL,
  [Nombre] [varchar](35) NULL,
  [Doc_ID] [varchar](15) NULL,
  [SaldPuntos] [varchar](15) NULL,
  [AcumPuntos] [varchar](15) NULL,
  [VencPuntos] [varchar](15) NULL,
  [TotSoles] [varchar](7) NULL,
  [Flag_Operacion] [varchar](1) NULL,
  [Mensaje_Resp] [varchar](100) NULL,
  [Flag_Retorno] [varchar](3) NULL,
  [Estado] [varchar](1) NULL,
  [Cons_Mens_Resp] [varchar](50) NULL,
  [Cons_Flag_Ret] [varchar](3) NULL,
  [PreAf_Bonus] [varchar](20) NULL,
  [Fec_Reg] [datetime] NULL,
  [Fec_Act] [datetime] NULL
)
ON [PRIMARY]
GO