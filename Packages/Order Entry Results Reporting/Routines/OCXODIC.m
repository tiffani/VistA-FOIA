OCXODIC ;SLC/RJS,CLA - FILMAN LOOKUP INTERFACE  ;10/29/98  12:37
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
EN ;
 Q
 ;
 ;
GETF0(X) N DIC,Y S DIC=1,DIC(0)="ZN" D ^DIC Q:(Y<1) "" Q Y(0)
 ;
GETATT(OCXFILE,ATTR) ;
 ;
 N OCXTEMP S OCXTEMP=""
 D FILE^DID(OCXFILE,"",ATTR,"OCXTEMP(1)")
 ;
 Q $G(OCXTEMP(1,ATTR))
 ;