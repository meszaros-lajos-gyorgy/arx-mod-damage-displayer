ON INIT {
 SET §quake 0
 PHYSICAL RADIUS 250
 SET_ARMOR_MATERIAL LEATHER
 SET_WEAPON_MATERIAL AXE
 SET_BLOOD 0.9 0.1 0.1
 SET §ouch_tim 0
 SETNAME [description_worm_big]
 SET_NPC_STAT RESISTMAGIC 70
 SET_NPC_STAT RESISTPOISON 90
 SET_NPC_STAT RESISTFIRE 10
 SET_NPC_STAT armor_class 20
 SET_NPC_STAT absorb 40
 SET_NPC_STAT damages 30
 SET_NPC_STAT tohit 60
 SET_NPC_STAT aimtime 3000
 SET_NPC_STAT life 800 // 200 plus 600 (at 600 or less -> worm is fleeing )
 SET_XP_VALUE 800
// SET_NPC_STAT mana
 LOADANIM WALK "worm_walk"
 LOADANIM WAIT "worm_wait"
 LOADANIM HIT "worm_receive_damage"
 LOADANIM STRIKE "worm_attack"
 LOADANIM DIE "worm_death2"
 ACCEPT
}

ON INITEND
{
 SETCONTROLLEDZONE "ZONEWORMON"
 SETCONTROLLEDZONE "ZONEWORMOFF"
 SETPATH -wf WORMPATH
USEPATH P
 PLAYANIM -l WAIT
 SET §wlkanm 0
// DAMAGER -u 40
// COLLISION ON
 ATTRACTOR SELF -100 250
 SET §forward 0 // 0 : backward, 1 : forward initialized at 0 to force a usepath p in waypoint0
 SET §status 0 // 0 : sleeping, 1 : attacking, 2: back to home ,3 : fleeing
 SET §path_position 0 // 0 : start, 1 : middle, 2 : end
 SET §attacking 0 // 1 : attacking player, 0 : ready
 SET §back_to_home 0 // used when fleeing : 1 ok, I'm back 2 home so I can die
 ACCEPT
}

>>FORWARD
 USEPATH F
 SET §forward 1
 SET §path_position 1
 IF (§wlkanm == 1) RETURN
 SET §wlkanm 1
 PLAYANIM -l WALK
RETURN
>>BACKWARD
 USEPATH B
 SET §forward 0
 SET §path_position 1
 IF (§wlkanm == 1) RETURN
 SET §wlkanm 1
 PLAYANIM -l WALK
 TIMERworm OFF
RETURN
>>WORM_ATTACK
herosay -d "ATTACK"
 USEPATH P
 SET §attacking 1
 ATTRACTOR SELF -100 400
 SET §wlkanm 0
 PLAYANIM -e STRIKE GOTO END_ATTACK
 TIMERdmg -m 1 400 GOTO DAMAGE
 IF ( §quake == 0 )
 {
  QUAKE 300 1000 100 
  SET §quake 1
  TIMERquake 1 1 SET §quake 0
 }
RETURN
>>DAMAGE
 IF ( ^DIST_PLAYER < 500 ) 
 {
  SET #TMP ~^RND_10~
  INC #TMP 5
  DODAMAGE PLAYER ~#TMP~ 
 }
ACCEPT
>>END_ATTACK
 ATTRACTOR SELF -100 250
 TIMERatckagain 1 1 SET §attacking 0
 SET §wlkanm 0
 PLAYANIM -l WAIT
ACCEPT

// test player distance & manage combat
ON _EST_PLAYER_DIST
{
 IF ( ^LIFE < 600 )
 { // it's getting dangerous here, back to home ! 
  SET §status 3 // fleeing
  herosay -d "FLEEING !!!!!!"
  IF ( §path_position != 0 )
  {
   INVULNERABILITY ON
   SET §wlkanm 0
   SETCONTROLLEDZONE "ZONEWORMON"
   SETCONTROLLEDZONE "ZONEWORMOFF"
   GOSUB BACKWARD
   ACCEPT
  }
 }
 IF ( ^DIST_PLAYER < 200 )
 { // too close : back
  IF ( §path_position != 0 )
  {
   GOSUB BACKWARD
  }
  ELSE
  {
   IF ( §attacking == 0 ) GOSUB WORM_ATTACK
  }
 }
 ELSE
 {
  IF ( ^DIST_PLAYER < 400 )
  { // attack !
   IF ( §attacking == 0 ) GOSUB WORM_ATTACK
   IF ( §status != 3 ) SET §status 1
  }
  ELSE
  {
    // can't go that far 
   IF ( §path_position == 2 )
   {
    SET §status 2
    GOSUB BACKWARD
   }
   ELSE
   {
    IF ( §status == 1 )
    {
     GOSUB FORWARD
    }
   }
  }
 }
 ACCEPT
}

ON CONTROLLEDZONE_ENTER 
{
 IF ( ^$PARAM1 != PLAYER ) ACCEPT
 IF ( ^$PARAM2 == "AMBIENT_KILL_FIGHT" ) {
  AMBIANCE -v 0 ambient_fight_music
  UNSET_CONTROLLED_ZONE AMBIENT_KILL_FIGHT
  ACCEPT
 }
 IF ( ^$PARAM2 == "ZONEWORMON" )
 {
  SETCONTROLLEDZONE AMBIENT_KILL_FIGHT 
  herosay -d "WORM GO !!!"
  AMBIANCE -v 100 ambient_fight_music
  IF ( §status < 3 ) SET §status 1 // attacking
  TIMERworm 0 1 SENDEVENT TEST_PLAYER_DIST SELF ""
  SENDEVENT TEST_PLAYER_DIST SELF ""
  IF (§quake == 0) 
  {
   QUAKE 200 8000 100 
   SET §quake 1
   TIMERquake 1 8 SET §quake 0
  }
  ACCEPT
 }
 IF ( ^$PARAM2 == "ZONEWORMOFF" )
 {
  herosay -d "WORM BACK !!!"
  TIMERworm OFF
  IF ( §status < 3 ) SET §status 2 // back to home
  GOSUB BACKWARD
  ACCEPT
 }
 ACCEPT
}

ON PATHEND
{
 herosay -d "Path End reached"
 USEPATH P
 SET §path_position 2
 ACCEPT
}

// back to home
ON WAYPOINT0
{
 IF ( §forward == 1 ) ACCEPT
 herosay -d "Way point 0 reached"
 USEPATH P
 IF ( §status != 3 ) 
 {
  SET §status 0
 }
 ELSE
 {
  IF ( §back_to_home == 0 )
  {
   PLAYANIM -l WAIT
   SET §back_to_home 1
   INVULNERABILITY OFF
   SET_NPC_STAT life 50
  }
 }
 SET §path_position 0
 ACCEPT
}

ON OUCH {
 IF (§back_to_home == 1) FORCEDEATH SELF ACCEPT
 IF (^#PARAM1 < 20) ACCEPT
 SET #TMP ^GAMESECONDS
 DEC #TMP §ouch_tim
 IF (#TMP > 4) {
  SET §wlkanm 0
  FORCEANIM HIT
  SET §ouch_tim ^GAMESECONDS
 }
 ACCEPT
}

ON DIE {
 FORCEANIM DIE
 herosay -d "worm's dying"
 SET §attacking 1
 TIMERworm OFF
 TIMERdeorm 1 7 GOTO DEAD_WORM
 SET §wlkanm 0
 AMBIANCE -v 0 ambient_fight_music
 QUAKE 300 4000 100 
 DAMAGER 0
 ACCEPT
}

>>DEAD_WORM
 IF (^DIST_PLAYER < 1000) {
  WORLD_FADE OUT 7000 0.8 0 0 GOTO DEAD_WORM1
  ACCEPT
 }
 GOTO DEAD_WORM1
ACCEPT
>>DEAD_WORM1
 PLAY "Worm_explos"
 QUAKE 300 4000 100 
 OBJECT_HIDE SELF ON
 ATTRACTOR SELF OFF
 WORLD_FADE IN 4000  
ACCEPT

ON TEST_PLAYER_DIST
{
 IF ( ^LIFE < 50 )
 { // it's getting dangerous here, back to home ! 
  SET §status 3 // fleeing
  herosay -d "FLEEING !!!!!!"
  IF ( §path_position != 0 )
  {
   SET §wlkanm 0
   SETCONTROLLEDZONE "ZONEWORMON"
   SETCONTROLLEDZONE "ZONEWORMOFF"
   GOSUB BACKWARD
   ACCEPT
  }
 }
 IF ( ^DIST_PLAYER < 200 )
 { // too close : back
  IF ( §path_position != 0 )
  {
   GOSUB BACKWARD
  }
  ELSE
  {
   IF ( §attacking == 0 ) GOSUB WORM_ATTACK
  }
 }
 ELSE
 {
  IF ( ^DIST_PLAYER < 400 )
  { // attack !
   IF ( §attacking == 0 ) GOSUB WORM_ATTACK
   IF ( §status != 3 ) SET §status 1
  }
  ELSE
  {
    // can't go that far 
   IF ( §path_position == 2 )
   {
    SET §status 2
    GOSUB BACKWARD
   }
   ELSE
   {
    IF ( §status == 1 )
    {
     GOSUB FORWARD
    }
   }
  }
 }
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
