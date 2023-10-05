ON INIT {
 SET_MATERIAL FLESH
 SET_NPC_STAT life 60
 SET_SHADOW OFF
 LOADANIM ACTION1 "Tortured_corpse_touch_inter"
 LOADANIM ACTION2 "Tortured_corpse_touch"
 LOADANIM WAIT "hanged_gob_wait"
 SET_NPC_STAT RESISTPOISON 200
 ACCEPT
}

ON INITEND {
 PLAYANIM WAIT
 ACCEPT
}

ON DIE {
 DESTROY ME
 ACCEPT
}

ON CHAT {
 PLAYANIM ACTION2
 ACCEPT
}

ON COLLIDE_NPC {
 PLAYANIM ACTION2
 ACCEPT
}

ON OUCH {
>>DO
  RANDOM 50 {
    PLAYANIM ACTION2
    ACCEPT
  }
  RANDOM 50 {
    PLAYANIM ACTION3
    ACCEPT
  }
 GOTO DO
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
