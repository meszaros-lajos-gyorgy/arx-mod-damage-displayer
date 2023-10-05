ON INIT {
 SET §disappear 0
 SET §local 0
 SET §number 0
 LOADANIM WAIT "Frog_wait"
 ACCEPT
}

ON INITEND {
 PLAYANIM -l WAIT
 SET §save_number ~§number~
 SET §jump 0
 SET_INTERACTIVITY NONE
 LOADANIM ACTION1 "frog_jump_water"
 LOADANIM ACTION2 "frog_jump"
 SET §timer 3
 SET #TMP ~^RND_8~
 INC §timer #TMP
 IF (§local == 1) ACCEPT
 TIMERtest -im 0 250 GOTO TEST
 TIMERcroa -i 0 ~§timer~ GOTO CROA
 ACCEPT
}
ON RELOAD {
 IF (§disappear == 0) ACCEPT
 RANDOM 60 {
 >>RESET2
  TIMERreset OFF
  TIMERcroa -i 0 ~§timer~ GOTO CROA
  TELEPORT -i
  PLAYANIM NONE
  PLAYANIM -l WAIT
  SET §number ~§save_number~
  SET §disappear 0
  SET §jump 0
  OBJECT_HIDE SELF NO
  IF (§local == 1) ACCEPT
  TIMERtest -mi 0 500 GOTO TEST
  ACCEPT
 }
 ACCEPT
}
ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
 GOTO DISAPPEAR
 ACCEPT
}
ON OUCH {
 GOTO DISAPPEAR
 ACCEPT
}

>>TEST
 IF (§jump == 1) ACCEPT
 IF (^DIST_PLAYER > 300) ACCEPT
  SET §jump 1
  PLAY -p "frog1"
  IF (§number != 0) GOTO WAIT 
  TIMERtest OFF
  SET §disappear 1
  TIMERcroa OFF
  TIMERreset 0 20 IF (^DIST_PLAYER > 1200) GOTO RESET
  PLAYANIM NONE
  TIMERplouf -m 1 200 PLAY NPC_FootStep_water_step2 OBJECT_HIDE SELF YES
  PLAYANIM ACTION1 
  ACCEPT


>>WAIT
 PLAYANIM -e ACTION2 GOTO WAIT2
 ACCEPT

>>WAIT2
 DEC §number 1
 SET §jump 0
 ACCEPT

>>RESET
 RANDOM 40 {
  GOTO RESET2
  ACCEPT
 }
 ACCEPT

>>CROA
RANDOM 40 {
 PLAY "Frog1"
 ACCEPT
}
RANDOM 60 {
 PLAY "Frog2"
 ACCEPT
}
ACCEPT

>>DISAPPEAR
 TIMERtest OFF
 SET §disappear 1
 TIMERcroa OFF
 TIMERreset 0 20 IF (^DIST_PLAYER > 1200) GOTO RESET
 PLAYANIM NONE
 OBJECT_HIDE SELF YES
 ACCEPT
