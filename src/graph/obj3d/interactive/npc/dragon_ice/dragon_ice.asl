//*******************************************************
ON INIT {
 SET £arrival_path "DRAGONPATH" // DRAG_ARRIVAL
 SET £attack_path "DRAGON_ATTACK"
 SET_SHADOW OFF
 SET £hail "dragon_breath"
 SET £strike "dragon_fire"
 SET £misc "none"
 SET £threat "dragon_breath"
 SET £dying "dragon_death"
 SET £ouch "dragon_hit"
 SET £ouch_medium "dragon_hit"
 SET £ouch_strong "dragon_hit"
 SET §sound_amount 0
 IF (§sound_amount > 0) TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
 SET §arrival 0
 SET §sound 0                 //For animals only     
 SET §pain 15
 SET §reflection_mode 1
 SET §enemy 0                   //defines if the NPC is enemy to the player at the moment
 SET §chatpos 0
 SET §attack 0
 SET §ouch_tim 0
 SET §confusability 10           // level of magic needed to confuse this npc
 SETDETECT 40
 SETSCALE 75
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_large
 SET_WEAPON_MATERIAL CLAW
 SET_BLOOD 0.9 0.1 0.1
 PHYSICAL RADIUS 90
 PHYSICAL HEIGHT 160
 SET_NPC_STAT BACKSTAB 0
 SET_NPC_STAT REACH 150
 SET_NPC_STAT RESISTMAGIC 50
 SET_NPC_STAT RESISTPOISON 10
 SET_NPC_STAT RESISTFIRE 70
 SET_NPC_STAT armor_class 70
 SET_NPC_STAT absorb 50
 SET_NPC_STAT damages 15
 SET_NPC_STAT tohit 50
 SET_NPC_STAT aimtime 2000
 SET_NPC_STAT life 300
 SET_XP_VALUE 800
 SET_NPC_STAT mana 200
 SETIRCOLOR 0.8 0.0 0.0
 INVENTORY SKIN "ingame_inventory_corpse"
 SETNAME [description_ice_dragon]

 loadanim BARE_READY                 "Dragon_fight_attack_start"
 loadanim BARE_UNREADY               "Dragon_fight_attack_strike"
 loadanim BARE_WAIT                  "Dragon_fight_wait" // "Dragon_fight_wait_toponly"
 loadanim BARE_STRIKE_LEFT_START     "Dragon_fight_attack_start" 
 loadanim BARE_STRIKE_LEFT_CYCLE     "Dragon_fight_attack_cycle"
 loadanim BARE_STRIKE_LEFT           "Dragon_fight_attack_strike"
 loadanim BARE_STRIKE_RIGHT_START    "Dragon_fight_attack_start"
 loadanim BARE_STRIKE_RIGHT_CYCLE    "Dragon_fight_attack_cycle"
 loadanim BARE_STRIKE_RIGHT          "Dragon_fight_attack_strike"
 loadanim BARE_STRIKE_TOP_START      "Dragon_fight_attack_start"
 loadanim BARE_STRIKE_TOP_CYCLE      "Dragon_fight_attack_cycle"
 loadanim BARE_STRIKE_TOP            "Dragon_fight_attack_strike"
 loadanim BARE_STRIKE_BOTTOM_START   "Dragon_fight_attack_start"
 loadanim BARE_STRIKE_BOTTOM_CYCLE   "Dragon_fight_attack_cycle"
 loadanim BARE_STRIKE_BOTTOM         "Dragon_fight_attack_strike"
 LOADANIM GRUNT                      "Dragon_fight_grunt"  //*****************  NEW
 loadanim FIGHT_WALK_FORWARD         "Dragon_fight_walk_forward_up"
 loadanim FIGHT_WALK_BACKWARD        "Dragon_fight_walk_backward_up"
 loadanim FIGHT_STRAFE_RIGHT         "Dragon_strafe_right"
 loadanim FIGHT_STRAFE_LEFT          "Dragon_strafe_left"
 LOADANIM WALK                       "Dragon_fight_walk_forward_up" //"Dragon_walk"
 LOADANIM RUN                        "Dragon_run_up"
 LOADANIM WAIT                       "Dragon_wait" //"Dragon_fight_wait_toponly"
 loadanim FIGHT_WAIT                 "Dragon_fight_wait"
 LOADANIM HIT                        "Dragon_receive_damage"
 LOADANIM HIT_SHORT                  "Dragon_hit_short"
 LOADANIM DIE                        "Dragon_death"
 LOADANIM TALK_NEUTRAL               "Dragon_talk_normal"
 LOADANIM TALK_HAPPY                 "Dragon_talk_happy"
 LOADANIM TALK_ANGRY                 "Dragon_talk_angry"
// LOADANIM FIGHT_DIST                 "Dragon_fight_distant_attack"
 LOADANIM ACTION1                    "Dragon_fly_onthespot"
 LOADANIM ACTION2                    "Dragon_landing_ontop"
 LOADANIM ACTION3                    "Dragon_landing"
 LOADANIM ACTION4                    "Dragon_takeoff_fromrock"
 LOADANIM ACTION5                    "Dragon_fight_distant_attack"
 LOADANIM ACTION6				 "Dragon_fight_wait_toponly"
 LOADANIM ACTION7				 "Dragon_fight_attack_left"
 LOADANIM ACTION8				 "Dragon_fight_attack_right"
// LOADANIM ACTION9				 "Dragon_fight_attack_left_part2"
// LOADANIM ACTION10			 "Dragon_fight_attack_right_part2"

 ACCEPT
}

//*******************************************************
ON CONTROLLEDZONE_ENTER {
 IF (^$PARAM1 != "PLAYER") ACCEPT
SET §safespot 1
GOTO SAFESPOT
ACCEPT
}

ON PATHFIND_FAILURE {
>>SAFESPOT
AMBIANCE -v 0 ambient_fight_music
UNSET_CONTROLLED_ZONE DRAGON
HEROSAY -d "SAFE SPOOOOOOOOOOOOOOOOT"
 TIMERattack OFF
 TIMERattack1 OFF
BEHAVIOR MOVE_TO
SETTARGET corpse_0050
ACCEPT
}

//*******************************************************

ON INITEND {
 ATTRACTOR SELF -100 250
 BEHAVIOR NONE
 SETTARGET NONE
 INVULNERABILITY ON
 SETPATH -WF ~£arrival_path~
 USEPATH P
 DAMAGER -u 20
 OBJECT_HIDE SELF ON
 ACCEPT
}

//*******************************************************

ON CUSTOM {
  IF (^$PARAM1 == "GO") {
    OBJECT_HIDE SELF OFF
    HEROSAY -d "Dragon's on the way !!!"
    PLAYANIM -L ACTION1
    USEPATH F
    ACCEPT
  }
 ACCEPT
}

//*******************************************************
ON CONTROLS_ON {
 IF (§controls_off == 0) ACCEPT
 SET §controls_off 0
 COLLISION ON
 BEHAVIOR UNSTACK
 ACCEPT
}

ON CONTROLS_OFF {
 IF (§enemy == 0) ACCEPT
 SET §controls_off 1
 COLLISION OFF
 BEHAVIOR STACK
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
 ACCEPT
}

//*******************************************************

ON COLLISION_ERROR {
 COLLISION OFF
 TIMERcol 1 1 COLLISION ON
 ACCEPT
}

//*******************************************************

>>ATTACK_DECISION
  IF (§controls_off != 0) ACCEPT
  IF (§enemy != 1) ACCEPT
  IF (§attack == 1) ACCEPT
  HEROSAY -d "DRAGON attack decision"
  RANDOM 20 {
    HEROSAY -d "DRAGON grunt"
    SET §attack 1
    BEHAVIOR FRIENDLY
    SETTARGET PLAYER
    PLAYANIM -e GRUNT SET §attack 0
    TIMERattack1 -m 1 500 QUAKE 300 2000 100 
    IF (£hail != "none") PLAY -p ~£hail~
    ACCEPT
  }
  IF (^DIST_PLAYER > 1000) {
    RANDOM 40 {
      HEROSAY -d "paralyse"
      SET §attack 1
      BEHAVIOR FRIENDLY
      SETTARGET PLAYER
//      TIMERattack1 1 2 PLAYANIM -ne ACTION5 
      SPELLCAST -fsmd 4000 10 PARALYSE PLAYER 
	SET §attack 0
    }
    ELSE {
      HEROSAY -d "DRAGON run after player"
      BEHAVIOR MOVE_TO
      SETTARGET PLAYER
      SETMOVEMODE RUN
    }
  }
  ELSE {
    IF (^DIST_PLAYER < 500) {
     RANDOM 40 {
      HEROSAY -d "DRAGON ICEball"
      SET §attack 1
      BEHAVIOR FRIENDLY
      SETTARGET PLAYER
      TIMERattack1 1 2 PLAYANIM -ne ACTION5 SET §attack 0
      SPELLCAST -smf 10 ICE_PROJECTILE PLAYER
      ACCEPT
     }
      HEROSAY -d "DRAGON strike"
      IF ( £strike != "none" ) PLAY -p ~£strike~
      SET §attack 1
      BEHAVIOR FRIENDLY
      SETTARGET PLAYER
      RANDOM 50 {
        herosay -d "DRAGON Wing Attack"
        TIMERattack1 -m 1 200 GOTO END_STRIKE
        PLAYANIM -ne ACTION7 GOTO DELAY_ATTACK 
//      SET £end_attack "ACTION9"
      }
      ELSE {
        herosay -d "DRAGON Front Attack"
        TIMERattack1 -m 1 500 GOTO END_STRIKE
        PLAYANIM -ne ACTION8 GOTO DELAY_ATTACK
//      SET £end_attack "ACTION10"
      }
     ACCEPT
    }
   HEROSAY -d "DRAGON walk"
   BEHAVIOR MOVE_TO
   SETTARGET PLAYER
   SETMOVEMODE WALK
  }
 ACCEPT

>>END_STRIKE
  QUAKE 300 1000 100
  IF (§attack != 1) ACCEPT // attack aborted by a ouch
// end of strike anim
// PLAYANIM -ne ~£end_attack~ GOTO DELAY_ATTACK
// damage player
  IF (^DIST_PLAYER < 500) {
    SET §tmp ~^RND_10~
    INC §tmp 3
    DODAMAGE -u PLAYER ~§tmp~
  }
 ACCEPT

// random delay until next attack
>>DELAY_ATTACK 
 SET §tmp ~^RND_3~
 INC §tmp 1
 TIMERattack1 1 ~§tmp~ SET §attack 0
 ACCEPT

//*******************************************************
 
ON PATHEND {
  herosay -d "Dragon pathend"
  IF (§arrival == 0) {
    TIMERcam -m 1 400 SENDEVENT CINEMATIC CAMERA_0131 ""
    TIMERla -m 1 500 QUAKE 300 3000 100 PLAY -o earthQ
// 300 2000 100
    SET_SHADOW ON
    PLAYANIM -e ACTION2 TIMERrot -m 25 100 ROTATE 0 2 0
    SET §arrival 1
    SETPATH NONE
    INVULNERABILITY OFF
    DAMAGER 0
    ACCEPT
  }
  IF (§arrival == 1) {
    SET §arrival 2
    LOADANIM WAIT "Dragon_fight_wait"
    TIMER -m 1 500 QUAKE 300 2000 100
    PLAYANIM -e ACTION3 GOTO ATTACK_READY
    DAMAGER 0 
    ACCEPT
  }
 ACCEPT
}

//*******************************************************

>>ATTACK_READY
 SETPATH NONE 
 INVULNERABILITY OFF
 SET §attack 0
 TIMERattack 0 1 GOTO ATTACK_DECISION
 //WEAPON ON
 BEHAVIOR MOVE_TO
 SETTARGET PLAYER
 SETMOVEMODE RUN
 ACCEPT

//*******************************************************

ON ATTACK_PLAYER {
 IF (§controls_off != 0) ACCEPT
 GOTO ATTACK_PLAYER
 ACCEPT
}

//*******************************************************

>>ATTACK_PLAYER
 IF (§controls_off != 0) ACCEPT
 IF (§enemy == 1) ACCEPT
 AMBIANCE -v 100 ambient_fight_music
 SETCONTROLLEDZONE DRAGON
 SET §enemy 1
 SET_EVENT AGRESSION OFF
 IF (£hail != "none") PLAY -p ~£hail~
 TIMER kill_local
 SET §reflection_mode 2
 SETEVENT CHAT OFF
 SENDEVENT CUSTOM MARKER_0668 "FIELD"
// attack path
 SETPATH NONE
 SETPATH -wf ~£attack_path~
 USEPATH P
 PLAYANIM -ne ACTION4 USEPATH F PLAYANIM -L ACTION1
 INVULNERABILITY ON
 DAMAGER -u 20
 ACCEPT

//*******************************************************

ON AGRESSION {
 herosay -d "on agression"
// GOTO OUCHSUITE
 GOTO OUCH_START
 ACCEPT
}

//*******************************************************
 
ON OUCH {
>>OUCH_START
  IF (^#PARAM1 > §pain) {
   SET #TMP ^GAMESECONDS
   DEC #TMP §ouch_tim
   IF (#TMP > 4) {
    FORCEANIM HIT
    SET §ouch_tim ^GAMESECONDS
    IF (§attack == 1) {
   // abort strike
     herosay -d "STRIKE Aborted"
     SET §attack 0
     TIMERattack1 OFF
    }
   }
   SET &TMP §pain
   MUL &TMP 3
   IF (^#PARAM1 >= &TMP) { // big ouch : it hurts !
     IF (£ouch_strong != "none") PLAY -p ~£ouch_strong~
   }
   ELSE {
     SET &TMP §pain
     MUL &TMP 2
     IF (^#PARAM1 >= &TMP) { // medium
       IF (£ouch_medium != "none") PLAY -p ~£ouch_medium~
     }
     ELSE { // normal
       IF (£ouch != "none") PLAY -p ~£ouch~
     } 
   }
  } 

>>OUCHSUITE
  IF (§controls_off != 0  ) ACCEPT
// react to agression -----------------------------------------
  IF (^SENDER == "PLAYER") {
    TIMER -m 1 500 GOTO ATTACK_PLAYER
  }  
 ACCEPT
}

//********************************

ON TARGET_DEATH {
  IF (^SENDER == "PLAYER") {
    BEHAVIOR FRIENDLY
    SETTARGET PLAYER
    IF (^$PARAM1 == ^ME) {
      IF (£hail != "none") PLAY -p ~£hail~
      FORCEANIM GRUNT
    }
  }
 ACCEPT
}

//********************************

ON MISC_REFLECTION {
  IF (§reflection_mode == 0) ACCEPT
  IF ( #SHUT_UP == 1 ) ACCEPT // cinematics
  RANDOM 30 ACCEPT
  IF (§reflection_mode == 1) { // normal
    SET $TMP £misc
    RANDOM 70 ACCEPT
>>MISC_REFLECTION2
    IF ($TMP == "none") ACCEPT
    SET £tmp ^RND_~§sound_amount~
    SET §sound ~£tmp~
    INC §sound 1
    IF (§sound >= §sound_amount) SET §sound 1
    PLAY -p ~$TMP~~§sound~
    ACCEPT
  }
  IF (§reflection_mode == 2) { // fighting
    SET $TMP £threat
    GOTO MISC_REFLECTION2
    ACCEPT
  }
  IF (§reflection_mode == 3) { // searching
    SET $TMP £threat
    GOTO MISC_REFLECTION2
    ACCEPT
  }
 ACCEPT
}

//********************************

ON DIE {
 SETDETECT -1
 AMBIANCE -v 0 ambient_fight_music
 INVENTORY CREATE  //specific
 INVENTORY ADD "Jewelry\\ruby\\ruby"
 INVENTORY ADD "Provisions\\dragon_bone\\dragon_bone"
 INVENTORY ADD "Provisions\\bone\\bone"
 INVENTORY ADD "Jewelry\\emerald\\emerald"
 INVENTORY ADD "Provisions\\dragon_bone\\dragon_bone"
 INVENTORY ADD "Jewelry\\diamond\\diamond"
 INVENTORY ADD "Provisions\\dragon_bone\\dragon_bone"
 INVENTORY ADD "Provisions\\bone\\bone"
 INVENTORY ADDMULTI "Jewelry\Gold_coin\Gold_coin" 5764
 TIMERmisc_reflection OFF
 TIMERattack OFF
 TIMERattack1 OFF
 FORCEANIM DIE
 IF (£dying != "none") PLAY -p ~£dying~
 SENDEVENT CUSTOM MARKER_0668 "DRAGON_DIE"
 COLLISION OFF
 ACCEPT
}

ON REACHEDTARGET {
IF (^TARGET == corpse_0050) {
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
// SET §safespot 1
 ACCEPT
 }
ACCEPT
}

ON DETECTPLAYER {
IF (§safespot == 0) ACCEPT
SET §safespot 0
AMBIANCE -v 100 ambient_fight_music
SETCONTROLLEDZONE DRAGON
GOTO ATTACK_READY
ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
