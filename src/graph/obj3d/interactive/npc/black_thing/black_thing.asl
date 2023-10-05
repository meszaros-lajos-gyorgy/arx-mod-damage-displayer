ON INIT {
 SET §player_in_sight 0         //used for various reasons, =1 indicates that the NPC currently sees he player.
 SET §fighting_mode 0           //0 = NO   1 = Fighting    2 = Fleeing
 SET §frozen 0                  //to stop looping anims if ATTACK_PLAYER called
 PHYSICAL RADIUS 35
 PHYSICAL HEIGHT 150
 SETDETECT 40
 SET_NPC_STAT RESISTMAGIC 100
 SET_NPC_STAT RESISTPOISON 100
 SET_NPC_STAT RESISTFIRE 100
 SET_NPC_STAT armor_class 200
 SET_NPC_STAT absorb 100
 SET_NPC_STAT damages 250
 SET_NPC_STAT tohit 200
 SET_NPC_STAT aimtime 500
 SET_NPC_STAT reach 40
 SET_NPC_STAT life 1000
 SET_XP_VALUE 1000
 SETNAME [description_blackthing]
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_large
 SET_WEAPON_MATERIAL CLAW
 SET_BLOOD 0.1 0.1 0.1
 SETIRCOLOR 0.8 0.0 0.0
 SET §enemy 0                   //defines if the NPC is enemy to the player at the moment
 BEHAVIOR NONE
 SETTARGET NONE

// loadanim BARE_READY                 "Blackthing_fight_attack_start"
// loadanim BARE_UNREADY               "Blackthing_fight_attack_strike"
 loadanim BARE_WAIT                  "Blackthing_fight_wait_toponly"
 loadanim BARE_STRIKE_LEFT_START     "Blackthing_fight_attack_start" 
 loadanim BARE_STRIKE_LEFT_CYCLE     "Blackthing_fight_attack_cycle"
 loadanim BARE_STRIKE_LEFT           "Blackthing_fight_attack_strike"
 loadanim BARE_STRIKE_RIGHT_START    "Blackthing_fight_attack_start"
 loadanim BARE_STRIKE_RIGHT_CYCLE    "Blackthing_fight_attack_cycle"
 loadanim BARE_STRIKE_RIGHT          "Blackthing_fight_attack_strike"
 loadanim BARE_STRIKE_TOP_START      "Blackthing_fight_attack_start"
 loadanim BARE_STRIKE_TOP_CYCLE      "Blackthing_fight_attack_cycle"
 loadanim BARE_STRIKE_TOP            "Blackthing_fight_attack_strike"
 loadanim BARE_STRIKE_BOTTOM_START   "Blackthing_fight_attack_start"
 loadanim BARE_STRIKE_BOTTOM_CYCLE   "Blackthing_fight_attack_cycle"
 loadanim BARE_STRIKE_BOTTOM         "Blackthing_fight_attack_strike"
//  LOADANIM GRUNT                      "Spider_grunt"  //*****************  NEW
 loadanim FIGHT_WALK_FORWARD         "blackthing_walk_fight"
// loadanim FIGHT_WALK_BACKWARD        "blackthing_walkback"
//  loadanim FIGHT_STRAFE_RIGHT         "spider_small_strafe_right"
//  loadanim FIGHT_STRAFE_LEFT          "spider_small_strafe_left"
 LOADANIM WALK                       "blackthing_walk"
 LOADANIM RUN                        "blackthing_run"
 LOADANIM WAIT                       "Blackthing_normal_wait"
 loadanim FIGHT_WAIT                 "Blackthing_fight_wait"
 LOADANIM HIT                        "blackthing_gethit"
 LOADANIM HIT_SHORT                  "blackthing_gethit"
 LOADANIM DIE                        "Blackthing_death"
 ACCEPT
}

ON INITEND {
 SETSCALE 80
 ATTRACTOR SELF -100 150
 PLAYANIM WAIT
 ACCEPT
}
//START*******************************************************


ON COLLISION_ERROR
{
HEROSAY -d "COL ERROR"
 COLLISION OFF
 TIMERcol 1 1 COLLISION ON
 ACCEPT
}

//*******************************************************
ON ATTACK_PLAYER 
{
 GOTO ATTACK_PLAYER
 ACCEPT
}

>>ATTACK_PLAYER
 TIMER kill_local
 IF (§frozen == 1) SET §frozen 0 PLAYANIM NONE PLAYANIM -2 NONE
  BEHAVIOR -f MOVE_TO
  SETTARGET -a PLAYER
  SETMOVEMODE WALK
 ACCEPT

//*******************************************************

ON TARGET_DEATH {
  SET §enemy 0
  SET §fighting_mode 0
 BEHAVIOR WANDER_AROUND 1000
 SETTARGET PLAYER
 ACCEPT
}

//********************************

ON DIE {
//mettre des bouts de nains
//#die_animal
 SETEVENT CHAT OFF
 TIMERmisc_reflection OFF
 FORCEANIM DIE
 IF (£dying != "none") PLAY -p ~£dying~
 COLLISION OFF
 SETDETECT -1
 SET §totaldead 1


//#
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
