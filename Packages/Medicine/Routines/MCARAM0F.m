MCARAM0F ;WASH ISC/JKL-MUSE AUTO INSTRUMENT REINIT-MISS TRAN REC ;1/31/95  11:31
 ;;2.3;Medicine;;09/13/1996
 ;
 ;
 ;Called from ^MCARAM0
 ;Deletes EKG records without transaction by IEN patient match
 S (MCIEN,MCDATE,MCNAME,MCI,MCJ,MCZERO,MCK)=0
 F  S MCIEN=$O(^MCAR(691.5,MCIEN)) Q:MCIEN="B"  S MCDATE=$P(^MCAR(691.5,MCIEN,0),"^"),MCSSN=^MCAR(691.5,MCIEN,.1) D CHECK
 Q
CHECK ;
 S MCI=0 F  S MCERR=0,MCI=$O(^MCAR(700.5,"B",MCDATE,MCI)) Q:MCI=""  S MCZERO=^MCAR(700.5,MCI,0) I $P(MCZERO,"^",3)=MCSSN S MCERR=MCIEN Q
 I MCERR=0 D DEL Q
 Q
DEL S DA=MCIEN,DIK="^MCAR(691.5," D ^DIK
 S MCCNT=MCCNT+1
 W:MCCNT#100=0 "."
 Q