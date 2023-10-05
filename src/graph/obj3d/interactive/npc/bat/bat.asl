ON INIT {
 SETSPEED 1.2
 SET £path "BAT1"
 SETIRCOLOR 1.0 0.0 0.0
 INVENTORY CREATE
 LOADANIM WAIT "bat_fly"
 //SENDEVENT GO SELF ""
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_bare
 SET_WEAPON_MATERIAL CLAW
 SET_BLOOD 0.9 0.1 0.1
 DAMAGER 10
 ACCEPT
}

ON GO {
 PLAYANIM -L WAIT
 SETPATH -wf ~£path~
 TIMERbat 1 1 PLAY "bat"
 SETTARGET PATH
 ACCEPT
}

ON PATHEND {
herosay -d "bat killed"
DESTROY ME
ACCEPT
}

ON COLLIDE_NPC {
 DAMAGER 0
 IF (§collide == 1) ACCEPT
 IF (§collide == 0) {
  SET §collide 1
  DO_DAMAGE PLAYER 8
  ACCEPT
 }
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
