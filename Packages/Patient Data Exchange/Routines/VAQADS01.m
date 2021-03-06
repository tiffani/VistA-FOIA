VAQADS01 ;ALB/JRP - SYSTEM ADMINISTRATION;27-MAY-93
 ;;1.5;PATIENT DATA EXCHANGE;;NOV 17, 1993
WORKDONE(WORKID,TRANS,DONEBY) ;LOG WORK DONE USING PDX
 ;INPUT  : WORKID - Identifier for type of work done
 ;         TRANS - Transaction work was done with (pointer)
 ;         DONEBY - Person that did the work (pointer)
 ;               (if NULL, assumes PDX Server)
 ;OUTPUT : 0 - Work was successfully logged or reported
 ;        -1^Error_Text - Error
 ;
 ;CHECK INPUT
 Q:('$D(WORKID)) "-1^Did not pass work identifier"
 Q:('$D(TRANS)) "-1^Did not pass transaction work was done with"
 Q:(('TRANS)!('$D(^VAT(394.61,TRANS)))) "-1^Did not pass a valid transaction"
 S DONEBY=+$G(DONEBY)
 ;DECLARE VARIABLES
 N TMP,IFN,NAME,SSN,PID,SITE,DOMAIN,SEGMENT
 N DATETIME,PATIENT,DIC,X,DD,DO,Y
 S TMP="^NEW^RJCT^RLSE^RQST^SEND^SNSTVE^UNKN^UNQE^UPDTE^"
 Q:(TMP'[("^"_WORKID_"^")) "-1^Did not pass a valid word identifier"
 S DATETIME=$$NOW^VAQUTL99(1,0)
 Q:($P(DATETIME,"^",1)="-1") "-1^Could not create entry in work-load file"
 ;CHANGE DUZ INTO A VALID NAME (USE NULL FOR PDX SERVER)
 S:(DONEBY=.5) DONEBY=0
 S DONEBY=$P($G(^VA(200,DONEBY,0)),"^",1)
 S:((DONEBY="")!(DONEBY="POSTMASTER")) DONEBY=""
 ;GET PATIENT INFORMATION
 S PATIENT=+$P($G(^VAT(394.61,TRANS,0)),"^",3)
 S:('$D(^DPT(PATIENT))) PATIENT=0
 S TMP=$G(^VAT(394.61,TRANS,"QRY"))
 S NAME=$P(TMP,"^",1)
 S SSN=$P(TMP,"^",2)
 S PID=$P(TMP,"^",4)
 ;DETERMINE REMOTE SITE & DOMAIN
 S (SITE,DOMAIN)=""
 I ((WORKID="RJCT")!(WORKID="RLSE")!(WORKID="SEND")!(WORKID="UNKN")!(WORKID="UNQE")) D
 .S TMP=$G(^VAT(394.61,TRANS,"RQST2"))
 .S SITE=$P(TMP,"^",1)
 .S DOMAIN=$P(TMP,"^",2)
 I ((WORKID="NEW")!(WORKID="RQST")!(WORKID="UPDTE")) D
 .S TMP=$G(^VAT(394.61,TRANS,"ATHR2"))
 .S SITE=$P(TMP,"^",1)
 .S DOMAIN=$P(TMP,"^",2)
 I (WORKID="SNSTVE") D
 .S TMP=$G(^VAT(394.61,TRANS,"ATHR2"))
 .S SITE=$P(TMP,"^",1)
 .S DOMAIN=$P(TMP,"^",2)
 ;CREATE ENTRY IN WORK-LOAD FILE
 S DIC="^VAT(394.87,"
 S X=DATETIME
 S DIC("DR")=""
 S DIC(0)="L"
 D FILE^DICN
 S IFN=+Y
 Q:(IFN<0) "-1^Unable to create entry in work-load file"
 ;PUT IN KNOWN INFORMATION
 S Y=$$FILEINFO^VAQFILE(394.87,IFN,.02,DONEBY)
 S Y=$$FILEINFO^VAQFILE(394.87,IFN,.03,WORKID)
 S:(PATIENT) Y=$$FILEINFO^VAQFILE(394.87,IFN,10,PATIENT)
 S Y=$$FILEINFO^VAQFILE(394.87,IFN,11,NAME)
 S Y=$$FILEINFO^VAQFILE(394.87,IFN,12,SSN)
 S Y=$$FILEINFO^VAQFILE(394.87,IFN,13,PID)
 S Y=$$FILEINFO^VAQFILE(394.87,IFN,20,SITE)
 S Y=$$FILEINFO^VAQFILE(394.87,IFN,21,DOMAIN)
 ;PUT IN SEGMENTS
 S TMP=0
 F  S TMP=+$O(^VAT(394.61,TRANS,"SEG",TMP)) Q:('TMP)  D
 .S X=+$G(^VAT(394.61,TRANS,"SEG",TMP,0))
 .Q:('X)
 .S SEGMENT=$P($G(^VAT(394.71,X,0)),"^",1)
 .Q:(SEGMENT="")
 .S X=$$FILEINFO^VAQFILE(394.87,IFN,30,SEGMENT,.01,SEGMENT)
 Q 0
