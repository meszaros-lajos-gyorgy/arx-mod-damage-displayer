ON INIT {
  LOADANIM WAIT      "Iserbius_phase1_merge"
  LOADANIM ACTION1 "Iserbius_phase1_to_phase2"
  LOADANIM ACTION2 "Priest_dead_3_talkcycle"
  SET_BLOOD 0.9 0.1 0.1
  SETDETECT 40
ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
