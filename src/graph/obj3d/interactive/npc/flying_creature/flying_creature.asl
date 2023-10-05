ON INIT {
//SETARMORMATERIAL METAL
 PHYSICAL RADIUS 30
 SET_BLOOD 0.9 0.1 0.1
// SET_NPC_STAT armor_class 80
 SET_NPC_STAT absorb 20
 SET_NPC_STAT damages 2
 SET_NPC_STAT tohit 10
// SET_NPC_STAT aimtime 800
 SET_NPC_STAT life 5000
// SET_XP_VALUE 300
// SET_NPC_STAT mana
 SETIRCOLOR 1.0 0.0 0.0
 INVENTORY CREATE
 LOADANIM WAIT "flying_normal_wait"
 LOADANIM WALK "flying_normal_walk"
 loadanim BARE_READY                 "Blackthing_fight_attack_start"
 loadanim BARE_UNREADY               "Blackthing_fight_attack_strike"
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
 LOADANIM DIE "flying_die_classic"
//BEHAVIOR -F MOVE_TO
 SETTARGET PLAYER
 ACCEPT
}

ON MAIN {
 ACCEPT
}

ON MOVE {
 SETMOVEMODE WALK
 ACCEPT
}


ON LOSTTARGET {
 ACCEPT
}

ON DIE {
 FORCEANIM DIE
 ACCEPT
}

ON DEAD {
 ACCEPT
}

ON OUCH {
HEROSAY ^$PARAM1
ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
