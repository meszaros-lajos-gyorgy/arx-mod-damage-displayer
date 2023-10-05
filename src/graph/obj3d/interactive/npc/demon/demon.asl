ON INIT {
 SENDEVENT GIVEID HUMAN_BASE_0099 ""
 SET �controlled 0
 SET �order 0
 SET �iserbius 0			// Used for special death when in Akbaa's temple
 SET �caster "NONE"
 SETDETECT 40
//#init_animal
// ---------------------------------------------------------------------------------
// INIT_ANIMAL INCLUDE START -------------------------------------------------------
// ---------------------------------------------------------------------------------
 SET_EVENT HEAR OFF
 SET �sleeping 0                //meynier... tu dors...

 SET �main_behavior_stacked 0   //in order to restore the main behavior after a look_for or a help
 SET �reflection_mode 1         // 0: nothing, 1: normal, 2: threat, 3: search 
 SET �player_in_sight 0         //used for various reasons, =1 indicates that the NPC currently sees he player.

 SET �looking_for 0             //1 = the NPC is about to look for the player 2=looking for him 
 SET �fighting_mode 0           //0 = NO   1 = Fighting    2 = Fleeing
 SET �frozen 0                  //to stop looping anims if ATTACK_PLAYER called
 SET �spoted 0                  //defines if the NPC has already said "I'll get you" to the player

 SET �tmp "none"              //For animals only
 SET �sound 0                 //For animals only 
 SET �ouch_tim 0   
 SET �last_heard "NOHEAR"

 SET_NPC_STAT BACKSTAB 1

 SET �init_marker "NONE"	// go back to this marker if combat finished

 SET �door_locked_attempt 0	// number of attempts of passing throw a locked door
 SETDETECT 40

 INVENTORY SKIN "ingame_inventory_corpse"
// ---------------------------------------------------------------------------------
// INIT_ANIMAL INCLUDE END ---------------------------------------------------------
// ---------------------------------------------------------------------------------

//#
 SETSCALE 80
 SET_NPC_STAT RESISTMAGIC 20
 SET_NPC_STAT RESISTPOISON 40
 SET_NPC_STAT RESISTFIRE 90
 SET_NPC_STAT armor_class 30
 SET_NPC_STAT absorb 20
 SET_NPC_STAT damages 25
 SET_NPC_STAT tohit 50
 PHYSICAL RADIUS 30
 PHYSICAL HEIGHT 150
 SET_NPC_STAT aimtime 200
 SET_NPC_STAT life 140
 SET_NPC_STAT REACH 100
 SET �confusability 8           // level of magic needed to confuse this npc
 SET_XP_VALUE 1000
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_large
 SET_WEAPON_MATERIAL CLAW
 SET_BLOOD 0.9 0.1 0.1
 SETIRCOLOR 0.8 0.0 0.0
 SET �enemy 1                   //defines if the NPC is enemy to the player at the moment
 SET �tactic 0                  //0 = normal    1 = sneak   2 = rabit  3 = caster
 SET �current_tactic �tactic    //** used to restore previous tactic after a repel undead
 SET �cowardice 0   
 SET �pain 2                
 SET �low_life_alert 10
 SET �panicmode 1
 SET �sound_amount 3          //For animals only
 SET �friend "DEMON"
 SETGROUP �friend
 BEHAVIOR NONE
 SETTARGET NONE

 loadanim BARE_READY                 "demon_fight_ready_toponly"
 loadanim BARE_UNREADY               "demon_fight_unready_toponly"
 loadanim BARE_WAIT                  "demon_fight_wait_toponly"
 loadanim BARE_STRIKE_LEFT_START     "demon_attack_left_start" 
 loadanim BARE_STRIKE_LEFT_CYCLE     "demon_attack_left_cycle"
 loadanim BARE_STRIKE_LEFT           "demon_attack_left_strike"
 loadanim BARE_STRIKE_RIGHT_START    "demon_attack_right_start"
 loadanim BARE_STRIKE_RIGHT_CYCLE    "demon_attack_right_cycle"
 loadanim BARE_STRIKE_RIGHT          "demon_attack_right_strike"
 loadanim BARE_STRIKE_TOP_START      "demon_fight_left_start"
 loadanim BARE_STRIKE_TOP_CYCLE      "demon_fight_left_cycle"
 loadanim BARE_STRIKE_TOP            "demon_fight_left_strike"
 loadanim BARE_STRIKE_BOTTOM_START   "demon_fight_right_start"
 loadanim BARE_STRIKE_BOTTOM_CYCLE   "demon_fight_right_cycle"
 loadanim BARE_STRIKE_BOTTOM         "demon_fight_right_strike"

 LOADANIM GRUNT                      "demon_grunt"  //*****************  NEW
 loadanim FIGHT_WALK_FORWARD         "demon_walk"
// loadanim FIGHT_WALK_BACKWARD        "demon_walk_back"
 loadanim FIGHT_STRAFE_RIGHT         "demon_strafe_right"
 loadanim FIGHT_STRAFE_LEFT          "demon_strafe_left"
 LOADANIM WALK                       "demon_walk"
 LOADANIM RUN                        "demon_run"
 LOADANIM WAIT                       "demon_wait"
 loadanim FIGHT_WAIT                 "demon_fight_wait"
 LOADANIM HIT                        "demon_receive_damage"
 LOADANIM HIT_SHORT                  "demon_hit_short"
 LOADANIM DIE                        "demon_death"

 SET �hail "demon_hail"
 SET �strike "none"
 SET �misc "demon_breath"
 SET �threat "none"
 SET �dying "none"
 SET �ouch "demon_breath1"
 SET �ouch_medium "demon_breath2"
 SET �ouch_strong "demon_ouch"
 IF (�sound_amount > 0) TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
 ACCEPT
}

ON INITEND {
 if ( �enemy == 1 ) SET_EVENT HEAR ON
 IF (�sound_amount != 0) INC �sound_amount 1
 COLLISION OFF
 COLLISION ON
 ATTRACTOR SELF -500 150
 SENDEVENT CUSTOM SELF "INIT" //XXXXX only because local initend is not executed by revive !
 ACCEPT
}

//START*******************************************************

//***************SPECIFIC TO DEMON

ON SUMMONED {
 HEROSAY -D ^SENDER
 IF (^SENDER == PLAYER) {
  SET �belongs_to_player 1
  SET �panicmode 0
  SET_XP_VALUE 0
  TIMERgrunt 1 1 PLAYANIM -e GRUNT GOTO SUMMONSUITE
  ACCEPT
 }
 TIMERyep 1 1 PLAYANIM -e GRUNT GOTO ATTACK_PLAYER
 ACCEPT
}

>>SUMMONSUITE
HEROSAY -d "summonsuite"
BEHAVIOR WANDER_AROUND 300
SETTARGET PLAYER
SET �summon_attacking 0
SET �panicmode 0
TIMERscrute 0 1 GOTO SCRUTE
ACCEPT

>>SCRUTE
IF (�panicmode == 1) {
 // means attacking player
 TIMERscrute OFF
 ACCEPT
}
HEROSAY -d ^NPCINSIGHT
IF (^NPCINSIGHT != "NONE") {
 IF (^NPCINSIGHT ISCLASS MICE) ACCEPT
 HEROSAY -d "medor attaque"
 BEHAVIOR -f MOVE_TO
 SETTARGET ^NPCINSIGHT
 TIMERscrute OFF
 SET �summon_attacking 1
}
ACCEPT

ON NPC_CONTROL {
 IF (^$PARAM1 == ^ME) ACCEPT
 IF (^#PARAM2 < 10) {
  SPEAK -p [player_not_skilled_enough] NOP
  ACCEPT
 }
 BEHAVIOR -f MOVE_TO
 SETTARGET ^$PARAM1
 ACCEPT
}

//***************END SPECIFIC

ON CHAT {
 IF (�enemy == 1) SENDEVENT DETECTPLAYER SELF ""
 ACCEPT
}

//#behavior_animal

// ---------------------------------------------------------------------------------
// BEHAVIOR INCLUDE START ----------------------------------------------------------
// ---------------------------------------------------------------------------------
>>SAVE_BEHAVIOR
 TIMERcolplayer OFF // to avoid TIMERcolplayer to restore the behavior 1 sec later
 IF (�main_behavior_stacked == 0) 
 {
  IF (�frozen == 1)
  { // frozen anim -> wake up !
    SET �frozen 0
    PLAYANIM NONE
    PLAYANIM -2 NONE
    PHYSICAL ON
    COLLISION ON
    BEHAVIOR FRIENDLY
    SETTARGET PLAYER
  }
  SET �main_behavior_stacked 1
  HEROSAY -d "STACK"
  BEHAVIOR STACK
 }
RETURN

>>RESTORE_BEHAVIOR
 IF (�main_behavior_stacked == 1) 
 {
  HEROSAY -d "UNSTACK"
  BEHAVIOR UNSTACK
  SET �main_behavior_stacked 0
  RETURN
 }
 IF (�init_marker != "NONE")
  { 
   BEHAVIOR MOVE_TO
   SETTARGET -a ~�init_marker~
   SETMOVEMODE WALK
   RETURN
  }
 HEROSAY -d "go_home"
 BEHAVIOR GO_HOME
 SETTARGET PLAYER
 RETURN
// ---------------------------------------------------------------------------------
// BEHAVIOR INCLUDE END ------------------------------------------------------------
// ---------------------------------------------------------------------------------

//#

//#main_animal
// -------------------------------------------------------------------------------
// MAIN ANIMAL INCLUDE START -----------------------------------------------------
// -------------------------------------------------------------------------------

ON RELOAD {
 IF (�totaldead == 0) {
  IF (�fighting_mode > 0) {
   IF (�init_marker != "NONE") TELEPORT ~�init_marker~
   IF (�init_marker == "NONE") TELEPORT -i
 //  WEAPON OFF
   SET �fighting_mode 0
   SET �player_in_sight 0
   SET �reflection_mode 0
   SETEVENT HEAR ON
   SETMOVEMODE WALK
   BEHAVIOR WANDER_AROUND 300
   SETTARGET NONE
  }
 }
 ACCEPT
}

ON CONTROLS_ON
{
 IF (�frozen == 1) ACCEPT
 IF ( �controls_off == 0 ) ACCEPT
 SET �controls_off 0
 SET �reflection_mode �saved_reflection
 COLLISION ON
 BEHAVIOR UNSTACK
 ACCEPT
}

ON CONTROLS_OFF
{
 IF ( �enemy == 0 ) ACCEPT
 IF (�frozen == 1) ACCEPT
 SET �controls_off 1
 SET �saved_reflection �reflection_mode
 SET �reflection_mode 0
 COLLISION OFF
 BEHAVIOR STACK
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
 ACCEPT
}

//*******************************************************

ON CHEAT_DIE
{
 SET �friend "NONE"
 FORCEDEATH SELF
 ACCEPT
}

//*******************************************************
ON COLLISION_ERROR
{
 IF ( �controls_off != 0 ) ACCEPT
 herosay -d "collision_error"
 COLLISION OFF
 TIMERcol 1 1 COLLISION ON
 ACCEPT
}

//*******************************************************
ON COLLIDE_NPC
{
 IF ( �controls_off != 0 ) ACCEPT
 IF (�fighting_mode == 2) ACCEPT
 IF (^SENDER != PLAYER ) ACCEPT
 if (�collided_player == 1) ACCEPT
  IF ( �enemy == 1 ) {
  IF (^PLAYER_SKILL_STEALTH < 80) GOTO PLAYER_DETECTED
  ACCEPT
  }
 IF ( �frozen == 1 ) ACCEPT
 IF ( �main_behavior_stacked > 0 ) ACCEPT
 GOSUB SAVE_BEHAVIOR
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
//  TIMERcolplayer 1 1 GOSUB RESTORE_BEHAVIOR
 TIMERcolplayer 0 1 goto checkplayerdist
 set �collided_player 1
 SET_EVENT COLLIDE_NPC OFF
 HERO_SAY -d "collide npc OFF"
 ACCEPT
}

>>checkplayerdist
 if (�fighting != 0) {
  TIMERcolplayer OFF  
  UNSET �collided_player
  SET_EVENT COLLIDE_NPC ON
  HERO_SAY -d "collide npc ON"
  accept
 }
 if (^DIST_PLAYER < 220) accept 
 TIMERcolplayer OFF
 UNSET �collided_player
 GOSUB RESTORE_BEHAVIOR
 SET_EVENT COLLIDE_NPC ON
 HERO_SAY -d "collide npc ON"
ACCEPT


//*******************************************************
ON COLLIDE_DOOR 
{
 SENDEVENT DOORLOCKED SELF ""
// GOSUB SAVE_BEHAVIOR
// BEHAVIOR WANDER_AROUND 300
// SET_TARGET NONE
// TIMERendcollidedoor 1 15 GOSUB RESTORE_BEHAVIOR
 ACCEPT
}


//*******************************************************
ON ATTACK_PLAYER 
{
 IF ( �controls_off != 0 ) ACCEPT
 SET �spoted 1
 GOTO ATTACK_PLAYER
 ACCEPT
}

//*******************************************************
ON LOOK_FOR 
{
 IF ( �controls_off != 0 ) ACCEPT
 GOTO LOOK_FOR
 ACCEPT
}

//*******************************************************
ON DETECTPLAYER 
{
>>PLAYER_DETECTED
 IF (�player_in_sight == 1) ACCEPT
 IF ( �controls_off != 0 ) ACCEPT
 IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT
 IF (�confused == 1) ACCEPT
 SET �player_in_sight 1

 SET_NPC_STAT BACKSTAB 0
 IF (�fighting_mode == 2) ACCEPT
 IF (�enemy == 0) ACCEPT
 IF (�sleeping == 1) ACCEPT

 SET_EVENT HEAR OFF

 GOTO ATTACK_PLAYER

 ACCEPT
}

//*******************************************************
ON HEAR 
{
 IF ( �controls_off != 0 ) ACCEPT
 IF (�confused == 1) ACCEPT
 IF (�sleeping == 1) 
 { 
  SET �sleeping 0
  ACCEPT
 }
 IF (�enemy == 0) ACCEPT
 IF (�player_in_sight == 1) ACCEPT
 IF (^SENDER == �last_heard) {
  SET #TMP ^GAMESECONDS
  DEC #TMP �snd_tim
  IF (#TMP < 2) ACCEPT // same sound source won't be heard during 2 seconds
 }
 IF (�fighting_mode >= 1) GOTO PLAYER_DETECTED // fighting
  IF (�hail != "none") {
  RANDOM 50 {
   PLAY -p ~�hail~
  }
 }
 SET �snd_tim ^GAMESECONDS
 GOSUB SAVE_BEHAVIOR
 BEHAVIOR MOVE_TO
 SET �last_heard ^SENDER
 SETTARGET -n ~�last_heard~
 SETMOVEMODE WALK
 ACCEPT
}

//*******************************************************
ON UNDETECTPLAYER 
{
 IF ( �controls_off != 0 ) ACCEPT
 SET �player_in_sight 0
 IF (�enemy == 0) ACCEPT
 IF (�fighting_mode != 1) ACCEPT
 IF (�looking_for != 1) 
 {
  IF (^TARGET == PLAYER) 
  {
   SET �looking_for 1
   TIMERlookfor 1 4 GOTO LOOK_FOR
   ACCEPT
  }
  ACCEPT
 }
 ACCEPT
}

//*******************************************************
ON STRIKE 
{
 RANDOM 50 ACCEPT
 IF ( �strike != "none" ) { 
  SET �tmp ^RND_~�sound_amount~
  SET �sound ~�tmp~
  INC �sound 1
  IF (�sound >= �sound_amount) SET �sound 1
  PLAY -p ~�strike~~�sound~
  }
 ACCEPT
}

//*******************************************************
>>ATTACK_PLAYER
 IF ( �controls_off != 0 ) ACCEPT
 SET �ignorefailure 0
 IF (^LIFE < �cowardice) GOTO FLEE	// low life -> flee
 IF (�fighting_mode == 1) ACCEPT	// already fighting !
 IF (�fighting_mode == 2) ACCEPT    // fleeing
 IF (�tactic == 2) GOTO FLEE		// rabbit -> flee
 IF (�fighting_mode == 3) {
  IF (^LIFE < �cowardice) GOTO FLEE		// end of flee -> flee again
 }
 IF ( �spoted == 0 )
 { 
  SET �spoted 1
  IF ( �hail != "none" ) PLAY -p ~�hail~
 }
 TIMER kill_local
 SET_NPC_STAT BACKSTAB 0
 SET �reflection_mode 2
 GOSUB SAVE_BEHAVIOR
 WEAPON ON
 SET �fighting_mode 1
 SET_EVENT HEAR OFF
 SET �enemy 1
 BEHAVIOR -f MOVE_TO
 SETTARGET PLAYER
 SETMOVEMODE RUN
 ACCEPT

//*******************************************************
>>LOOK_FOR
 IF ( �controls_off != 0 ) ACCEPT
 TIMERlookfor OFF
 IF (�confused == 1) GOTO LOOK_FOR_SUITE
 IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
 IF (^DIST_PLAYER < 500) GOTO PLAYER_DETECTED
>>LOOK_FOR_SUITE
 IF ( �controls_off != 0 ) ACCEPT
 IF (�looking_for == 2) GOTO PLAYER_DETECTED //in case NPC already looking for
 IF ( �fighting_mode > 1 ) ACCEPT
 BEHAVIOR LOOK_FOR 500
 SETTARGET PLAYER
 SETMOVEMODE WALK
 SET �looking_for 2
 SET �fighting_mode 0
 SET_EVENT HEAR ON
 SET �reflection_mode 3
 TIMERhome 1 18 GOTO GO_HOME
 ACCEPT


//*******************************************************
ON REACHEDTARGET 
{
 IF ( �controls_off != 0 ) ACCEPT
 IF (^TARGET == PLAYER) {
  IF ( �fighting_mode == 2) ACCEPT
  IF (�confused == 1) ACCEPT
  IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT
   ACCEPT
  }

  GOTO PLAYER_DETECTED
 }
 IF (^TARGET == �last_heard) 
 { 
  SET �last_heard "NOHEAR"
  GOTO GO_HOME
  ACCEPT
 }
 ACCEPT
}

//*******************************************************
ON PATHFINDER_FAILURE {
>>FAILED_PATHFIND
 HEROSAY -d "pathfail"
 IF (�ignorefailure == 1) ACCEPT
 SET �ignorefailure 1
 BEHAVIOR NONE
 SETTARGET NONE
 SET �fighting_mode 0
 SET �reflection_mode 0
 TIMERpathfail 1 3 SET �ignorefailure 0 GOTO GO_HOME
 ACCEPT
}

//*******************************************************
ON FLEE_END 
{
 IF ( �controls_off != 0 ) ACCEPT
 IF (�fighting_mode == 2) 
 {
  SET �fighting_mode 3
  SET_EVENT HEAR ON
  SET_EVENT COLLIDE_NPC ON
  DEC �cowardice 2
  IF ( �cowardice < 3 ) SET �cowardice 0
  IF (�player_in_sight == 1) GOTO ATTACK_PLAYER
  BEHAVIOR FRIENDLY
  SETTARGET PLAYER
 }
 ACCEPT
}

//*******************************************************
ON AGGRESSION
{
herosay -d "on agression"
// GOTO OUCHSUITE
 GOTO OUCH_START
 ACCEPT
}

//*******************************************************
ON OUCH 
{
>>OUCH_START
 // visualy react to ouch -------------
 IF (^#PARAM1 < �pain) 
 {
  IF (^PLAYERCASTING == 0) FORCEANIM HIT_SHORT
 }
 ELSE
 {
  SET #TMP ^GAMESECONDS
  DEC #TMP �ouch_tim
  IF (#TMP > 4) {
   FORCEANIM HIT
   SET �ouch_tim ^GAMESECONDS
  }
  SET &TMP �pain
  MUL &TMP 3
  IF (^#PARAM1 >= &TMP) 
  { // big ouch : it hurts !
   IF (�ouch_strong != "none") PLAY -p ~�ouch_strong~
  }
  ELSE
  {
   SET &TMP �pain
   MUL &TMP 2
   IF (^#PARAM1 >= &TMP) 
   { // medium
    IF (�ouch_medium != "none") PLAY -p ~�ouch_medium~
   }
   ELSE
   { // normal
    IF (�ouch != "none") PLAY -p ~�ouch~
   }
  }
 }

>>OUCHSUITE
 IF ( �controls_off != 0 ) ACCEPT
 // react to agression -----------------------------------------
 IF (^SENDER == "PLAYER") 
 {
  SET_EVENT AGGRESSION OFF
  SET �spoted 1 // OK, I've seen you !
  SET �enemy 1 // on passe en mode enemy
  IF (�fighting_mode == 2) ACCEPT
  IF (�tactic == 2) GOTO FLEE // coward
  IF (^LIFE < �cowardice) 
  { // low life -> flee
>>FLEE
   IF (�fighting_mode == 2) ACCEPT
   SET �fighting_mode 2  // Fleeing
   TIMER kill_local
   SET_EVENT HEAR OFF
   SET_EVENT COLLIDE_NPC OFF
//   GOSUB SAVE_BEHAVIOR
  // SET #TMP ~^DIST_PLAYER~
  // INC #TMP 1000
  // IF (#TMP > 2500) SET #TMP 2500
  // BEHAVIOR FLEE #TMP
   BEHAVIOR FLEE 1000
   SETTARGET PLAYER
   SETMOVEMODE RUN
   SET �reflection_mode 0
   TIMERhome 1 30 GOTO GO_HOME
   ACCEPT
  }
  IF (�fighting_mode == 1) ACCEPT
  IF (�player_in_sight == 0) 
  { // player wasn't in sight -> search him
   GOTO LOOK_FOR //in case the player hits from a distance
  }
  IF (�fighting_mode == 0) GOTO ATTACK_PLAYER
 }
 ACCEPT
}

//********************************
ON TARGET_DEATH 
{
 IF (^SENDER == "PLAYER") 
 {
  SET �enemy 0
  SET �fighting_mode 0
  IF (^$PARAM1 == ^ME ) 
  {
   PLAYANIM -e GRUNT GOTO GO_HOME
   ACCEPT
  }
  GOTO GO_HOME
 }
 IF ( �summon_attacking == 1 ) GOTO SUMMONSUITE
// this is for summoned monsters (undeads and demons)
 ACCEPT
}

//********************************
>>GO_HOME
 IF ( �controls_off != 0 ) ACCEPT
 IF (�fighting_mode == 1) ACCEPT
  IF (�fighting_mode >= 2) {
  SET �fighting_mode 3
  DIV �cowardice 2
  IF ( �cowardice < 3 ) SET �cowardice 0 // next time attack and fight to death !
  // flee again si le joueur est dans le coin
  IF (^DIST_PLAYER < 500) GOTO ATTACK_PLAYER
 }
 SET_EVENT AGGRESSION ON
 SET_EVENT HEAR ON
 SET �fighting_mode 0
 SET �reflection_mode 0
 SET �spoted 0
 IF (�looking_for == 2) 
 {
  SET �looking_for 0
  SET �reflection_mode 1
 }
 WEAPON OFF 
 GOSUB RESTORE_BEHAVIOR
 SET_NPC_STAT BACKSTAB 1
 ACCEPT

//********************************
ON MISC_REFLECTION 
{
 IF (�reflection_mode == 0) ACCEPT
 IF ( #SHUT_UP == 1 ) ACCEPT
 SET #TMP ~^RND_6~
 INC #TMP 6
 TIMERmisc_reflection -i 0 ~#TMP~ SENDEVENT MISC_REFLECTION SELF ""
 RANDOM 30 ACCEPT
 IF (�reflection_mode == 1) 
 {
 // normal
  SET $TMP �misc
  RANDOM 50 ACCEPT
>>MISC_REFLECTION2
  IF ($TMP == "none") ACCEPT
  SET �tmp ^RND_~�sound_amount~
  SET �sound ~�tmp~
  INC �sound 1
  IF (�sound > �sound_amount) SET �sound 1
  IF (�last_misc == �sound) {
   INC �sound 1
   IF (�sound > �sound_amount) SET �sound 1
  }
  SET �last_misc �sound
  PLAY -p ~$TMP~~�sound~
  ACCEPT
 }
 IF (�reflection_mode == 2) 
 {
 // fighting
  SET $TMP �threat
  GOTO MISC_REFLECTION2
  ACCEPT
 }
 IF (�reflection_mode == 3) 
 {
 // searching
  SET $TMP �threat
  GOTO MISC_REFLECTION2
  ACCEPT
 }
ACCEPT
}

ON DOORLOCKED
{
 TIMERcloseit OFF
 IF (�door_locked_attempt < 2)
 {
  INC �door_locked_attempt 1
  ACCEPT
 }
 SET �door_locked_attempt 0
 GOTO FAILED_PATHFIND
 ACCEPT
}

// -------------------------------------------------------------------------------
// MAIN ANIMAL INCLUDE END -------------------------------------------------------
// -------------------------------------------------------------------------------


//#


//********************************

ON DIE {
 IF (�iserbius == 1) {
   SENDEVENT CUSTOM HUMAN_BASE_0100 "FREE_ALIA"
   SENDEVENT CUSTOM METEOR_AKBAA_0001 "DEAD"
   SENDEVENT -g DEMON_DOOR OPEN ""
   AMBIANCE KILL
  }
 IF (�controlled == 1) SET #PLAYER_CONTROLLING 0 SET �controlled 0 //specific
 //TIMERdelete 1 2 DESTROY SELF //specific
 SET_INTERACTIVITY NONE
//#die_animal
 SETEVENT CHAT OFF
 TIMERmisc_reflection OFF
 FORCEANIM DIE
 IF (�dying != "none") PLAY -p ~�dying~
 COLLISION OFF
 SETDETECT -1
 SET �totaldead 1


//#
// SENDEVENT CUSTOM ~�caster~ "SON_DEAD" 
// SET �caster "NONE"
 ACCEPT
}

ON ISERBIUS {
 HEROSAY -d "Demon a recu le message"
 SET �iserbius 1
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}