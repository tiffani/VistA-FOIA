PRCHAM3 ;WISC/AKS,ID/RSD,SF-ISC/TKW-CONT. OF AMENDMENTS ;4/20/94  11:13 AM
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
RECAL D REST S (K,PRCH)=0 F I=0:0 S PRCH=$O(^PRC(443.6,PRCHPO,3,PRCH)) Q:'PRCH  S PRCHAC=$P(^(PRCH,0),U,1),PRCHACT=$P(^(0),U,4),PRCHP=$P(^(0),U,2),PRCHO=$P(^(0),U,3) D PCTQ,MDIS
 Q
PCTQ I PRCHAC="Q" S PRCHACT=$P(^PRC(443.6,PRCHPO,2,0),U,4),PRCHAC="1:1:"_PRCHLC G PCT
 I PRCHAC[":" S PRCHAC=$P(PRCHAC,":",1)_":1:"_$P(PRCHAC,":",2)
PCT S PRCHDAM=0,Y="F J="_PRCHAC_" S PRCHN=J D PCT1" X Y
 S PRCHDAM=PRCHDAM*100+.5\1/100,$P(^PRC(443.6,PRCHPO,3,PRCH,0),U,3)=PRCHDAM Q
PCT1 S PRCHN=$O(^PRC(443.6,PRCHPO,2,"B",PRCHN,0)) Q:'PRCHN  S PRCHD=$S($D(^PRC(443.6,PRCHPO,2,PRCHN,2)):$P(^(2),U,1),1:0)
 I $E(PRCHP,1)="$" S PRCHDA=$P(PRCHP,"$",2)/PRCHACT
 E  S:+$P(^PRC(443.6,PRCHPO,2,PRCHN,2),U,6)>0 PRCHD=PRCHD-$P(^(2),U,6) S PRCHDA=$J(PRCHD*(PRCHP/100),0,3)
 S PRCHDAM=PRCHDAM+PRCHDA,$P(^PRC(443.6,PRCHPO,2,PRCHN,2),U,6)=$P(^PRC(443.6,PRCHPO,2,PRCHN,2),U,6)+PRCHDA Q
REST D MV^PRCHAM2,MVDIS^PRCHAM2 F I=0:0 S I=$O(^PRC(443.6,PRCHPO,2,I)) Q:'I  S:$D(^(I,2)) $P(^(2),U,6)=""
 Q
MDIS S PRCHN=$P(^PRC(443.6,PRCHPO,3,PRCH,0),U,3) I PRCHO'=PRCHN S PRCHAMT=PRCHAMT+(PRCHO-PRCHN) S:K ^TMP("PRCHW",$J,K)="  " S K=K+1 D MDIS^PRCHAM2 Q
 Q
DIE S DIE="^PRC(443.6,",DA=PRCHPO D ^DIE K DIE Q
UPDT ;UPDATE DELIVERY DATE/ORIGINAL DELIVERY DATE
 S PRCHDT=$P(^PRC(442,PRCHPO,0),U,10),DR=7 D DIE^PRCHAM1 I PRCHDT,$P(^PRC(442,PRCHPO,0),U,20)="",$P(^PRC(443.6,PRCHPO,0),U,10)'=PRCHDT S $P(^(0),U,20)=PRCHDT
 K PRCHDT Q
EN8 ;AMEND ESTIMATED SHIPPING/HANDLING
 S PRCHO=$P(PRCH(0),U,13),DR=13 D DIE S PRCHN=$P(^PRC(443.6,PRCHPO,0),U,13) Q:PRCHO=PRCHN
 S PRCHT=0,PRCHAMT=PRCHAMT+(PRCHN-PRCHO),PRCHDL=1
 S:+PRCHO=0 PRCHL1="*",^TMP("PRCHW",$J,1)="Add estimated shipping and/or handling charge of "_PRCHN_" dollars" S:'$P(^PRC(443.6,PRCHPO,0),U,18) PRCHLC=PRCHLC+1,$P(^(0),U,18)=PRCHLC
 S:+PRCHN=0 PRCHL1="*",^TMP("PRCHW",$J,1)="Estimated shipping and/or handling charge of "_PRCHO_" dollars has been deleted",$P(^PRC(443.6,PRCHPO,0),U,13)=""
 Q
EN14 D MVDIS^PRCHAM2 S J=$P(^PRC(443.6,PRCHPO,3,0),U,4)+1,PRCHD=J_"^"_(PRCHLC+1),J=PRCHLC+1
 S %=2,%A="     ADD ITEM DISCOUNT AS LINE ITEM NUMBER: "_J,%B="" D ^PRCFYN I %'=1 W ?40,"<NOTHING ADDED>" Q
 S DIC="^PRC(443.6,PRCHPO,3,",DIC(0)="QEALZ",DLAYGO=443.6 D ^DIC G EX14:Y<0!($P(Y,U,3)="") S $P(^(0),U,4)=PRCHJ,$P(^(0),U,6)=$P(PRCHD,U,2),PRCHD=+Y,PRCHD0=Y(0)
 S DR="[PRCHAMDISCNT]" D DIE G EX14:'$D(^PRC(443.6,PRCHPO,3,+PRCHD)) S PRCHLC=PRCHLC+1,PRCH=+PRCHD,PRCHAC=$P(^(PRCH,0),U,1),PRCHACT=$P(^(0),U,4),PRCHP=$P(^(0),U,2)
 D PCTQ S PRCHAMT=PRCHAMT-$P(^PRC(443.6,PRCHPO,3,PRCH,0),U,3),PRCHT=0,^TMP("PRCHW",$J,1)=" *ADDED THROUGH AMENDMENT*",K=2 D MDIS^PRCHAM2 S (PRCHO,PRCHN)=""
EX14 K DLAYGO Q
EN15 D MVDIS^PRCHAM2 S DIC="^PRC(443.6,PRCHPO,3,",DIC(0)="QAEMZ" D ^DIC Q:Y<0  S PRCHD=+Y,%=2,%A="     SURE YOU WANT TO DELETE ",%B="" D ^PRCFYN I %'=1 W ?40,"<NOTHING DELETED>" Q
 S $P(^PRC(443.6,PRCHPO,3,PRCHD,0),U,2)=0,PRCHAREC=1,PRCHT=0,(PRCHO,PRCHN)="" Q
EN16 D MVDIS^PRCHAM2 S DIC="^PRC(443.6,PRCHPO,3,",DIC(0)="QAEZ" D ^DIC Q:Y<0  S PRCHD=+Y,PRCHD0=Y(0),DR="[PRCHAMDISCNT]" D DIE S PRCHAREC=1,PRCHT=0,(PRCHO,PRCHN)="" Q
 Q
DIS S (PRCHJ,X1)="" Q:X="Q"  F I=1:1 S X2=$P(X,",",I) Q:X2=""  S:X2=+X2 X1=X1_X2_",",X2="" I X2]"" K:X2'[":"!($P(X2,":",1)'?1N.N)!($P(X2,":",2)'?1N.N)!(+X2'<$P(X2,":",2)) X Q:'$D(X)  S X1=X1_+X2_":1:"_$P(X2,":",2)_","
 Q:'$D(X)  S X1=$E(X1,1,($L(X1)-1)),J=0 X "F I="_X1_" S J=J+1 I '$D(^PRC(443.6,PRCHPO,2,""B"",I)) W "" ??"",$C(7),!,""**ITEM "",I,"" IS NOT A VALID LINE ITEM**"" K X Q"
 Q:'$D(X)  K:X?.E1P X Q:'$D(X)  S PRCHJ=J Q
LCK L ^PRC(442,PRCHPO):1 I '$T W !?5,"P.O. is being edited by another user " Q
 I '$D(^PRC(442,PRCHPO,0))
 Q