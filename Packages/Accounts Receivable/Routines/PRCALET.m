PRCALET ;WASH-ISC@ALTOONA,PA/CMS-PRINT FORM LETTERS ;6/4/93  8:43 AM
V ;;4.5;Accounts Receivable;**198**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 NEW DIC,IOP,SITE,PRCABN,PRCALT,POP,X,Y,ZTDESC,ZTRTN,ZTSAVE,ZTSK,%ZIS
 S DIC="^RC(343,",DIC("A")="ENTER THE FORM LETTER TO TEST: ",DIC(0)="AEQM" D ^DIC K DIC G:Y<0 Q S PRCALT=+Y
 N DPTNOFZY,DPTNOFZK S (DPTNOFZY,DPTNOFZK)=1
 S DIC="^PRCA(430,",DIC(0)="AEQM" D ^DIC K DIC G:Y<0 Q S PRCABN=+Y
ST W ! S IOP="Q",%ZIS="NQ" S %ZIS("B")="" D ^%ZIS G:POP Q
 I '$D(IO("Q")) W !!,"YOU MUST QUEUE THE OUTPUT" G ST
 S ZTRTN="QUE^PRCALET",ZTDESC="Print Form Letter",ZTSAVE("PRCALT")="",ZTSAVE("PRCABN")="" D ^%ZTLOAD
Q D ^%ZISC Q
QUE D PRT^PRCAGF(PRCALT,PRCABN)
 Q