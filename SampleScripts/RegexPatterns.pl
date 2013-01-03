:: clean out commas and remove the header from each 'page' ::

STEP 01:
	FIND: 	HEALTH RIGHT, INC.
	REPL:	HEALTH-RIGHT-INC
	
STEP 02:
	FIND: 	,
	REPL:	

STEP 03:
	FIND: 	[\s]+DATE:[\s]+[\d]{2}/[\d]{2}/[\d]{2}[\s]+[\w\(\)\ ]+PAGE:[\s]+[\d]+[\r\n\f]{2,}
	REPL:	\R

STEP 04:
	FIND: 	[\ ]{3}PROVIDER NO: [\d]{9}[\s]+MEDICAID MANAGEMENT INFORMATION SYSTEM[\s]+RPT PAGE: [\d]{9}[\n\r\f]{1,2}
	REPL:	\R

STEP 05:
	FIND: 	[\ ]{3}REMITTANCE:  [\d]{8}[\s]+REMITTANCE ADVICE[\s]+REMIT SEQ:  [\d]{8}[\n\r\f]{1,2}
	REPL:	\R

STEP 06:
	FIND: 	[\ ]{3}NPI NUMBER:[\s]+CAPITATION PAID[\s]+[\n\r\f]{1,2}
	REPL:

STEP 07:
	FIND: 	RECIPIENT NAME[\s]+MEDICAID ID[\s]+TCN[\s]+PAT ACCT NUM[\s]+MED REC NO[\n\f\r]+
	REPL:	
	
STEP 08:	
	FIND: 	DATES OF SERVICE[\s]+ TOB[\s]+ SVC PVDR[\s]+SERVICE PROVIDER NAME[\s]+SUBMITTED[\s]+AMT[\s]+FEE REDUCTION AMT[\s]+PAT RESP AMT[\s]+TOT PAID AMT[\s]+STATUS[\n\r\f]+
	REPL:	

STEP 09:
	FIND: 	[\ \t]+LINE  PROC[\s]+TYPE/DESC[\s]+M1 M2 M3 M4[\s]+REVCD[\s]+THCD[\s]+SVC[\s]+PROV[\s]+PROV CONTROL NO[\s]+DATES OF SERV[\s]+LINE UNITS[\s]+LN SUBM AMOUNT[\s]+LN FEE REDUCT AMT[\s]+LN PAID AMOUNT[\s]+LN STATUS[\n\r\f]+
	REPL:	
	
STEP 10:
	FIND: 	[\n\r\f]{1,2}[\=]{132}[\n\r\f]{1,2}[\=]{132}[\t]{0,1}
	REPL:	\t

/* ****************************************************************************************** */
	
:: now make the records one line each ::
	
STEP 01:
	FIND: 	[\n\f\r]{1,2}([\d]{2}/[\d]{2}/[\d]{2}-[\d]{2}/[\d]{2}/[\d]{2})
	REPL:	\t\1

STEP 02:
	FIND: 	[\n\f\r]{1,2}[\ ]{4}[\w/]+[\n\f\r]{1,2}
	REPL:	\R

/* ****************************************************************************************** */
	
:: make the records CSV ::

STEP 01:
	FIND: HEALTH RIGHT  INC.
	REPL: HEALTH-RIGHT-INC.
	
STEP 02:
	FIND: 	[\ \t]{2,}
	REPL:	,

STEP 03:
	FIND: 	[\t]+
	REPL:	,