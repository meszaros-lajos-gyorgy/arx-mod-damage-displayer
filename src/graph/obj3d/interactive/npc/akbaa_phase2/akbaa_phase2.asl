ON INIT {
// OBJECT_HIDE SELF ON
 SET £tentacle "AKBAA_TENTACLE_0002"
 SET £demon "DEMON_0003"
 SETDETECT 40
//#init_animal
// ---------------------------------------------------------------------------------
// INIT_ANIMAL INCLUDE START -------------------------------------------------------
// ---------------------------------------------------------------------------------
 SET_EVENT HEAR OFF
 SET §sleeping 0                //meynier... tu dors...

 SET §main_behavior_stacked 0   //in order to restore the main behavior after a look_for or a help
 SET §reflection_mode 1         // 0: nothing, 1: normal, 2: threat, 3: search 
 SET §player_in_sight 0         //used for various reasons, =1 indicates that the NPC currently sees he player.

 SET §looking_for 0             //1 = the NPC is about to look for the player 2=looking for him 
 SET §fighting_mode 0           //0 = NO   1 = Fighting    2 = Fleeing
 SET §frozen 0                  //to stop looping anims if ATTACK_PLAYER called
 SET §spoted 0                  //defines if the NPC has already said "I'll get you" to the player

 SET £tmp "none"              //For animals only
 SET §sound 0                 //For animals only 
 SET §ouch_tim 0   
 SET £last_heard "NOHEAR"

 SET_NPC_STAT BACKSTAB 1

 SET £init_marker "NONE"	// go back to this marker if combat finished

 SET §door_locked_attempt 0	// number of attempts of passing throw a locked door
 SETDETECT 40

 INVENTORY SKIN "ingame_inventory_corpse"
// ---------------------------------------------------------------------------------
// INIT_ANIMAL INCLUDE END ---------------------------------------------------------
// ---------------------------------------------------------------------------------

//#
 SET §demon_attack 0
 SET §tentacle_attack 0
 PHYSICAL RADIUS 40
 SET_NPC_STAT RESISTMAGIC 50
 SET_NPC_STAT RESISTPOISON 200
 SET_NPC_STAT RESISTFIRE 80
 SET_NPC_STAT armor_class 30
 SET_NPC_STAT absorb 20
 SET_NPC_STAT damages 70
 SET_NPC_STAT tohit 50
 SET_NPC_STAT aimtime 1000
 SET_NPC_STAT life 1200
 SET_NPC_STAT REACH 500
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_bare
 SET_BLOOD 0.9 0.1 0.1
 SETIRCOLOR 0.8 0.0 0.0
 SET §enemy 0                   //defines if the NPC is enemy to the player at the moment
 SET §tactic 0                  //0 = normal    1 = sneak   2 = rabit  3 = caster
 SET §current_tactic §tactic    //** used to restore previous tactic after a repel undead
 SET §cowardice 0   
 SET §pain 50                
 SET §low_life_alert 10
 SET §panicmode 1
 SET §sound_amount 3          //For animals only
 LOADANIM TALK_NEUTRAL               "human_talk_neutral_headonly"
 LOADANIM TALK_ANGRY                 "human_talk_angry_headonly"
 LOADANIM TALK_HAPPY                 "human_talk_happy_headonly"
 loadanim BARE_READY                 "Iserbius_phase2_fight_attack_start"
 loadanim BARE_UNREADY               "Iserbius_phase2_fight_attack_strike"
 loadanim BARE_WAIT                  "Iserbius_phase2_fight_wait_toponly"
 loadanim BARE_STRIKE_LEFT_START     "Iserbius_phase2_fight_attack_start" 
 loadanim BARE_STRIKE_LEFT_CYCLE     "Iserbius_phase2_fight_attack_cycle"
 loadanim BARE_STRIKE_LEFT           "Iserbius_phase2_fight_attack_strike"
 loadanim BARE_STRIKE_RIGHT_START    "Iserbius_phase2_fight_attack_start"
 loadanim BARE_STRIKE_RIGHT_CYCLE    "Iserbius_phase2_fight_attack_cycle"
 loadanim BARE_STRIKE_RIGHT          "Iserbius_phase2_fight_attack_strike"
 loadanim BARE_STRIKE_TOP_START      "Iserbius_phase2_fight_attack_start"
 loadanim BARE_STRIKE_TOP_CYCLE      "Iserbius_phase2_fight_attack_cycle"
 loadanim BARE_STRIKE_TOP            "Iserbius_phase2_fight_attack_strike"
 loadanim BARE_STRIKE_BOTTOM_START   "Iserbius_phase2_fight_attack_start"
 loadanim BARE_STRIKE_BOTTOM_CYCLE   "Iserbius_phase2_fight_attack_cycle"
 loadanim BARE_STRIKE_BOTTOM         "Iserbius_phase2_fight_attack_strike"

// LOADANIM GRUNT                      "demon_grunt"  //*****************  NEW
// LOADANIM SNEAK_WALK                 "Iserbius_phase2_walk"
 loadanim FIGHT_WALK_FORWARD         "Iserbius_phase2_fight_walk"
 loadanim FIGHT_WALK_BACKWARD        "Iserbius_phase2_fight_walkback"
 loadanim FIGHT_STRAFE_RIGHT         "Iserbius_phase2_fight_strafe_right"
 loadanim FIGHT_STRAFE_LEFT          "Iserbius_phase2_fight_strafe_left"
 LOADANIM WALK                       "Iserbius_phase2_walk"
 LOADANIM RUN                        "Iserbius_phase2_run"
 LOADANIM WAIT                       "Iserbius_phase2_wait"
 loadanim FIGHT_WAIT                 "Iserbius_phase2_fight_wait"
 LOADANIM HIT                        "Iserbius_phase2_fight_gethit"
 LOADANIM HIT_SHORT                  "Iserbius_phase2_hit_short"
 LOADANIM DIE                        "Iserbius_phase2_fight_die"
 LOADANIM ACTION1                    "Iserbius_phase2_fight_plonge_in"
 LOADANIM ACTION2                    "Iserbius_phase2_fight_plonge_cycle"
 LOADANIM ACTION3                    "Iserbius_phase2_fight_plonge_out"
 SET §enemy 0
 SET £hail "none"
 SET £strike "akbaa_strike"
 SET £misc "none"
 SET £threat "akbaa_hail"
 SET £dying "akbaa_die"
 SET £ouch "akbaa_hit"
 SET £ouch_medium "akbaa_hit"
 SET £ouch_strong "akbaa_hit"
 SET £type "Akbaa"
 ACCEPT
}

ON INITEND {
 IF (§sound_amount > 0) TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
 TIMERspecialattack 0 2 GOTO SPECIAL_ATTACK
 BEHAVIOR NONE
 SETTARGET NONE
 IF (§sound_amount != 0) INC §sound_amount 1
 IF (§enemy == 1) SET_EVENT HEAR ON
 ACCEPT
}

ON COLLIDE_FIELD {
  IF (§spell_ready == 0) ACCEPT
  SPELLCAST -smf 10 DISPELL_FIELD PLAYER
  herosay -d "Dispell field"
  GOTO SPELL_CASTED
 ACCEPT
}

//***************SPECIFIC TO AKBAA
>>SPECIAL_ATTACK
 IF ( §fighting_mode != 1 ) ACCEPT
herosay -d "special attack"
 IF ( §tentacle_attack == 1 ) ACCEPT
 SET #TMP ~^DIST_PLAYER~
 IF ( #TMP < 400 ) {
  RANDOM 50
  {
   SPELLCAST -smf 10 LIGHTNING_STRIKE PLAYER
  }
  ACCEPT
 }
 SET §tmp ~^RND_3~
 IF ( §tmp == 0 )
 {
  IF ( ^PLAYER_ZONE == "ZONETENTACLE1" ) GOTO TENTACLE_ATTACK
  IF ( ^PLAYER_ZONE == "ZONETENTACLE2" ) GOTO TENTACLE_ATTACK
  IF ( ^PLAYER_ZONE == "ZONETENTACLE3" ) GOTO TENTACLE_ATTACK
  GOTO DEMON_ATTACK
>>TENTACLE_ATTACK
  SET §tentacle_attack 1
  PLAYANIM -e ACTION1 PLAYANIM -L ACTION2
  HALO -ocs 0.137 0.403 0.372 100
  SET_NPC_STAT armor_class 5
  HEROSAY -d "TENTACULE DEBILOIDE"
  SENDEVENT CUSTOM ~£tentacle~ "ATTACK"
  BEHAVIOR FRIENDLY
  SETTARGET PLAYER
  ACCEPT
 }
 IF ( §tmp == 1 )
 {
>>DEMON_ATTACK
  IF ( §demon_attack == 0 )
  {
   IF ( #TMP > 700) 
   {
    SET §demon_attack 1
    WORLDFADE OUT 500 1 1 1
    TIMERfadde 1 1 WORLDFADE IN 500
    HEROSAY -d "SUMMON SON OF AKBAA"
    SENDEVENT CUSTOM ~£demon~ "AKBAA_ATTACK"
//    SPELLCAST -f 9 SUMMON_CREATURE SELF
   }
  }
  ACCEPT
 }
 IF ( #TMP > 500 )
 {
 RANDOM 50
  {
   HEROSAY -d "ATTRACT PLAYER...."
   //ATTRACT_PLAYER
   ATTRACTOR SELF 16 1500
   SPELLCAST -smfd 6500 10 LIFE_DRAIN PLAYER
   TIMERattract 1 7 ATTRACTOR SELF OFF
  }
 }
ACCEPT


ON CUSTOM {
 IF (^$PARAM1 == "SON_DEAD") 
 {
  herosay -d "demon dead"
  TIMERsummagain 1 20 SET §demon_attack 0
  ACCEPT
 }
 IF (^$PARAM1 == "TENTACLE_ATTACKED") 
 { 
  SET §tentacle_attack 0
  PLAYANIM -e ACTION3 HALO -f
  HEROSAY -d "ATTACK FINISHED"
  BEHAVIOR -f MOVE_TO
  SETTARGET PLAYER
  SET_NPC_STAT armor_class 30 
  ACCEPT
 }
 IF (^$PARAM1 == "CHECK_LIFE")  
 {
  TIMERlife 0 1 GOTO CHECK_LIFE
  ACCEPT
 }
 ACCEPT
}


//***************END SPECIFIC


//START*******************************************************

ON CHAT {
 IF (§enemy == 1) SENDEVENT DETECTPLAYER SELF ""
 ACCEPT
}

//#behavior_animal

// ---------------------------------------------------------------------------------
// BEHAVIOR INCLUDE START ----------------------------------------------------------
// ---------------------------------------------------------------------------------
>>SAVE_BEHAVIOR
 TIMERcolplayer OFF // to avoid TIMERcolplayer to restore the behavior 1 sec later
 IF (§main_behavior_stacked == 0) 
 {
  IF (§frozen == 1)
  { // frozen anim -> wake up !
    SET §frozen 0
    PLAYANIM NONE
    PLAYANIM -2 NONE
    PHYSICAL ON
    COLLISION ON
    BEHAVIOR FRIENDLY
    SETTARGET PLAYER
  }
  SET §main_behavior_stacked 1
  HEROSAY -d "STACK"
  BEHAVIOR STACK
 }
RETURN

>>RESTORE_BEHAVIOR
 IF (§main_behavior_stacked == 1) 
 {
  HEROSAY -d "UNSTACK"
  BEHAVIOR UNSTACK
  SET §main_behavior_stacked 0
  RETURN
 }
 IF (£init_marker != "NONE")
  { 
   BEHAVIOR MOVE_TO
   SETTARGET -a ~£init_marker~
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
 IF (§totaldead == 0) {
  IF (§fighting_mode > 0) {
   IF (£init_marker != "NONE") TELEPORT ~£init_marker~
   IF (£init_marker == "NONE") TELEPORT -i
 //  WEAPON OFF
   SET §fighting_mode 0
   SET §player_in_sight 0
   SET §reflection_mode 0
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
 IF (§frozen == 1) ACCEPT
 IF ( §controls_off == 0 ) ACCEPT
 SET §controls_off 0
 SET §reflection_mode §saved_reflection
 COLLISION ON
 BEHAVIOR UNSTACK
 ACCEPT
}

ON CONTROLS_OFF
{
 IF ( §enemy == 0 ) ACCEPT
 IF (§frozen == 1) ACCEPT
 SET §controls_off 1
 SET §saved_reflection §reflection_mode
 SET §reflection_mode 0
 COLLISION OFF
 BEHAVIOR STACK
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
 ACCEPT
}

//*******************************************************

ON CHEAT_DIE
{
 SET £friend "NONE"
 FORCEDEATH SELF
 ACCEPT
}

//*******************************************************
ON COLLISION_ERROR
{
 IF ( §controls_off != 0 ) ACCEPT
 herosay -d "collision_error"
 COLLISION OFF
 TIMERcol 1 1 COLLISION ON
 ACCEPT
}

//*******************************************************
ON COLLIDE_NPC
{
 IF ( §controls_off != 0 ) ACCEPT
 IF (§fighting_mode == 2) ACCEPT
 IF (^SENDER != PLAYER ) ACCEPT
 if (§collided_player == 1) ACCEPT
  IF ( §enemy == 1 ) {
  IF (^PLAYER_SKILL_STEALTH < 80) GOTO PLAYER_DETECTED
  ACCEPT
  }
 IF ( §frozen == 1 ) ACCEPT
 IF ( §main_behavior_stacked > 0 ) ACCEPT
 GOSUB SAVE_BEHAVIOR
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
//  TIMERcolplayer 1 1 GOSUB RESTORE_BEHAVIOR
 TIMERcolplayer 0 1 goto checkplayerdist
 set §collided_player 1
 SET_EVENT COLLIDE_NPC OFF
 HERO_SAY -d "collide npc OFF"
 ACCEPT
}

>>checkplayerdist
 if (§fighting != 0) {
  TIMERcolplayer OFF  
  UNSET §collided_player
  SET_EVENT COLLIDE_NPC ON
  HERO_SAY -d "collide npc ON"
  accept
 }
 if (^DIST_PLAYER < 220) accept 
 TIMERcolplayer OFF
 UNSET §collided_player
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
 IF ( §controls_off != 0 ) ACCEPT
 SET §spoted 1
 GOTO ATTACK_PLAYER
 ACCEPT
}

//*******************************************************
ON LOOK_FOR 
{
 IF ( §controls_off != 0 ) ACCEPT
 GOTO LOOK_FOR
 ACCEPT
}

//*******************************************************
ON DETECTPLAYER 
{
>>PLAYER_DETECTED
 IF (§player_in_sight == 1) ACCEPT
 IF ( §controls_off != 0 ) ACCEPT
 IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT
 IF (§confused == 1) ACCEPT
 SET §player_in_sight 1

 SET_NPC_STAT BACKSTAB 0
 IF (§fighting_mode == 2) ACCEPT
 IF (§enemy == 0) ACCEPT
 IF (§sleeping == 1) ACCEPT

 SET_EVENT HEAR OFF

 GOTO ATTACK_PLAYER

 ACCEPT
}

//*******************************************************
ON HEAR 
{
 IF ( §controls_off != 0 ) ACCEPT
 IF (§confused == 1) ACCEPT
 IF (§sleeping == 1) 
 { 
  SET §sleeping 0
  ACCEPT
 }
 IF (§enemy == 0) ACCEPT
 IF (§player_in_sight == 1) ACCEPT
 IF (^SENDER == £last_heard) {
  SET #TMP ^GAMESECONDS
  DEC #TMP §snd_tim
  IF (#TMP < 2) ACCEPT // same sound source won't be heard during 2 seconds
 }
 IF (§fighting_mode >= 1) GOTO PLAYER_DETECTED // fighting
  IF (£hail != "none") {
  RANDOM 50 {
   PLAY -p ~£hail~
  }
 }
 SET §snd_tim ^GAMESECONDS
 GOSUB SAVE_BEHAVIOR
 BEHAVIOR MOVE_TO
 SET £last_heard ^SENDER
 SETTARGET -n ~£last_heard~
 SETMOVEMODE WALK
 ACCEPT
}

//*******************************************************
ON UNDETECTPLAYER 
{
 IF ( §controls_off != 0 ) ACCEPT
 SET §player_in_sight 0
 IF (§enemy == 0) ACCEPT
 IF (§fighting_mode != 1) ACCEPT
 IF (§looking_for != 1) 
 {
  IF (^TARGET == PLAYER) 
  {
   SET §looking_for 1
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
 IF ( £strike != "none" ) { 
  SET £tmp ^RND_~§sound_amount~
  SET §sound ~£tmp~
  INC §sound 1
  IF (§sound >= §sound_amount) SET §sound 1
  PLAY -p ~£strike~~§sound~
  }
 ACCEPT
}

//*******************************************************
>>ATTACK_PLAYER
 IF ( §controls_off != 0 ) ACCEPT
 SET §ignorefailure 0
 IF (^LIFE < §cowardice) GOTO FLEE	// low life -> flee
 IF (§fighting_mode == 1) ACCEPT	// already fighting !
 IF (§fighting_mode == 2) ACCEPT    // fleeing
 IF (§tactic == 2) GOTO FLEE		// rabbit -> flee
 IF (§fighting_mode == 3) {
  IF (^LIFE < §cowardice) GOTO FLEE		// end of flee -> flee again
 }
 IF ( §spoted == 0 )
 { 
  SET §spoted 1
  IF ( £hail != "none" ) PLAY -p ~£hail~
 }
 TIMER kill_local
 SET_NPC_STAT BACKSTAB 0
 SET §reflection_mode 2
 GOSUB SAVE_BEHAVIOR
 WEAPON ON
 SET §fighting_mode 1
 SET_EVENT HEAR OFF
 SET §enemy 1
 BEHAVIOR -f MOVE_TO
 SETTARGET PLAYER
 SETMOVEMODE RUN
 ACCEPT

//*******************************************************
>>LOOK_FOR
 IF ( §controls_off != 0 ) ACCEPT
 TIMERlookfor OFF
 IF (§confused == 1) GOTO LOOK_FOR_SUITE
 IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
 IF (^DIST_PLAYER < 500) GOTO PLAYER_DETECTED
>>LOOK_FOR_SUITE
 IF ( §controls_off != 0 ) ACCEPT
 IF (§looking_for == 2) GOTO PLAYER_DETECTED //in case NPC already looking for
 IF ( §fighting_mode > 1 ) ACCEPT
 BEHAVIOR LOOK_FOR 500
 SETTARGET PLAYER
 SETMOVEMODE WALK
 SET §looking_for 2
 SET §fighting_mode 0
 SET_EVENT HEAR ON
 SET §reflection_mode 3
 TIMERhome 1 18 GOTO GO_HOME
 ACCEPT


//*******************************************************
ON REACHEDTARGET 
{
 IF ( §controls_off != 0 ) ACCEPT
 IF (^TARGET == PLAYER) {
  IF ( §fighting_mode == 2) ACCEPT
  IF (§confused == 1) ACCEPT
  IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT
   ACCEPT
  }

  GOTO PLAYER_DETECTED
 }
 IF (^TARGET == £last_heard) 
 { 
  SET £last_heard "NOHEAR"
  GOTO GO_HOME
  ACCEPT
 }
 ACCEPT
}

//*******************************************************
ON PATHFINDER_FAILURE {
>>FAILED_PATHFIND
 HEROSAY -d "pathfail"
 IF (§ignorefailure == 1) ACCEPT
 SET §ignorefailure 1
 BEHAVIOR NONE
 SETTARGET NONE
 SET §fighting_mode 0
 SET §reflection_mode 0
 TIMERpathfail 1 3 SET §ignorefailure 0 GOTO GO_HOME
 ACCEPT
}

//*******************************************************
ON FLEE_END 
{
 IF ( §controls_off != 0 ) ACCEPT
 IF (§fighting_mode == 2) 
 {
  SET §fighting_mode 3
  SET_EVENT HEAR ON
  SET_EVENT COLLIDE_NPC ON
  DEC §cowardice 2
  IF ( §cowardice < 3 ) SET §cowardice 0
  IF (§player_in_sight == 1) GOTO ATTACK_PLAYER
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
 IF (^#PARAM1 < §pain) 
 {
  IF (^PLAYERCASTING == 0) FORCEANIM HIT_SHORT
 }
 ELSE
 {
  SET #TMP ^GAMESECONDS
  DEC #TMP §ouch_tim
  IF (#TMP > 4) {
   FORCEANIM HIT
   SET §ouch_tim ^GAMESECONDS
  }
  SET &TMP §pain
  MUL &TMP 3
  IF (^#PARAM1 >= &TMP) 
  { // big ouch : it hurts !
   IF (£ouch_strong != "none") PLAY -p ~£ouch_strong~
  }
  ELSE
  {
   SET &TMP §pain
   MUL &TMP 2
   IF (^#PARAM1 >= &TMP) 
   { // medium
    IF (£ouch_medium != "none") PLAY -p ~£ouch_medium~
   }
   ELSE
   { // normal
    IF (£ouch != "none") PLAY -p ~£ouch~
   }
  }
 }

>>OUCHSUITE
 IF ( §controls_off != 0 ) ACCEPT
 // react to agression -----------------------------------------
 IF (^SENDER == "PLAYER") 
 {
  SET_EVENT AGGRESSION OFF
  SET §spoted 1 // OK, I've seen you !
  SET §enemy 1 // on passe en mode enemy
  IF (§fighting_mode == 2) ACCEPT
  IF (§tactic == 2) GOTO FLEE // coward
  IF (^LIFE < §cowardice) 
  { // low life -> flee
>>FLEE
   IF (§fighting_mode == 2) ACCEPT
   SET §fighting_mode 2  // Fleeing
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
   SET §reflection_mode 0
   TIMERhome 1 30 GOTO GO_HOME
   ACCEPT
  }
  IF (§fighting_mode == 1) ACCEPT
  IF (§player_in_sight == 0) 
  { // player wasn't in sight -> search him
   GOTO LOOK_FOR //in case the player hits from a distance
  }
  IF (§fighting_mode == 0) GOTO ATTACK_PLAYER
 }
 ACCEPT
}

//********************************
ON TARGET_DEATH 
{
 IF (^SENDER == "PLAYER") 
 {
  SET §enemy 0
  SET §fighting_mode 0
  IF (^$PARAM1 == ^ME ) 
  {
   PLAYANIM -e GRUNT GOTO GO_HOME
   ACCEPT
  }
  GOTO GO_HOME
 }
 IF ( §summon_attacking == 1 ) GOTO SUMMONSUITE
// this is for summoned monsters (undeads and demons)
 ACCEPT
}

//********************************
>>GO_HOME
 IF ( §controls_off != 0 ) ACCEPT
 IF (§fighting_mode == 1) ACCEPT
  IF (§fighting_mode >= 2) {
  SET §fighting_mode 3
  DIV §cowardice 2
  IF ( §cowardice < 3 ) SET §cowardice 0 // next time attack and fight to death !
  // flee again si le joueur est dans le coin
  IF (^DIST_PLAYER < 500) GOTO ATTACK_PLAYER
 }
 SET_EVENT AGGRESSION ON
 SET_EVENT HEAR ON
 SET §fighting_mode 0
 SET §reflection_mode 0
 SET §spoted 0
 IF (§looking_for == 2) 
 {
  SET §looking_for 0
  SET §reflection_mode 1
 }
 WEAPON OFF 
 GOSUB RESTORE_BEHAVIOR
 SET_NPC_STAT BACKSTAB 1
 ACCEPT

//********************************
ON MISC_REFLECTION 
{
 IF (§reflection_mode == 0) ACCEPT
 IF ( #SHUT_UP == 1 ) ACCEPT
 SET #TMP ~^RND_6~
 INC #TMP 6
 TIMERmisc_reflection -i 0 ~#TMP~ SENDEVENT MISC_REFLECTION SELF ""
 RANDOM 30 ACCEPT
 IF (§reflection_mode == 1) 
 {
 // normal
  SET $TMP £misc
  RANDOM 50 ACCEPT
>>MISC_REFLECTION2
  IF ($TMP == "none") ACCEPT
  SET £tmp ^RND_~§sound_amount~
  SET §sound ~£tmp~
  INC §sound 1
  IF (§sound > §sound_amount) SET §sound 1
  IF (§last_misc == §sound) {
   INC §sound 1
   IF (§sound > §sound_amount) SET §sound 1
  }
  SET §last_misc §sound
  PLAY -p ~$TMP~~§sound~
  ACCEPT
 }
 IF (§reflection_mode == 2) 
 {
 // fighting
  SET $TMP £threat
  GOTO MISC_REFLECTION2
  ACCEPT
 }
 IF (§reflection_mode == 3) 
 {
 // searching
  SET $TMP £threat
  GOTO MISC_REFLECTION2
  ACCEPT
 }
ACCEPT
}

ON DOORLOCKED
{
 TIMERcloseit OFF
 IF (§door_locked_attempt < 2)
 {
  INC §door_locked_attempt 1
  ACCEPT
 }
 SET §door_locked_attempt 0
 GOTO FAILED_PATHFIND
 ACCEPT
}

// -------------------------------------------------------------------------------
// MAIN ANIMAL INCLUDE END -------------------------------------------------------
// -------------------------------------------------------------------------------


//#


//********************************

ON DIE {
 SET §enemy 0 
 SET_INTERACTIVITY NONE
//#die_animal
 SETEVENT CHAT OFF
 TIMERmisc_reflection OFF
 FORCEANIM DIE
 IF (£dying != "none") PLAY -p ~£dying~
 COLLISION OFF
 SETDETECT -1
 SET §totaldead 1


//#
  TIMERattract OFF
  ATTRACTOR SELF OFF
  ACCEPT
}

>>END0
 AMBIANCE -v 0 Ambient_fight_music
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER 
 SENDEVENT CUSTOM ~£demon~ "AKBAA_DEAD"
 GOTO END1
ACCEPT

>>END1
 SPEAK [Iserbius_akbaa_die] GOTO END2
ACCEPT

>>END2
 SPEAK -p [player_akbaa_die] GOTO END3
ACCEPT

>>END3
 SPEAK [Iserbius_die_1] GOTO DIE
ACCEPT

>>DIE
 SETMAINEVENT MAIN
ACCEPT

>>CHECK_LIFE
 //ca va etre ta mort
 IF (^LIFE > 600) ACCEPT
 SETPLAYERCONTROLS OFF
 CINEMASCOPE -s ON
 PLAYERINTERFACE HIDE
 SET §enemy 0
 PLAYANIM NONE
 TIMERlife OFF
 TIMERspecialattack off
 INVULNERABILITY ON
 HALO -ocs 0.137 0.403 0.372 100
 SENDEVENT CUSTOM ~£demon~ "AKBAA_DEAD"
 SENDEVENT CUSTOM ~£tentacle~ "DIE"
 //BEHAVIOR MOVE_TO
 //SETTARGET MARKER_0371
 //SETMOVEMODE RUN
 TELEPORT MARKER_0371
 TELEPORT -p MARKER_0564
 SENDEVENT ZEND AKBAA_PHASE2_0001 ""
 ACCEPT

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
