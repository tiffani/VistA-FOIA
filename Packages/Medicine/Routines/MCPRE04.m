MCPRE04 ;HIRMFO/DAD-MCNP GLOBAL CLEANUP ;5/13/96  11:14
 ;;2.3;Medicine;;09/13/1996
 ;
 N MC,MCPRE08
 S MCPRE08(1)=""
 S MCPRE08(2)="Cleaning up the ^MCNP global."
 D MES^XPDUTL(.MCPRE08)
 S MC=""
 F  S MC=$O(^MCNP(MC)) Q:MC=""  K ^MCNP(MC)
 Q
