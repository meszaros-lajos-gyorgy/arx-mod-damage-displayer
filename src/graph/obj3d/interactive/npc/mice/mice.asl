ON INIT 
{
 SETNAME [description_mouse]
 SET_INTERACTIVITY NONE
 SET_GROUP mice
 SET §stopped 0
 SET_NPC_STAT armor_class 1
 SET_NPC_STAT absorb 1
 SET_NPC_STAT damages 1
 SET_NPC_STAT tohit 40
 SET_NPC_STAT aimtime 300
 SET_NPC_STAT life 1
 SETIRCOLOR 0.8 0.0 0.0
 COLLISION OFF
 LOADANIM WALK "mice_flee"
 LOADANIM WAIT "mice_wait"
 LOADANIM DIE "mice_dead"
 BEHAVIOR WANDER_AROUND 1000
 SETTARGET NONE
 SET_MATERIAL FLESH
 SET £targeted_food "NOFOOD"
 TIMERmanifest -i 0 3 GOTO MANIFEST
 SET §nb_cheese_eaten 0
 ACCEPT
}

>>RESET
 SET §scale 100
 TIMERcrunch OFF
 //INC §nb_cheese_eaten 1
 SET £targeted_food "NOFOOD"
 BEHAVIOR WANDER_AROUND 1000
 SETTARGET NONE
 //IF (§nb_cheese_eaten >= 10)
 //{
 // TIMERgrow -m 10 100 GOTO GROW
 //}
 ACCEPT

// sent by gob kicking the mouse
ON STOP_MOUSE
{
 SET §stopped 1
 BEHAVIOR NONE 
 SETTARGET NONE
 TIMERmanifest OFF
 TIMERcrunch OFF
 ACCEPT
}

ON REACHEDTARGET 
{
//[FLURE_DEBUG]	HERO_SAY -d "reach"
 IF ( §stopped == 1 ) ACCEPT
 IF (£targeted_food == "NOFOOD") ACCEPT
 IF (^TARGET == ~£targeted_food~) 
 {
  IF ( ^DIST_PLAYER > 1000 ) GOTO RESET // don't eat if player not in sight
  BEHAVIOR FRIENDLY
//  SETTARGET ~£targeted_food~
//	HERO_SAY -d "souris a trouve fromage"
    TIMERcrunch 0 1 GOTO CRUNCH
  ACCEPT
 }
 ACCEPT
}

ON LOSTTARGET 
{
 IF ( §stopped == 1 ) ACCEPT
 IF (£targeted_food == "NOFOOD") ACCEPT
 IF (^target == ~£targeted_food~) GOTO RESET
 ACCEPT
}

ON DIE 
{
 TIMERcrunch OFF
 TIMERmanifest OFF
 FORCEANIM DIE
 TIMERres 1 20 REVIVE -i
 ACCEPT
}

ON TARGET_DEATH 
{
 IF ( §stopped == 1 ) ACCEPT
 IF (^SENDER == ~£targeted_food~) GOTO RESET
 ACCEPT
}


ON MANIFEST 
{
  IF ( §stopped == 1 ) ACCEPT
  IF (^$PARAM1 == "RAT_FOOD") 
  {  
   IF (£targeted_food != "NOFOOD") ACCEPT  
   SET £targeted_food ^SENDER
   BEHAVIOR MOVE_TO
   SETTARGET ~£targeted_food~
   ACCEPT  
  }
 ACCEPT 
}

>>CRUNCH
//	HERO_SAY -d "crunch souris"
 DEC §scale 5
 SENDEVENT CUSTOM £targeted_food "CRUNCH"
 IF (§scale < 40) GOTO RESET
 ACCEPT

>>MANIFEST
//	HERO_SAY -d "youhou je suis une souris"
SENDEVENT -gr MICECARE MANIFEST 500 "MICE" 
ACCEPT

//>>GROW
//INC §scale 50
//SET_SCALE §scale
//IF (§scale >= 490)
//{
// SPELLCAST -smf 10 SPEED SELF
//}
//ACCEPT

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
