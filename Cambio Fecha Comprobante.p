/*
Cambio de fecha de comprobante

Finalidad: Se modifica la fecha del comprobante. Al ejecutar el proceso se solicitan tipo de comprobante, código, y muestra la fecha, la cual se puede modificar.

*/

DEF VAR ccodigo         LIKE conta.codigo.
DEF VAR ccomprobante    LIKE conta.comprobante.
DEF VAR dfecha          AS DATE.
DEF VAR lok             AS LOGICAL.
DEF VAR iAnomesNue      AS INTEGER.

SESSION:DATA-ENTRY-RETURN = TRUE.

UPDATE ccodigo
       ccomprobante WITH FRAME a FONT 14 1 COL CENTERED ROW 5
       .
22121212121
FIND FIRST conta WHERE
           conta.codigo  = ccodigo AND
           conta.comprobante = ccomprobante NO-LOCK NO-ERROR.
IF NOT AVAIL conta
THEN DO:
     MESSAGE "Registro en CONTA inexistente"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

FIND FIRST concli WHERE
           concli.codigo = conta.codigo AND
           concli.comprobante = conta.comprobante and
           concli.fechadiario NE ? NO-LOCK NO-ERROR.
IF AVAIL concli
THEN DO:
     MESSAGE "CONCLI ya pasado a la contabilidad con fecha:" STRING(concli.fechadiario) SKIP
             "Imposible su modificacion"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

dfecha = conta.fecha.
    
UPDATE dFecha LABEL "Fecha correcta"
       WITH FRAME a FONT 14 1 COL CENTERED ROW 5.

iAnomesNue = (YEAR(dfecha) * 100) + MONTH(dfecha).

MESSAGE "Confirma la nueva fecha ?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lok.
IF NOT lok THEN RETURN.


FOR EACH conta WHERE
         conta.codigo  = ccodigo AND
         conta.comprobante = ccomprobante:

    ASSIGN conta.fecha       = dFecha
           conta.anomesconta = iAnomesNue.
END.

FOR EACH detalle WHERE
         detalle.codigo  = ccodigo AND
         detalle.comprobante = ccomprobante:

    ASSIGN detalle.fecha = dFecha.
END.

FOR EACH fideu1 WHERE
         fideu1.codigo  = ccodigo AND
         fideu1.facdoc = ccomprobante:

    ASSIGN fideu1.fecha       = dFecha
           fideu1.anomesconta = iAnomesNue.
   
    FIND FIRST pago WHERE
               pago.condpago = fideu1.condpago NO-LOCK NO-ERROR.
    IF AVAIL pago
    THEN fideu1.fechavto = fideu1.fecha + pago.dias.
END.

FOR EACH fideu2 WHERE
         fideu2.codigo  = ccodigo AND
         fideu2.facdoc = ccomprobante:

    ASSIGN fideu2.fecha       = dFecha
           fideu2.anomesconta = iAnomesNue.
END.

FOR EACH fideu3 WHERE
         fideu3.codigo  = ccodigo AND
         fideu3.facdoc = ccomprobante:

    ASSIGN fideu3.fecha       = dFecha.
END.

FOR EACH concli WHERE
         concli.codigo  = ccodigo AND
         concli.comprobante = ccomprobante:

    ASSIGN concli.fecha       = dFecha
           concli.anomesconta = iAnomesNue.
END.

MESSAGE "Arreglo Finalizado" VIEW-AS ALERT-BOX INFO BUTTONS OK.



