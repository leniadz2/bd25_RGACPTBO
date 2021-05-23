SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CARGA] AS
BEGIN
/***************************************************************************************************
Procedure:          dbo.CARGA
Create Date:        20201126
Author:             dÁlvarez
Description:        carga desde las cajas la tabla tmp_bonus y las consolida en la tabla TRAMA.
                    la tabla TRAMAH es la historia de todas las ejecuciones.
Call by:            none
Affected table(s):  all
Used By:            equipo comercial CCPN, MdS
Parameter(s):       tabla CTLCARGAS - lista de cajas
                      campo FLAG_RG:
                      1 carga
                      0 no carga
                    tabla PRM_COMERCIO - locales retail
                      campo FLAG_RC:
                      1 logica de recargo consumo
                      0 no logica de recargo consumo
                    tabla PRM_RANGO - fechas
                      campo PERIODOINI: año mes limite inicial
                      campo PERIODOFIN: año mes limite final
Log:                tabla CTLERRORES
****************************************************************************************************
SUMMARY OF CHANGES
Date(YYYYMMDD)      Author              Comments
------------------- ------------------- ------------------------------------------------------------
20201130            dÁlvarez            creación

***************************************************************************************************/

declare @cDate nvarchar(8);
declare @cTime nvarchar(8);
declare @cDaTi nvarchar(16);

DECLARE @count INT,
        @sql   NVARCHAR(1000),
        @table NVARCHAR(16),
        @ip    NVARCHAR(15),
        @dumm  INT;

--division trama detalle
DECLARE @i INT = 1,
        @j INT = 1,
        @largo INT,
        @itera INT,
        @iSbtIni INT,
        @iSbtLen INT = 32,
        @iCorrel INT,
        @iStrLen INT,
        @cSbtIni NVARCHAR(10),
        @cSbtLen NVARCHAR(10),
        @cCorrel NVARCHAR(10),
        @cStrLen NVARCHAR(10);

set @cDate = CONVERT(varchar, getdate(), 112);
set @cTime = REPLACE(CONVERT(varchar(8),getdate(),108),':','')
set @cDaTi = CONCAT(@cDate,@cTime)

--TRUNCATE
TRUNCATE TABLE T_new01;
TRUNCATE TABLE T_new02;
TRUNCATE TABLE T_new03;
TRUNCATE TABLE T_new04;
TRUNCATE TABLE T_new05;
TRUNCATE TABLE T_new06;
TRUNCATE TABLE T_new07;
TRUNCATE TABLE T_new08;

TRUNCATE TABLE T_new11;
TRUNCATE TABLE T_new12;
TRUNCATE TABLE T_new13;
TRUNCATE TABLE T_new14;
TRUNCATE TABLE T_new18;

TRUNCATE TABLE T_TMP_BONUS;
TRUNCATE TABLE T_TMP_BONUS_CONS;
TRUNCATE TABLE TRAMA;

print concat('ingesta ini :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

DECLARE cur_controlClon CURSOR LOCAL FOR SELECT tabla, ip FROM CTLCARGAS WHERE FLAG_RG = 1;
OPEN cur_controlClon;

  FETCH NEXT FROM cur_controlClon INTO @table, @ip;
  WHILE @@fetch_status = 0
  BEGIN

    --**TRUNCATE**
    SET @sql = N'TRUNCATE TABLE ' + @table;
    EXEC sp_executesql @sql;

    --**CARGA**
    BEGIN TRY

       SET @sql = N'insert into '+ @table +' 
( CodCom, Tipo, NumTipo, FecTx, HoraTx, IDPos,
SecPos, DetLineas, NumSerie, NumFac, Nombre, Doc_ID,
SaldPuntos, AcumPuntos, VencPuntos, TotSoles, Flag_Operacion,
Mensaje_Resp, Flag_Retorno, Estado, Cons_Mens_Resp,
Cons_Flag_Ret, PreAf_Bonus, Fec_Reg, Fec_Act )
select 
CodCom, Tipo, NumTipo, FecTx, HoraTx, IDPos,
SecPos, DetLineas, NumSerie, NumFac, Nombre, Doc_ID,
SaldPuntos, AcumPuntos, VencPuntos, TotSoles, Flag_Operacion,
Mensaje_Resp, Flag_Retorno, Estado, Cons_Mens_Resp,
Cons_Flag_Ret, PreAf_Bonus, Fec_Reg, Fec_Act
FROM ['+ @ip +'].[ICGFRONT].[dbo].[Tmp_Bonus] T'
       EXEC sp_executesql @sql;

    END TRY
    BEGIN CATCH
       INSERT INTO dbo.CTLERRORES
       VALUES (@cDaTi,
               @table,
               SUSER_SNAME(),
               ERROR_NUMBER(),
               ERROR_STATE(),
               ERROR_SEVERITY(),
               ERROR_LINE(),
               ERROR_PROCEDURE(),
               ERROR_MESSAGE(),
               GETDATE());
    END CATCH;

    SET @dumm = ERROR_NUMBER();

    ----**CONSOLIDACION**
    IF isnull(@dumm,0) = 0
       BEGIN

          SET @sql = N'INSERT INTO T_TMP_BONUS 
(AutoID, CodCom, Tipo, NumTipo, FecTx, HoraTx, IDPos,
SecPos, DetLineas, NumSerie, NumFac, Nombre, Doc_ID,
SaldPuntos, AcumPuntos, VencPuntos, TotSoles, Flag_Operacion,
Mensaje_Resp, Flag_Retorno, Estado, Cons_Mens_Resp,
Cons_Flag_Ret, PreAf_Bonus, Fec_Reg, Fec_Act) 
SELECT 
AutoID, CodCom, Tipo, NumTipo, FecTx, HoraTx, IDPos,
SecPos, DetLineas, NumSerie, NumFac, Nombre, Doc_ID,
SaldPuntos, AcumPuntos, VencPuntos, TotSoles, Flag_Operacion,
Mensaje_Resp, Flag_Retorno, Estado, Cons_Mens_Resp,
Cons_Flag_Ret, PreAf_Bonus, Fec_Reg, Fec_Act
FROM ' + @table;
          EXEC sp_executesql @sql;

          SET @sql = N'INSERT INTO T_TMP_BONUS_CONS 
(Mall, Retail, Caja,
AutoID, CodCom, Tipo, NumTipo, FecTx, HoraTx, IDPos,
SecPos, DetLineas, NumSerie, NumFac, Nombre, Doc_ID,
SaldPuntos, AcumPuntos, VencPuntos, TotSoles, Flag_Operacion,
Mensaje_Resp, Flag_Retorno, Estado, Cons_Mens_Resp,
Cons_Flag_Ret, PreAf_Bonus, Fec_Reg, Fec_Act,
Flag_MAY_0, conta) 
SELECT 
SUBSTRING(''' + @table + ''', 5, 3),
CONCAT(SUBSTRING(''' + @table + ''', 1, 4),SUBSTRING(''' + @table + ''', 9, 3)),
SUBSTRING(''' + @table + ''', 13, 4),
AutoID, CodCom, Tipo, NumTipo, FecTx, HoraTx, IDPos,
SecPos, DetLineas, NumSerie, NumFac, Nombre, Doc_ID,
SaldPuntos, AcumPuntos, VencPuntos, TotSoles, Flag_Operacion,
Mensaje_Resp, Flag_Retorno, Estado, Cons_Mens_Resp,
Cons_Flag_Ret, PreAf_Bonus, Fec_Reg, Fec_Act,
CASE AcumPuntos*1 WHEN 0 THEN ''No'' ELSE ''Sí'' END AS Flag_MAY_0,
LEN(DetLineas) as conta 
FROM T_TMP_BONUS';
          EXEC sp_executesql @sql;

          SET @sql = N'TRUNCATE TABLE T_TMP_BONUS';
          EXEC sp_executesql @sql;

       END;

       FETCH NEXT FROM cur_controlClon INTO @table, @ip;

  END;

CLOSE cur_controlClon;
DEALLOCATE cur_controlClon;

delete from T_TMP_BONUS_CONS
where conta%32 <> 0;

print concat('ingesta fin :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

--logica RC
insert into T_new01
select Mall,
       Retail,
       Caja,
       CodCom,
       CASE Tipo WHEN 'DNI'  then CONCAT('99',RIGHT(CONCAT('00000000',NUMTIPO), 8),'9')
                 WHEN 'CARD' then RIGHT(CONCAT('00000000',NUMTIPO), 11)
                 END as codcta,
       SUBSTRING(FecTx,1,2) as dia,
       SUBSTRING(FecTx,3,2) as mes,
       SUBSTRING(FecTx,5,4) as anho,
       SUBSTRING(HoraTx,1,4) as HHMM,
       RIGHT(CONCAT('0000000000',IDPos), 6) as posid,
       RIGHT(CONCAT('0000000000',SecPos), 6) as nroco,
       TotSoles,
       CAST(SUBSTRING(TotSoles,2,4) AS int) * 1 as precTotEnt,
       round(CAST(SUBSTRING(TotSoles,6,2) AS int) / 100.0,2) as precTotDec,
       round(CAST(SUBSTRING(TotSoles,2,4) AS int) * 1 + round(CAST(SUBSTRING(TotSoles,6,2) AS int) / 100.0,2),2) as precTot,
       DetLineas,
       CONCAT(SUBSTRING(FecTx,5,4),SUBSTRING(FecTx,3,2)) as periodo
  from T_TMP_BONUS_CONS
 where CodCom in (select codcom from PRM_COMERCIO where flag_rc=1) 
   and flag_may_0 = 'Sí'
   and LEN(NumTipo) in (11,8);

insert into T_new02 (secuencial,mall,retail,caja,cabecera,detlineas)
select secuencial,
       mall,
       retail,
       caja,
       CONCAT(codcom,codcta,dia,mes,anho,HHMM,posid,nroco,totsoles) as cabecera,
       detlineas
  from T_new01
 where periodo >= (select PERIODOINI from prm_rango)
   and periodo <= (select PERIODOFIN from prm_rango);

print concat('RC division trama detalle ini :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

--ini division trama detalle
SET @i = 1;
SET @j = 1;

SET @largo = (select max(len(DetLineas)) from T_new02);
SET @itera = @largo/@iSbtLen; --longitud de la trama para linea detalle

WHILE @i <= @itera
BEGIN
    WHILE @j <= @itera
    BEGIN

        SET @iSbtIni = (@iSbtLen*(@j-1))+1;
      --SET @iSbtLen = 32;
        SET @iCorrel = @j;
        SET @iStrLen = @iSbtLen*@i;

        SET @cSbtIni = CAST(@iSbtIni as nvarchar(10));
        SET @cSbtLen = CAST(@iSbtLen as nvarchar(10));
        SET @cCorrel = CAST(@iCorrel as nvarchar(10));
        SET @cStrLen = CAST(@iStrLen as nvarchar(10));

        --IF @cSbtIni > 0 AND @cSbtIni < @cStrLen
        IF @cSbtIni > 0
            BEGIN

                SET @sql = 'INSERT INTO T_new03 (secuencial,Mall,Retail,Caja,cabecera,
       ITEMDESC,ITEMNRO)
SELECT secuencial,Mall,Retail,Caja,cabecera,
       SUBSTRING(DetLineas,' + @cSbtIni + ',' + @cSbtLen + '),' + @cCorrel + '
  FROM T_new02 where len(detlineas) = ' + @cStrLen;

                EXEC sp_executesql @sql;

           END

        SET @j = @j + 1;
    END

    SET @i = @i + 1;
    SET @j = 1;
END
--fin division trama detalle

update T_new03
   set itemdesc = CONCAT(SUBSTRING(itemdesc,1,10),'0',SUBSTRING(itemdesc,11,13),SUBSTRING(itemdesc,25,8))
 where unicode(SUBSTRING(itemdesc,24,1)) < 48 
    or unicode(SUBSTRING(itemdesc,24,1)) > 57;

print concat('RC division trama detalle fin :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

insert into T_new04
select a.secuencial,
       a.Mall,
       a.Retail,
       a.Caja,
       a.CodCom,
       a.codcta,
       a.dia,
       a.mes,
       a.anho,
       a.HHMM,
       a.posid,
       a.nroco,
       a.TotSoles,
       a.precTotEnt, 
       a.precTotDec,
       a.precTot,	
       b.cabecera,
	   b.ITEMDESC,
	   b.ITEMNRO,
       round(CAST(SUBSTRING(b.cabecera,42,5) AS int) * 1 + round(CAST(SUBSTRING(b.cabecera,47,2) AS int) / 100.0,2),2) AS preciotot,
	   SUBSTRING(b.itemdesc,11,14) as codprodit,
	   SUBSTRING(b.itemdesc,25,8)  as cantit,
	   SUBSTRING(b.itemdesc,4,1)   as signoit,
	   SUBSTRING(b.itemdesc,5,6)   as precioit,
       round(CAST(SUBSTRING(b.itemdesc,4,5) AS int) * 1 + round(CAST(SUBSTRING(b.itemdesc,9,2) AS int) / 100.0,2),2) AS precioitem
  from T_new01 a inner join T_new03 b 
         on a.secuencial = b.secuencial
        and a.Mall = b.Mall
        and a.Retail = b.Retail
        and a.Caja = b.Caja
        and len(b.ITEMDESC) > 0;

insert into T_new05
select secuencial,
       max(preciotot) as preciotot,
       sum(precioitem) as sumprecioitem,
       sum(round((precioitem*60/59),2)) as sumprecioitem_cr,
       round(max(preciotot) - round(sum(precioitem),2),2) as delta_tot,
       round(max(preciotot) - round(sum(precioitem*60/59),2),2) as delta2_totCr
  from T_new04
 group by secuencial
having max(preciotot) / round(sum(precioitem),2) <> 1;

insert into T_new06
select a.secuencial,
       a.Mall,
       a.Retail,
       a.Caja,
       a.CodCom,
       a.codcta,
       a.dia,
       a.mes,
       a.anho,
       a.HHMM,
       a.posid,
       a.nroco,
       a.TotSoles, --
       a.precTotEnt, --
       a.precTotDec, --
       a.precTot,	--
       a.cabecera,
       a.ITEMDESC,
       a.ITEMNRO,
       a.preciotot preciotot_a, --
       a.codprodit,
       a.cantit,
       a.signoit,
       a.precioit,
       a.precioitem,
       b.secuencial secuencial_b,
       b.preciotot preciotot_b,
       b.sumprecioitem,
       b.sumprecioitem_cr,
       b.delta_tot,
       b.delta2_totCr
  from T_new04 a inner join T_new05 b on a.secuencial = b.secuencial;

insert into T_new07
select secuencial,
       itemnro,
       cabecera,
       SUBSTRING(cabecera,42,1) as cab_signo,
       SUBSTRING(cabecera,43,6) as cab_precTot_OLDrecTot_OLD,
       RIGHT(CONCAT('0000000000',floor(sumprecioitem_cr)), 4) as stringEntero_NEWprecTot,
       SUBSTRING(CONCAT(round(cast(sumprecioitem_cr as decimal(10,2)) - floor(sumprecioitem_cr),2),'0000000000'), 3, 2) as stringDecimal_NEWprecTot,
       ITEMDESC,
       codprodit,
       cantit,
       signoit,
       precioit as OLD_precioit,
       RIGHT(CONCAT('0000000000',floor(round(precioitem*60/59,2))), 4) as stringentero_NEWit,
       SUBSTRING(CONCAT(round((precioitem*60/59) - floor(precioitem*60/59),2),'0000000000'), 3, 2) as stringdecimal_NEWit
  from T_new06
 order by secuencial, itemnro;

insert into T_new08
select secuencial,
       itemnro,
       cabecera as cabecera_old,
       CONCAT( SUBSTRING(cabecera,1,41) , cab_signo , stringEntero_NEWprecTot , stringDecimal_NEWprecTot ) as cabecera_new,
       CONCAT( codprodit , cantit , signoit , OLD_precioit ) as detalle_old,
       CONCAT( codprodit , cantit , signoit , stringentero_NEWit , stringdecimal_NEWit ) as detalle_new
  from T_new07
 order by secuencial, itemnro;

print concat('RC fin :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

--logica no RC
insert into T_new11
select Mall,
       Retail,
       Caja,
       CodCom,
       CASE Tipo WHEN 'DNI'  then CONCAT('99',RIGHT(CONCAT('00000000',NUMTIPO), 8),'9')
                 WHEN 'CARD' then RIGHT(CONCAT('00000000',NUMTIPO), 11)
                 END as codcta,
       SUBSTRING(FecTx,1,2) as dia,
       SUBSTRING(FecTx,3,2) as mes,
       SUBSTRING(FecTx,5,4) as anho,
       SUBSTRING(HoraTx,1,4) as HHMM,
       RIGHT(CONCAT('0000000000',IDPos), 6) as posid,
       RIGHT(CONCAT('0000000000',SecPos), 6) as nroco,
       TotSoles,
       CAST(SUBSTRING(TotSoles,2,4) AS int) * 1 as precTotEnt,
       round(CAST(SUBSTRING(TotSoles,6,2) AS int) / 100.0,2) as precTotDec,
       round(CAST(SUBSTRING(TotSoles,2,4) AS int) * 1 + round(CAST(SUBSTRING(TotSoles,6,2) AS int) / 100.0,2),2) as precTot,
       DetLineas,
       CONCAT(SUBSTRING(FecTx,5,4),SUBSTRING(FecTx,3,2)) as periodo
  from T_TMP_BONUS_CONS
 where CodCom in (select codcom from PRM_COMERCIO where flag_rc=0) 
   and flag_may_0 = 'Sí'
   and LEN(NumTipo) in (11,8);

insert into T_new12 (secuencial,mall,retail,caja,cabecera,detlineas)
select secuencial,
       mall,
       retail,
       caja,
       CONCAT(codcom,codcta,dia,mes,anho,HHMM,posid,nroco,totsoles) as cabecera,
       detlineas
  from T_new11
 where periodo >= (select PERIODOINI from prm_rango)
   and periodo <= (select PERIODOFIN from prm_rango);

print concat('No RC division trama detalle ini :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

--ini division trama detalle
SET @i = 1;
SET @j = 1;

SET @largo = (select max(len(DetLineas)) from T_new02);
SET @itera = @largo/@iSbtLen; --longitud de la trama para linea detalle

WHILE @i <= @itera
BEGIN
    WHILE @j <= @itera
    BEGIN

        SET @iSbtIni = (@iSbtLen*(@j-1))+1;
      --SET @iSbtLen = 32;
        SET @iCorrel = @j;
        SET @iStrLen = @iSbtLen*@i;

        SET @cSbtIni = CAST(@iSbtIni as nvarchar(10));
        SET @cSbtLen = CAST(@iSbtLen as nvarchar(10));
        SET @cCorrel = CAST(@iCorrel as nvarchar(10));
        SET @cStrLen = CAST(@iStrLen as nvarchar(10));
 
        --IF @cSbtIni > 0 AND @cSbtIni < @cStrLen
        IF @cSbtIni > 0
            BEGIN

                SET @sql = 'INSERT INTO T_new13 (secuencial,Mall,Retail,Caja,cabecera,
       ITEMDESC,ITEMNRO)
SELECT secuencial,Mall,Retail,Caja,cabecera,
       SUBSTRING(DetLineas,' + @cSbtIni + ',' + @cSbtLen + '),' + @cCorrel + '
  FROM T_new12 where len(detlineas) = ' + @cStrLen;

                EXEC sp_executesql @sql;

           END

        SET @j = @j + 1;
    END

    SET @i = @i + 1;
    SET @j = 1;
END
--fin division trama detalle

update T_new13
   set itemdesc = CONCAT(SUBSTRING(itemdesc,1,10),'0',SUBSTRING(itemdesc,11,13),SUBSTRING(itemdesc,25,8))
 where unicode(SUBSTRING(itemdesc,24,1)) < 48 
    or unicode(SUBSTRING(itemdesc,24,1)) > 57;

print concat('No RC division trama detalle fin :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

insert into T_new14
select a.secuencial,
       a.Mall,
       a.Retail,
       a.Caja,
       a.CodCom,
       a.codcta,
       a.dia,
       a.mes,
       a.anho,
       a.HHMM,
       a.posid,
       a.nroco,
       a.TotSoles,
       a.precTotEnt, 
       a.precTotDec,
       a.precTot,	
       b.cabecera,
	   b.ITEMDESC,
	   b.ITEMNRO,
       round(CAST(SUBSTRING(b.cabecera,42,5) AS int) * 1 + round(CAST(SUBSTRING(b.cabecera,47,2) AS int) / 100.0,2),2) AS preciotot,
	   SUBSTRING(b.itemdesc,11,14) as codprodit,
	   SUBSTRING(b.itemdesc,25,8)  as cantit,
	   SUBSTRING(b.itemdesc,4,1)   as signoit,
	   SUBSTRING(b.itemdesc,5,6)   as precioit,
       round(CAST(SUBSTRING(b.itemdesc,4,5) AS int) * 1 + round(CAST(SUBSTRING(b.itemdesc,9,2) AS int) / 100.0,2),2) AS precioitem
  from T_new11 a inner join T_new13 b 
         on a.secuencial = b.secuencial
        and a.Mall = b.Mall
        and a.Retail = b.Retail
        and a.Caja = b.Caja
        and len(b.ITEMDESC) > 0;

insert into T_new18
select secuencial,
       itemnro,
       null as cabecera_old,
       cabecera as cabecera_new,
	   null as detalle_old,
       CONCAT( codprodit , cantit , signoit , precioit ) as detalle_new
  from T_new14
 order by secuencial, itemnro;

print concat('No RC fin :',REPLACE(CONVERT(varchar(8),getdate(),108),':',''));

insert into TRAMA
select CONCAT( cabecera_new,detalle_new ) as trama from T_new08
union all
select CONCAT( cabecera_new,detalle_new ) as trama from T_new18;

insert into TRAMAH (fechahora, trama)
select @cDaTi, trama from TRAMA;

END
GO