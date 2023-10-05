ON INIT {
 INVULNERABILITY ON
 OBJECT_HIDE SELF ON
 COLLISION OFF
 PHYSICAL RADIUS 20
 PHYSICAL HEIGHT 100
// SETSCALE 180
 SET_NPC_STAT armor_class 30
 SET_NPC_STAT absorb 20
 SET_NPC_STAT damages 55
 SET_NPC_STAT tohit 50
 SET_NPC_STAT aimtime 2000
 SET_NPC_STAT life 1000
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_bare
 SET_WEAPON_MATERIAL CLAW
 SET_BLOOD 0.9 0.1 0.1
 SETIRCOLOR 0.8 0.0 0.0
 SETGROUP £friend
 BEHAVIOR NONE
 SETTARGET NONE
 SET £AKBAA "none" // specific

 loadanim BARE_READY                 "Tentacule_ready"
 loadanim BARE_UNREADY               "Tentacule_unready"
 loadanim BARE_WAIT                  "Tentacule_bare_wait"
 loadanim BARE_STRIKE_LEFT_START     "Tentacule_balayage_start" 
 loadanim BARE_STRIKE_LEFT_CYCLE     "Tentacule_balayage_cycle"
 loadanim BARE_STRIKE_LEFT           "Tentacule_balayage_end"
 loadanim BARE_STRIKE_RIGHT_START    "Tentacule_balayage_start"
 loadanim BARE_STRIKE_RIGHT_CYCLE    "Tentacule_balayage_cycle"
 loadanim BARE_STRIKE_RIGHT          "Tentacule_balayage_end"
 loadanim BARE_STRIKE_TOP_START      "Tentacule_balayage_low_fast"
 loadanim BARE_STRIKE_TOP_CYCLE      "Tentacule_balayage_cycle"
 loadanim BARE_STRIKE_TOP            "Tentacule_balayage_end"
 loadanim BARE_STRIKE_BOTTOM_START   "Tentacule_balayage_start"
 loadanim BARE_STRIKE_BOTTOM_CYCLE   "Tentacule_balayage_cycle"
 loadanim BARE_STRIKE_BOTTOM         "Tentacule_balayage_end"

// LOADANIM GRUNT                      "demon_grunt"  //*****************  NEW
 loadanim FIGHT_WALK_FORWARD         "tentacle_fight_walk"
// loadanim FIGHT_WALK_BACKWARD        ""
// loadanim FIGHT_STRAFE_RIGHT         ""
// loadanim FIGHT_STRAFE_LEFT          ""
 LOADANIM WALK                       "tentacle_walk"
 LOADANIM RUN                        "tentacule_run"
 LOADANIM WAIT                       "Tentacule_wait"
 loadanim FIGHT_WAIT                 "Tentacule_fight_wait"
 LOADANIM HIT                        "Tentacule_hit"
 LOADANIM HIT_SHORT                  "Tentacule_hit"
 LOADANIM DIE                        "Tentacule_die"
 LOADANIM ACTION1                    "tentacule_attack_total"
// LOADANIM ACTION2                    "Tentacule_balayage_low_fast"
// LOADANIM ACTION3                    "Tentacule_down"
ACCEPT
}

ON INITEND
{
 SET §attacking 1
  HALO -ocs 0.137 0.403 0.372 100
 OBJECT_HIDE SELF 
 ON COLLISION OFF
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
 ACCEPT
}

ON CUSTOM {
 IF (^$PARAM1 == "ATTACK") 
 {
  SET £AKBAA ^SENDER
  SET §attacking 0
  IF ( ^PLAYER_ZONE == "ZONETENTACLE1" )
  {
   herosay -d "player in tentacle zone 1"
   TELEPORT "Marker_0130"
  }
  ELSE
  {
   IF ( ^PLAYER_ZONE == "ZONETENTACLE2" )
   {
    herosay -d "player in tentacle zone 2"
    TELEPORT "Marker_0131"
   }
   ELSE
   {
    IF ( ^PLAYER_ZONE == "ZONETENTACLE3" )
    {
     herosay -d "player in tentacle zone 3"
     TELEPORT "Marker_0132"
    }
    ELSE
    {
     TELEPORT -i
    }
   }
  }
  OBJECT_HIDE SELF OFF
  COLLISION ON
  BEHAVIOR MOVE_TO
  SETTARGET PLAYER
  SETMOVEMODE RUN
  TIMERforget 1 5 SENDEVENT FORGET SELF ""
  herosay -d "tentacle attack !"
  ACCEPT
 }
 IF (^$PARAM1 == "DIE") 
 {
  DESTROY SELF
 } 
 ACCEPT
}

>>END_ATTACK
 SENDEVENT CUSTOM £AKBAA "TENTACLE_ATTACKED" 
 ATTRACTOR SELF OFF
 DAMAGER 0
 OBJECT_HIDE SELF 
 ON COLLISION OFF
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
ACCEPT

ON REACHEDTARGET 
{
 IF (^TARGET != PLAYER) ACCEPT
 IF ( §attacking == 1 ) ACCEPT
herosay -d "tentacle reached target"
 TIMERforget OFF
 ATTRACTOR SELF 10 200
 PLAY akbaa_tentacule_strike
 PLAYANIM -e ACTION1 GOTO END_ATTACK
 DODAMAGE -pu ~^RND_15~
// POISON 15   // Strange it doesn't work... 
//DAMAGE PLAYER
 SET §attacking 1
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
 DAMAGER -u 30
 ACCEPT
}

ON FORGET
{
 herosay -d "tentacle forget"
 GOTO END_ATTACK
 ACCEPT
}

ON COLLISION_ERROR
{
herosay -d "collision error"
 COLLISION OFF
 TIMERcol 1 1 COLLISION ON
 ACCEPT
}

ON DIE
{
 herosay -d "tentacle dying"
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
