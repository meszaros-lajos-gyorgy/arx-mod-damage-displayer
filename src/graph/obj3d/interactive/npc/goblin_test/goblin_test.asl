ON INIT {
// SET §colliding 0
 SET £voice ""             //alternate is '_vb' (for gobs base only)

// ---------------------------------------------------------------------------------
// INIT INCLUDE START --------------------------------------------------------------
// ---------------------------------------------------------------------------------
 SET_EVENT HEAR OFF
 SET §player_enemy_send 0	  // 1 : PLAYER_ENEMY event already sent by this NPC
 SET §last_call_help 0		  // to avoid to many CALL_FOR_HELP events
 SET £attached_object "NONE"	  // name of attached object (if one)
 SET §special_attack 0		  // if 1 : must have a SPECIAL_ATTACK in the code (ratmen & mummies for instance)
 SET §sleeping 0                //meynier... tu dors...
 SET §care_about_mice 0         //when = 1, attack mice

 SET §main_behavior_stacked 0   //in order to restore the main behavior after a look_for or a help
 SET §reflection_mode 1         // 0: nothing, 1: normal, 2: threat, 3: search 
 SET §player_in_sight 0         //used for various reasons, =1 indicates that the NPC currently sees he player.

 SET §noise_heard 0             // if a npc hears a sound more than 3 times, he detects the player
 SET §looking_for 0             //1 = the NPC is about to look for the player 2=looking for him 
 SET §fighting_mode 0           //0 = NO   1 = Fighting    2 = Fleeing
 SET £last_heard "NOHEAR"
 SET §snd_tim 0
 SET §saved_reflection 0	  // used for chats to save current reflection_mode 
 SET §frozen 0                  //to stop looping anims if ATTACK_PLAYER called
 SET §spoted 0                  //defines if the NPC has already said "I'll get you" to the player
 SET §chatpos 0                 //defines the current dialogue position
 SET §targ 0                    //current target
 SET £targeted_mice "NOMOUSE"      //this stores the name of the current attacked mice, so that the NPC doesn't attack another one until this one is dead.
 SET £helping_target "NOFRIEND"     //this stores the name of the current NPC that his being helped.
 SET £key_carried "NOKEY"       //this might change, but it currently defines the ONLY key that the NPC carries with him 
 SET £targeted_door "NODOOR"      //this is used to check what door is dealing the npc with right now.
 SET_NPC_STAT BACKSTAB 1
 SET §spell_ready 1 		// only for spell casters
 SET £helping_buddy "NOBUDDY" // friend to run to in case of trouble
 SET §last_reflection 0		  // last time someone spoke
 SET £init_marker "NONE"	// go back to this marker if combat finished
 SET £friend "NONE"

 SET §stealed_gold 0		// the amount of gold stealed to the player (by the ratman)
 SET §failed_path 0		// first time : new try | second time : a behavior according to the current one
// ---------------------------------------------------------------------------------
// INIT INCLUDE END ----------------------------------------------------------------
// ---------------------------------------------------------------------------------


 PHYSICAL RADIUS 30
 SET_NPC_STAT reach 20
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_bare
// SET_BLOOD 0.9 0.1 0.1
 INVENTORY CREATE
 SETIRCOLOR 0.8 0.0 0.0
 SET_NPC_STAT RESISTMAGIC 10
 SET_NPC_STAT RESISTPOISON 10
 SET_NPC_STAT RESISTFIRE 1
 SET §enemy 0                   //defines if the NPC is enemy to the player at the moment
 SET §panicmode 0               //when = 0, the NPC is not sure if he saw the player "did that thing move over there ?"
 SET §tactic 0                  //0 = normal    1 = sneak   2 = rabit  3 = caster
 SET §current_tactic §tactic    //** used to restore previous tactic after a repel undead
 SET §cowardice 8               //if life < cowardice, NPC flees
 SET §pain 2                    //if damage < pain , no hit anim
 SET §low_life_alert 10         //**new set the value for the npc heals himself
 SET £friend "goblin"
 SET £type "goblin_base"
 LOADANIM WALK_SNEAK                 "goblin_walk_sneak"    //*****************  NEW
 loadanim BARE_READY                 "human_fight_ready_noweap"
 loadanim BARE_UNREADY               "human_fight_unready_noweap"
 loadanim BARE_WAIT                  "human_fight_wait_noweap"
 loadanim BARE_STRIKE_LEFT_START     "human_fight_attack_noweap_left_start"
 loadanim BARE_STRIKE_LEFT_CYCLE     "human_fight_attack_noweap_left_cycle"
 loadanim BARE_STRIKE_LEFT           "human_fight_attack_noweap_left_strike"
 loadanim BARE_STRIKE_RIGHT_START    "human_fight_attack_noweap_right_start"
 loadanim BARE_STRIKE_RIGHT_CYCLE    "human_fight_attack_noweap_right_cycle"
 loadanim BARE_STRIKE_RIGHT          "human_fight_attack_noweap_right_strike"
 loadanim BARE_STRIKE_TOP_START      "human_fight_attack_noweap_top_start"
 loadanim BARE_STRIKE_TOP_CYCLE      "human_fight_attack_noweap_top_cycle"
 loadanim BARE_STRIKE_TOP            "human_fight_attack_noweap_top_strike"
 loadanim BARE_STRIKE_BOTTOM_START   "human_fight_attack_noweap_bottom_start"
 loadanim BARE_STRIKE_BOTTOM_CYCLE   "human_fight_attack_noweap_bottom_cycle"
 loadanim BARE_STRIKE_BOTTOM         "human_fight_attack_noweap_bottom_strike"
 loadanim 1H_WAIT                    "human_fight_wait_1handed"
 loadanim 1H_STRIKE_LEFT_START       "human_fight_attack_1handed_left_start"
 loadanim 1H_STRIKE_LEFT_CYCLE       "human_fight_attack_1handed_left_cycle"
 loadanim 1H_STRIKE_LEFT             "human_fight_attack_1handed_left_strike"
 loadanim 1H_STRIKE_RIGHT_START      "human_fight_attack_1handed_right_start"
 loadanim 1H_STRIKE_RIGHT_CYCLE      "human_fight_attack_1handed_right_cycle"
 loadanim 1H_STRIKE_RIGHT            "human_fight_attack_1handed_right_strike"
 loadanim 1H_STRIKE_TOP_START        "human_fight_attack_1handed_top_start"
 loadanim 1H_STRIKE_TOP_CYCLE        "human_fight_attack_1handed_top_cycle"
 loadanim 1H_STRIKE_TOP              "human_fight_attack_1handed_top_strike"
 loadanim 1H_STRIKE_BOTTOM_START     "human_fight_attack_1handed_bottom_start"
 loadanim 1H_STRIKE_BOTTOM_CYCLE     "human_fight_attack_1handed_bottom_cycle"
 loadanim 1H_STRIKE_BOTTOM           "human_fight_attack_1handed_bottom_strike"
 loadanim 2H_READY_PART_1            "human_fight_ready_2handed_start"
 loadanim 2H_READY_PART_2            "human_fight_ready_2handed_end"
 loadanim 2H_UNREADY_PART_1          "human_fight_unready_2handed_start"
 loadanim 2H_UNREADY_PART_2          "human_fight_unready_2handed_end"
 loadanim 2H_WAIT                    "human_fight_wait_2handed"
 loadanim 2H_STRIKE_LEFT_START       "human_fight_attack_2handed_left_start"
 loadanim 2H_STRIKE_LEFT_CYCLE       "human_fight_attack_2handed_left_cycle"
 loadanim 2H_STRIKE_LEFT             "human_fight_attack_2handed_left_strike"
 loadanim 2H_STRIKE_RIGHT_START      "human_fight_attack_2handed_right_start"
 loadanim 2H_STRIKE_RIGHT_CYCLE      "human_fight_attack_2handed_right_cycle"
 loadanim 2H_STRIKE_RIGHT            "human_fight_attack_2handed_right_strike"
 loadanim 2H_STRIKE_TOP_START        "human_fight_attack_2handed_top_start"
 loadanim 2H_STRIKE_TOP_CYCLE        "human_fight_attack_2handed_top_cycle"
 loadanim 2H_STRIKE_TOP              "human_fight_attack_2handed_top_strike"
 loadanim 2H_STRIKE_BOTTOM_START     "human_fight_attack_2handed_bottom_start"
 loadanim 2H_STRIKE_BOTTOM_CYCLE     "human_fight_attack_2handed_bottom_cycle"
 loadanim 2H_STRIKE_BOTTOM           "human_fight_attack_2handed_bottom_strike"
 loadanim DAGGER_READY_PART_1        "human_fight_ready_dagger_start"
 loadanim DAGGER_READY_PART_2        "human_fight_ready_dagger_end"
 loadanim DAGGER_UNREADY_PART_1      "human_fight_unready_dagger_start"
 loadanim DAGGER_UNREADY_PART_2      "human_fight_unready_dagger_end"
 loadanim DAGGER_WAIT                "human_fight_attack_dagger_wait"
 loadanim DAGGER_STRIKE_LEFT_START   "human_fight_attack_dagger_left_start"
 loadanim DAGGER_STRIKE_LEFT_CYCLE   "human_fight_attack_dagger_left_cycle"
 loadanim DAGGER_STRIKE_LEFT         "human_fight_attack_dagger_left_strike"
 loadanim DAGGER_STRIKE_RIGHT_START  "human_fight_attack_dagger_right_start"
 loadanim DAGGER_STRIKE_RIGHT_CYCLE  "human_fight_attack_dagger_right_cycle"
 loadanim DAGGER_STRIKE_RIGHT        "human_fight_attack_dagger_right_strike"
 loadanim DAGGER_STRIKE_TOP_START    "human_fight_attack_dagger_top_start"
 loadanim DAGGER_STRIKE_TOP_CYCLE    "human_fight_attack_dagger_top_cycle"
 loadanim DAGGER_STRIKE_TOP          "human_fight_attack_dagger_top_strike"
 loadanim DAGGER_STRIKE_BOTTOM_START "human_fight_attack_dagger_bottom_start"
 loadanim DAGGER_STRIKE_BOTTOM_CYCLE "human_fight_attack_dagger_bottom_cycle"
 loadanim DAGGER_STRIKE_BOTTOM       "human_fight_attack_dagger_bottom_strike"
 loadanim MISSILE_READY_PART_1       "human_fight_ready_bow_start"
 loadanim MISSILE_READY_PART_2       "human_fight_ready_bow_end"
 loadanim MISSILE_UNREADY_PART_1     "human_fight_unready_bow_start"
 loadanim MISSILE_UNREADY_PART_2     "human_fight_unready_bow_end"
 loadanim MISSILE_WAIT               "human_fight_wait_bow"
 loadanim MISSILE_STRIKE_PART_1      "human_fight_attack_bow_start_part1"
 loadanim MISSILE_STRIKE_PART_2      "human_fight_attack_bow_start_part2"
 loadanim MISSILE_STRIKE_CYCLE       "human_fight_attack_bow_cycle"
 loadanim MISSILE_STRIKE             "human_fight_attack_bow_strike"
 loadanim ACTION1                    "human_misc_kick_rat"
 ACCEPT
}

ON INITEND {
 IF (§enemy == 1) SET_EVENT HEAR ON
 IF ( £friend != "NONE" ) SETGROUP £friend
 SET §scale 95
 SET #TMP ~^RND_10~
 INC §scale #TMP
 SETSCALE §scale
 IF ( §care_about_mice == 1 )
 {
   SETGROUP MICECARE
 }
 
 // belongings ------------------------------------------------------
  RANDOM 40 
  {
   SET #TMP ~^RND_6~
   IF (#TMP == 0) INVENTORY ADD "PROVISIONS\\food_apple\\food_apple"
   IF (#TMP == 1) INVENTORY ADD "PROVISIONS\\food_chicken\\food_chicken"
   IF (#TMP == 2) INVENTORY ADD "PROVISIONS\\food_fish\\food_fish"
   IF (#TMP == 3) INVENTORY ADD "PROVISIONS\\food_leek\\food_leek"
   IF (#TMP == 4) INVENTORY ADD "PROVISIONS\\ribs_cooked\\ribs_cooked"
   IF (#TMP == 5) INVENTORY ADD "PROVISIONS\\Bread_half\\Bread_half"
  }
  RANDOM 20 
  {
   SET #TMP ~^RND_6~
   IF (#TMP == 0) INVENTORY ADD "PROVISIONS\\garlic\\garlic"
   IF (#TMP == 1) INVENTORY ADD "PROVISIONS\\mushroom\\food_mushroom"
   IF (#TMP == 2) INVENTORY ADD "PROVISIONS\\bottle_wine\\bottle_wine"
   IF (#TMP == 3) INVENTORY ADD "PROVISIONS\\bottle_water\\bottle_water"
   IF (#TMP == 4) INVENTORY ADD "PROVISIONS\\bottle_empty\\bottle_empty"
   IF (#TMP == 5) INVENTORY ADD "PROVISIONS\\garlic\\garlic"
  }
  RANDOM 20 
  {
   INVENTORY ADD "PROVISIONS\\torch\\torch"
  }
  SET #TMP ~^RND_30~
  IF ( #TMP > 0 )
  {
   INVENTORY ADDMULTI "JEWELRY\\GOLD_COIN\\GOLD_COIN" ~#TMP~
  }
  
  INVENTORY SKIN "ingame_inventory_corpse"
  // end of belongings -------------------------------------------------



 IF (£type == "goblin_base") 
 {
  SETNAME [description_goblin]
  SETWEAPON CLUB
  SET_NPC_STAT armor_class 8
  SET_NPC_STAT absorb 10
  SET_NPC_STAT damages 4
  SET_NPC_STAT tohit 30
  SET_NPC_STAT aimtime 10
  SET_NPC_STAT life 1200
  SET_XP_VALUE 40
  LOADANIM GRUNT                      "Goblin_fight_grunt"
  LOADANIM WALK                       "Goblin_normal_walk"
  LOADANIM RUN                        "goblin_normal_run"
  LOADANIM WAIT                       "Goblin_normal_wait"
  LOADANIM HIT                        "Goblin_fight_receive_damage"
  LOADANIM HIT_SHORT                  "Goblin_hit_short"
  LOADANIM DIE                        "Goblin_death"
  LOADANIM TALK_NEUTRAL               "Goblin_normal_talk_neutral_headonly"
  LOADANIM TALK_HAPPY                 "Goblin_normal_talk_happy_headonly"
  LOADANIM TALK_ANGRY                 "Goblin_normal_talk_angry_headonly"
  loadanim FIGHT_WALK_FORWARD         "Goblin_fight_walk"
  loadanim FIGHT_WALK_BACKWARD        "human_fight_walk_backward"
  loadanim FIGHT_STRAFE_RIGHT         "goblin_strafe_right"
  loadanim FIGHT_STRAFE_LEFT          "goblin_strafe_left"
  loadanim FIGHT_WAIT                 "Goblin_fight_wait_1handed"
  loadanim 1H_READY_PART_1            "goblin_fight_ready_1handed_start"
  loadanim 1H_READY_PART_2            "goblin_fight_ready_1handed_end"
  loadanim 1H_UNREADY_PART_1          "goblin_fight_unready_1handed_start"
  loadanim 1H_UNREADY_PART_2          "goblin_fight_unready_1handed_end"
  SET £hail [Goblin_hail]
  SET £thief [Goblin_thief]
  SET £strike [Goblin_striking]
  SET £victory [Goblin_victory]
  SET £whogoesthere [Goblin_guardmode]
  SET £heardnoise [Goblin_hear]
  SET £back2guard [Goblin_back2guard]
  SET £misc [Goblin_misc~£voice~]
  SET £threat [Goblin_threat]
  SET £search [Goblin_search]
  SET £youmad [Goblin_mad]
  SET £dying [Goblin_dying]
  SET £ouch [goblin_ouch]
  SET £ouch_medium [goblin_ouch_medium]
  SET £ouch_strong [goblin_ouch_strong]
  SET £help [Goblin_help]
  SET £comeback [Goblin_comeback]
  SET £justyouwait [Goblin_justyouwait]
  TIMERmisc_reflection  -i 0 10 SENDEVENT MISC_REFLECTION SELF ""

  ACCEPT
 }
 IF (£type == "goblin_lord") {
  SETNAME [description_goblin_lord]
  SET_NPC_STAT armor_class 12
  SET_NPC_STAT absorb 20
  SET_NPC_STAT damages 10
  SET_NPC_STAT tohit 50
  SET_NPC_STAT aimtime 1000
  SET_NPC_STAT life 25
  SET_XP_VALUE 70
  SET §cowardice 0
  SET §pain 4
  LOADANIM GRUNT                      "Goblinlord_fight_grunt"
  LOADANIM WALK                       "Goblinlord_normal_walk"
  LOADANIM RUN                        "goblinlord_normal_run"
  LOADANIM WAIT                       "Goblinlord_normal_wait"
  LOADANIM HIT                        "Goblinlord_fight_receive_damage"
  LOADANIM HIT_SHORT                  "Goblinlord_hit_short"
  LOADANIM DIE                        "Goblinlord_death"
  LOADANIM TALK_NEUTRAL               "Goblinlord_normal_talk_neutral_headonly"
  LOADANIM TALK_HAPPY                 "Goblinlord_normal_talk_happy_headonly"
  LOADANIM TALK_ANGRY                 "Goblinlord_normal_talk_angry_headonly"
  loadanim FIGHT_WALK_FORWARD         "goblinlord_fight_walk"
  loadanim FIGHT_WALK_BACKWARD        "human_fight_walk_backward"
  loadanim FIGHT_STRAFE_RIGHT         "goblinlord_strafe_right"
  loadanim FIGHT_STRAFE_LEFT          "goblinlord_strafe_left"
  loadanim FIGHT_WAIT                 "goblinlord_fight_wait"
  loadanim 1H_READY_PART_1            "goblinlord_fight_ready_1handed_start"
  loadanim 1H_READY_PART_2            "goblinlord_fight_ready_1handed_end"
  loadanim 1H_UNREADY_PART_1          "goblinlord_fight_unready_1handed_start"
  loadanim 1H_UNREADY_PART_2          "goblinlord_fight_unready_1handed_end"
  SET £hail [Goblinlord_hail]
  SET £thief [Goblinlord_thief]
  SET £strike [Goblinlord_striking]
  SET £victory [Goblinlord_victory]
  SET £whogoesthere [Goblinlord_guardmode]
  SET £heardnoise [Goblinlord_hear]
  SET £back2guard [Goblinlord_back2guard]
  SET £misc [Goblinlord_misc]
  SET £threat [Goblinlord_threat]
  SET £search [Goblinlord_search]
  SET £youmad [Goblinlord_mad]
  SET £dying [Goblinlord_dying]
  SET £ouch [goblinlord_ouch]
  SET £ouch_medium [goblinlord_ouch_medium]
  SET £ouch_strong [goblinlord_ouch_strong]
  SET £help []
  SET £comeback [Goblinlord_comeback]
  SET £justyouwait [Goblinlord_justyouwait]
  TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
  ACCEPT
 }
 IF (£type == "goblin_king") {
  SET_XP_VALUE 70
  LOADANIM GRUNT                      "Goblin_fight_grunt"  //*****************  NEW
  LOADANIM WALK                       "Goblin_normal_walk"
  LOADANIM RUN                        "goblin_normal_run"
  LOADANIM WAIT                       "Goblin_normal_wait"
  LOADANIM HIT                        "Goblin_fight_receive_damage"
  LOADANIM DIE                        "Goblin_death"
  LOADANIM HIT_SHORT                  "Goblin_hit_short"
  LOADANIM TALK_NEUTRAL               "Goblin_normal_talk_neutral_headonly"
  LOADANIM TALK_HAPPY                 "Goblin_normal_talk_happy_headonly"
  LOADANIM TALK_ANGRY                 "Goblin_normal_talk_angry_headonly"
  loadanim FIGHT_WALK_FORWARD         "Goblin_fight_walk"
  loadanim FIGHT_WALK_BACKWARD        "human_fight_walk_backward"
  loadanim FIGHT_STRAFE_RIGHT         "goblin_strafe_right"
  loadanim FIGHT_STRAFE_LEFT          "goblin_strafe_left"
  loadanim FIGHT_WAIT                 "Goblin_fight_wait_1handed"
  loadanim 1H_READY_PART_1            "goblin_fight_ready_1handed_start"
  loadanim 1H_READY_PART_2            "goblin_fight_ready_1handed_end"
  loadanim 1H_UNREADY_PART_1          "goblin_fight_unready_1handed_start"
  loadanim 1H_UNREADY_PART_2          "goblin_fight_unready_1handed_end"
  SET £hail []
  SET £thief []
  SET £strike []
  SET £victory []
  SET £whogoesthere []
  SET £heardnoise []
  SET £back2guard []
  SET £misc []
  SET £threat []
  SET £search []
  SET £youmad []
  SET £dying [Goblinlord_dying]
  SET £ouch [goblinlord_ouch]
  SET £ouch_medium [goblinlord_ouch_medium]
  SET £ouch_strong [goblinlord_ouch_strong]
  SET £help []
  SET £comeback []
  SET £justyouwait []
  ACCEPT
 }
 ACCEPT
}

//********************START*****************************

//********************************
//* specific section to this NPC *
//********************************

//****************************************
//* END of specific section for this NPC *
//****************************************

//************************
//*   MAGIC              *
//************************


//----------------------------------------------------------------
// SPELL_REACTION INLCUDE START ----------------------------------
//----------------------------------------------------------------

ON SPELLCAST 
{
 IF( #SHUT_UP == 1 ) ACCEPT // pas de spell pendant les cine !!
	HERO_SAY -d "RECEIVED SPELL"
 IF (^SENDER != PLAYER) ACCEPT
// IF (§enemy == 0) ACCEPT

// IF (£type ISCLASS undead) 
 IF ( SELF ISGROUP UNDEAD )
 {
  IF (^$PARAM1 == REPEL_UNDEAD)
  {
   IF( £type == "undead_lich" )
   {
    IF( ^$PARAM2 < 6 ) 
    {
     HERO_SAY -d "pas assez fort, mon fils"
     ACCEPT
    }
   }
    GOTO REPEL
  }
 }
 IF (^$PARAM1 == HARM) GOTO NO_PAIN_REPEL
 IF (^$PARAM1 == LIFE_DRAIN) GOTO NO_PAIN_REPEL

 IF (^$PARAM1 == MANA_DRAIN) GOTO REPEL
 IF (^$PARAM1 == NEGATE_MAGIC) GOTO REPEL

 ACCEPT
}

>>NO_PAIN_REPEL
 IF ( §tactic == 2 ) ACCEPT
 SET §oldpain §pain
 SET §pain 20
>>REPEL
	HERO_SAY -d "repel undead succesful"
 SET §tactic 2
 IF (§player_in_sight == 1) GOTO FLEE
 ACCEPT

>>END_PAIN_REPEL
 SET §pain §oldpain
>>END_REPEL
 set §tactic §current_tactic
 IF ( §enemy == 1 ) GOTO ATTACK_PLAYER
 ACCEPT
//********************************


ON SPELLEND 
{
 IF (^SENDER != PLAYER) ACCEPT
// IF (§enemy == 0) ACCEPT
// IF (£type ISCLASS undead) 
 IF ( SELF ISGROUP UNDEAD )
 {
  IF (^$PARAM1 == REPEL_UNDEAD) GOTO END_REPEL
 }
 IF (^$PARAM1 == HARM) GOTO END_PAIN_REPEL
 IF (^$PARAM1 == LIFE_DRAIN) GOTO END_PAIN_REPEL
 IF (^$PARAM1 == MANA_DRAIN) GOTO END_REPEL
 IF (^$PARAM1 == NEGATE_MAGIC) GOTO END_REPEL
ACCEPT
}//----------------------------------------------------------------
// SPELL_REACTION INLCUDE END  -----------------------------------
//----------------------------------------------------------------



//************************
//*   MAGIC END          *
//************************


ON CHAT {
 IF (§enemy == 1) SENDEVENT DETECTPLAYER SELF ""
 ACCEPT
}


// ---------------------------------------------------------------------------------
// BEHAVIOR INCLUDE START ----------------------------------------------------------
// ---------------------------------------------------------------------------------
>>CLEAR_MICE_TARGET
 // if we care about mice : clear current mice target and listen to other mice
 IF ( §care_about_mice == 1 )
 {
  SET £targeted_mice "NOMOUSE"
  SETGROUP MICECARE // listen to other mice
 }
RETURN

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
 ELSE
 { // behavior already saved : clear mice target if one
  GOSUB CLEAR_MICE_TARGET
 }
RETURN

>>RESTORE_BEHAVIOR
 IF (§main_behavior_stacked == 1) 
 {
  GOSUB CLEAR_MICE_TARGET
  HEROSAY -d "UNSTACK"
  BEHAVIOR UNSTACK
  SET §main_behavior_stacked 0
 }
RETURN

// ---------------------------------------------------------------------------------
// BEHAVIOR INCLUDE END ------------------------------------------------------------
// ---------------------------------------------------------------------------------




// ---------------------------------------------------------------------------------
// MICE_MAIN INCLUDE START ---------------------------------------------------------
// ---------------------------------------------------------------------------------
ON MANIFEST
{
 IF (^$PARAM1 == "MICE" ) 
 {
   IF (§care_about_mice == 0) ACCEPT	 // don't care !
   IF (§main_behavior_stacked == 1) ACCEPT // already doing something
   IF ( §frozen == 1 ) ACCEPT // frozen anim... don't look for mice
   IF (^SPEAKING == 1) ACCEPT

   GOSUB SAVE_BEHAVIOR
   
   SETGROUP -r MICECARE // we're hunting a mouse now, don't need other messages
   SET £targeted_mice ^sender // Let's crunch that little pet !
   BEHAVIOR MOVE_TO
   SETTARGET ~£targeted_mice~
 }
 ACCEPT
}

ON LOSTTARGET 
{
 IF (^TARGET == £targeted_mice)
 { // mouse gone ?
  GOSUB RESTORE_BEHAVIOR
 }
 ACCEPT
}

>>KILL_MICE
 IF (^TARGET == £targeted_mice) 
 { // mouse reached
  BEHAVIOR FRIENDLY
  SETTARGET ~£targeted_mice~
  // stop moving fucking mouse !
  SENDEVENT STOP_MOUSE ~£targeted_mice~ ""
  PLAYANIM ACTION1 // kick its ass !
  TIMERmice -m 1 600 FORCEDEATH ~£targeted_mice~
 }
RETURN

>>MICE_DEATH
 IF (^SENDER == £targeted_mice ) 
 {
  TIMERmousedead 1 1 GOSUB RESTORE_BEHAVIOR ACCEPT
 }
RETURN

// ---------------------------------------------------------------------------------
// MICE_MAIN INCLUDE END -----------------------------------------------------------
// ---------------------------------------------------------------------------------



// -------------------------------------------------------------------------------
// MAIN CLEVER INCLUDE START -----------------------------------------------------
// -------------------------------------------------------------------------------

ON CONTROLS_ON 
{
 IF ( §controls_off == 0 ) ACCEPT
 SET §controls_off 0
 SET §reflection_mode §saved_reflection
 IF (§enemy == 0) ACCEPT
 COLLISION ON
 BEHAVIOR UNSTACK
 ACCEPT
}

ON CONTROLS_OFF
{
 SET §controls_off 1
 SET §saved_reflection §reflection_mode
 SET §reflection_mode 0
 IF ( §enemy == 0 ) ACCEPT
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
// SENDEVENT SPEAK_NO_REPEAT SELF "5 A £comeback"
// NPC will say the text in £comeback with angry (A) expression
// only if no other NPC has spoken during last 5 seconds
// expression : N = none, A = angry, H = happy, P = say by player 
//*******************************************************
ON SPEAK_NO_REPEAT
{
 IF (^SPEAKING == 1) ACCEPT
 IF ( #SHUT_UP == 1 ) ACCEPT // cinematics

 // test to see if someone else has spoken recently...
 SET #TMP ^GAMESECONDS
 DEC #TMP §last_reflection
 IF ( #TMP <= ^#PARAM1 ) ACCEPT // at least ^#PARAM1 seconds between reflections

 IF ( ^$PARAM2 == "N" )
 { // no switch
  SPEAK ~^$PARAM3~ NOP
 }
 ELSE
 {
  SPEAK -~^$PARAM2~ ~^$PARAM3~ NOP
 }
 // inform other NPC that I have spoken
 SENDEVENT -rn OTHER_REFLECTION 1000 ""
 SET §last_reflection ^GAMESECONDS
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
 HEROSAY -d "collide player"
 IF ( §controls_off != 0 ) ACCEPT
 IF (§fighting_mode == 2) ACCEPT
// IF ( ^SENDER != PLAYER ) ACCEPT
 if (§collided_player == 1) ACCEPT
 IF ( §enemy == 1 ) GOTO PLAYER_DETECTED
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
 IF ( §controls_off != 0 ) ACCEPT
 IF (§player_in_sight == 1) ACCEPT
 IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT

 SET §player_in_sight 1
 SET_NPC_STAT BACKSTAB 0

 IF (§enemy == 0) ACCEPT
 IF (§fighting_mode == 2) ACCEPT
 IF (§sleeping == 1) ACCEPT
 IF (§panicmode > 0) GOTO ATTACK_PLAYER
 IF (^DIST_PLAYER < 600) GOTO ATTACK_PLAYER

 TIMERdoubting 1 3 GOTO ATTACK_PLAYER

 IF ( SELF ISGROUP UNDEAD ) TIMERmain OFF
 SET §panicmode 2  // this sets the NPC in doubting mode
 SET §looking_for 0
 SPEAK -a ~£whogoesthere~ NOP
 SET §reflection_mode 0
 TIMERquiet OFF   // so the NPC doesn't say : "just a rat"
 GOSUB SAVE_BEHAVIOR
 BEHAVIOR MOVE_TO
 SETTARGET PLAYER
 SETMOVEMODE WALK
 ACCEPT
}

//*******************************************************
ON HEAR 
{
IF ( §controls_off != 0 ) ACCEPT

 IF (§sleeping == 1) 
 { // first sound -> wake up and that's all
  SET §sleeping 0
  ACCEPT
 }
 IF (§enemy == 0) ACCEPT
 IF (§player_in_sight == 1) ACCEPT
 IF (§looking_for >= 1) GOTO ATTACK_PLAYER 	// [FLURE](§looking_for>=1)
 IF (§fighting_mode >= 1) GOTO PLAYER_DETECTED
 IF ( ^SENDER == PLAYER )
 {
  IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
 }
 IF (^SENDER == £last_heard) {
  SET #TMP ^GAMESECONDS
  DEC #TMP §snd_tim
  IF (#TMP < 3) ACCEPT // same sound source won't be heard during 2 seconds
 }
 TIMERheard OFF
 INC §noise_heard 1
 IF (§noise_heard > 3) GOTO PLAYER_DETECTED // 3 different sounds -> auto detect player
								//[FLURE](§noise_heard>2) ... now 4 diff sounds
 SET £last_heard ^SENDER
 SET §snd_tim ^GAMESECONDS
 IF (§panicmode != 2) SET §panicmode 1
 SET §reflection_mode 0
 TIMERquiet OFF
 GOSUB SAVE_BEHAVIOR
 RANDOM 50 SPEAK -a ~£heardnoise~ NOP
 IF( §noise_heard == 1 ) {
  BEHAVIOR FRIENDLY
  SETTARGET ^SENDER
  HEROSAY -d "turning to face the sound"
  TIMERheard 1 6 GOSUB RESTORE_BEHAVIOR
  ACCEPT
 }
 // here we have a new sound source -> go to see what it was
  HEROSAY -d "going to sound"
  BEHAVIOR MOVE_TO
  SETTARGET -n ~£last_heard~
  SETMOVEMODE WALK
 ACCEPT
}

//*******************************************************
ON UNDETECTPLAYER 
{
herosay -d "undetect"
 IF ( §controls_off != 0 ) ACCEPT
 SET §player_in_sight 0
 IF ( SELF ISGROUP UNDEAD )
 {
  TIMERmain 0 2 GOTO MAIN_ALERT
 }
 IF (§enemy == 0) SET_NPC_STAT BACKSTAB 1 ACCEPT
 IF (§panicmode == 2) 
 { // didn't find player
  TIMERdoubting OFF
  SET §panicmode 1
  TIMERquiet 1 2 SPEAK ~£back2guard~ GOTO GO_HOME
 }
 IF (§fighting_mode != 1) ACCEPT
 SET_NPC_STAT BACKSTAB 1
 IF (^TARGET == PLAYER) 
 {
  IF (§looking_for == 0) 
  {
   IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
   SET §looking_for 1
   SET §reflection_mode 0
   TIMERlookfor 1 5 GOTO LOOK_FOR
   SENDEVENT SPEAK_NO_REPEAT SELF "3 N £comeback"
   ACCEPT
  }
  ACCEPT
 }
 ACCEPT
}


//*******************************************************
ON PLAYER_ENEMY 
{
 herosay -d "PLAYER_ENEMY received"
 SET §player_enemy_send 1 // player is the enemy of this group so don't send this event again !
 SET §enemy 1
 SETEVENT CHAT OFF
 SET_EVENT HEAR ON
 IF ( §player_in_sight == 1 ) GOTO ATTACK_PLAYER
 IF (^DIST_PLAYER < 500) GOTO ATTACK_PLAYER
 ACCEPT
}

//*******************************************************
ON STRIKE 
{
 if( £type == "ratmen" )
 {
  random 25
  {
   SET #TMP ~^RND_10~
   >>TEST_PLAYER_GOLD
   if ( #TMP > 0 )
   {
    if ( #TMP < ^PLAYER_GOLD )
    {
     DIV #TMP 2
     GOTO TEST_PLAYER_GOLD
    }
   }
   
   ADD_GOLD -~#TMP~
   //INVENTORY ADDMULTI "Jewelry\\Gold_coin\\Gold_coin" ~#TMP~
   INC §stealed_gold #TMP
   HERO_SAY -d "le ratman a vole"
   HERO_SAY -d ~#TMP~
  }
  else
  {
   HERO_SAY -d "le ratman n'a rien vole"
  }
 }

 IF ( §special_attack == 1 ) GOSUB SPECIAL_ATTACK
 IF (^SPEAKING == 0) {
  RANDOM 50 ACCEPT
  SPEAK -a ~£strike~ NOP
 }
 ACCEPT
}

//*******************************************************
ON COLLIDE_DOOR 
{
 SET £targeted_door ^SENDER
 SENDEVENT NPC_OPEN £targeted_door ~£key_carried~
 TIMERcloseit 1 4 SENDEVENT NPC_CLOSE £targeted_door ~£key_carried~
 ACCEPT
}

ON DOORLOCKED
{
 TIMERcloseit OFF
 ACCEPT
}

//*******************************************************
>>CALL_FOR_HELP
 IF ( £friend != "NONE" )
 {
  IF ( §controls_off != 0 ) RETURN
  SET #TMP ^GAMESECONDS
  DEC #TMP §last_call_help
  IF ( #TMP > 4 ) 
  { // don't call for help too often...
   herosay -d "CALL FOR HELP !!!"
   IF (§fightingmode == 2) SENDEVENT -gr ~£friend~ CALL_HELP 1000 ""
   ELSE SENDEVENT -gr ~£friend~ CALL_HELP 500 ""
   SET §last_call_help ^GAMESECONDS
  }
 }
RETURN

//*******************************************************
ON OUCH 
{
>>OUCH_START
 // visualy react to ouch --------------------------------------
 IF (^#PARAM1 < §pain) 
 {
  FORCEANIM HIT_SHORT
  IF (§enemy == 0) SPEAK [] NOP // no Pain !
 }
 ELSE
 { // ouch it hurts !
  FORCEANIM HIT
  SET &TMP §pain
  MUL &TMP 3
  IF (^#PARAM1 >= &TMP) 
  { // big ouch : it hurts !
   SPEAK -a ~£ouch_strong~ NOP
  }
  ELSE
  {
   SET &TMP §pain
   MUL &TMP 2
   IF (^#PARAM1 >= &TMP) 
   { // medium
    SPEAK -a ~£ouch_medium~ NOP
   }
   ELSE
   { // normal
    SPEAK -a ~£ouch~ NOP
   }
  }
 }

>>OUCHSUITE
 IF ( §controls_off != 0 ) ACCEPT
 // react to agression -----------------------------------------
 IF (^SENDER == "PLAYER") 
 {
  IF (§player_in_sight == 0)
  { // player wasn't in sight -> search him
   SET §enemy 1
   GOTO LOOK_FOR //in case the player hits from a distance
  }

  SET_EVENT AGRESSION OFF
  SET §spoted 1 // OK, I've seen you !

  GOTO ATTACK_PLAYER_AFTER_OUCH

 }
 ACCEPT
}

//*******************************************************
>>ATTACK_PLAYER
 IF ( ^SPEAKING != 0 )
 {
  IF (§enemy == 0) SPEAK [] NOP 	// to stop misc reflections
 }
>>ATTACK_PLAYER_AFTER_OUCH
 IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
 TIMERlookfor OFF
 TIMERheard OFF
 SET §panicmode 1
 SET §looking_for 0
 SET §enemy 1
 SET_EVENT HEAR OFF
 IF ( SELF ISGROUP UNDEAD ) TIMERmain OFF
 IF (§noise_heard < 2) SET §noise_heard 2
 GOSUB CALL_FOR_HELP
 IF ( §player_enemy_send == 0 ) 
  {
   SET §player_enemy_send 1
   SENDEVENT -g £friend PLAYER_ENEMY ""
   herosay -d "PLAYER_ENEMY sent"
  }
 TIMER kill_local					// kill all local timers
 TIMERquiet OFF 					// so the NPC doesn't say : "just a rat"
 SET_NPC_STAT BACKSTAB 0			// player is now detected !
 IF (^LIFE < §cowardice) GOTO FLEE		// low life
 IF (§fighting_mode == 2) ACCEPT		// fleeing
 IF (§fighting_mode == 1) 
 { // fighting
  SET §reflection_mode 2
  ACCEPT
 }
 IF ( £attached_object != "NONE" )
 { // detach object if attached
  DETACH ~£attached_object~ SELF
  OBJECT_HIDE ~£attached_object~ ON
  SET £attached_object "NONE"
 }
 GOSUB SAVE_BEHAVIOR
 SENDEVENT MISC_REFLECTION SELF "" 		// to reset misc_reflection timer

 IF (§fighting_mode == 3) GOTO FLEE		// end of flee -> flee again
 IF (§tactic == 2) GOTO FLEE 			// coward

 // start of fighting behavior
 IF ( §spoted == 0 )
 { // first time player is spotted HAIL !
  SET §spoted 1
  SENDEVENT SPEAK_NO_REPEAT SELF "3 A £hail"
 }
 SET §reflection_mode 2				// fight misc_ref
 SET §fighting_mode 1				// fighting
 IF (§tactic == 0) 
 { // normal fight
  BEHAVIOR -f MOVE_TO
 }
 ELSE
 {
  IF (§tactic == 1) 
  { // sneak fight
   BEHAVIOR -fs MOVE_TO
  }
  ELSE 
  { // distant fight (magic)
    BEHAVIOR -m MOVE_TO
  }
 }
 SETTARGET -a PLAYER
HEROSAY -d "WEAPON ON"
 WEAPON ON						// this may help ;-)
 SETMOVEMODE RUN
 ACCEPT

>>FLEE
  IF (§fighting_mode == 2) ACCEPT
  SET §fighting_mode 2  			// Fleeing
  HEROSAY -d "Fleeing"
  TIMER kill_local
  SET_EVENT HEAR OFF
  SET_EVENT COLLIDE_NPC OFF
  SET §reflection_mode 0

  IF ( £helping_buddy == "NOBUDDY" ) {
    BEHAVIOR FLEE 1000
    SETTARGET PLAYER
    SETMOVEMODE RUN
  }
  ELSE {
    BEHAVIOR MOVE_TO
    SETTARGET -n £helping_buddy
    SETMOVEMODE RUN
  }

  GOSUB CALL_FOR_HELP				// call friends
  TIMERcoward 1 2 SENDEVENT SPEAK_NO_REPEAT SELF "5 A £help"
  TIMERhome 1 30 GOTO GO_HOME
 ACCEPT


//*******************************************************
>>LOOK_FOR
 IF ( §controls_off != 0 ) ACCEPT
 IF (^DIST_PLAYER < 500) GOTO PLAYER_DETECTED
>>LOOK_FOR_SUITE
 IF ( §controls_off != 0 ) ACCEPT
 IF (§looking_for > 2) GOTO PLAYER_DETECTED //in case NPC already looking for
 IF ( §fighting_mode > 1 ) ACCEPT
 BEHAVIOR LOOK_FOR 500
 SETTARGET -a PLAYER
 SETMOVEMODE WALK
 SET §looking_for 0
 SET §fighting_mode 0
 SET_EVENT HEAR ON
 SET §reflection_mode 3
 TIMERhome 1 10 GOTO GO_HOME 	//[FLURE] TIMERhome 1 30 GOTO GO_HOME
ACCEPT


//*******************************************************
ON REACHEDTARGET 
{
 IF (^TARGET == PLAYER) 
 {
  IF (^$PARAM1 == "FAKE") {
   IF (£last_heard == PLAYER) GOTO REACHSND
  }
  IF ( §fighting_mode == 2) ACCEPT
  IF ( §controls_off != 0 ) ACCEPT
  IF (^PLAYERSPELL_INVISIBILITY == 0) GOTO PLAYER_DETECTED
  IF (§looking_for != 0) GOTO LOOK_FOR_SUITE
  IF (§fighting_mode == 1) 
  {
   IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT
   IF (§reflection_mode != 2) SET §reflection_mode 2
   ACCEPT
  }
  ACCEPT
 }
 IF (£friend == "DEMON") 
 {
  IF (§order == 1) 
  {
   BEHAVIOR FRIENDLY 
   SETTARGET PLAYER //used for spell control
  }
 }
 IF (^TARGET == £helping_target) 
 {
  IF ( §controls_off != 0 ) ACCEPT
  // si player dead -> goto home
  IF ( ^PLAYER_LIFE <= 0 )
  {
   SET §fighting_mode 0
   GOTO GO_HOME
  }
  ELSE
  {
   GOSUB CALL_FOR_HELP
   GOTO LOOK_FOR_SUITE
  }
 }
  >>REACHSND
 IF (^TARGET == £last_heard) 
 { 
  BEHAVIOR FRIENDLY
  SETTARGET £last_heard
  SET £last_heard "NOHEAR"
  IF (§looking_for != 0) GOTO LOOK_FOR_SUITE
  TIMERheard 1 6 SENDEVENT SPEAK_NO_REPEAT SELF "3 N £back2guard" GOTO GO_HOME
  ACCEPT
 }
 IF (^TARGET == £helping_buddy) {
  SENDEVENT -rn DELATION 500 ""
  DIV §cowardice 2
  GOTO FLEE_END
  ACCEPT
  }
 IF ( §care_about_mice == 1 )
 {
  GOSUB KILL_MICE
 }
 ACCEPT
}

//*******************************************************
ON DELATION {
 IF (§fighting_mode == 0) GOTO LOOK_FOR
ACCEPT
}

//*******************************************************
ON FLEE_END 
{
>>FLEE_END
	HERO_SAY -d "flee_end"
 IF ( §controls_off != 0 ) ACCEPT
 IF (§fighting_mode == 2) 
 {
  SET §fighting_mode 3
  SET_EVENT HEAR ON
  SET_EVENT COLLIDE_NPC ON
  IF (§player_in_sight == 1) GOTO ATTACK_PLAYER
  BEHAVIOR FRIENDLY
  SETTARGET PLAYER
 }
 ACCEPT
}

//*******************************************************
ON AGRESSION
{
herosay -d "on agression"
// GOTO OUCHSUITE
 GOTO OUCH_START
 ACCEPT
}

//********************************
ON TARGET_DEATH 
{
 IF ( §care_about_mice == 1 )
 {
  GOSUB MICE_DEATH
 }
 IF (^SENDER == "PLAYER") 
 {
  SET §enemy 0
  SET §fighting_mode 0
  IF (^$PARAM1 == ^ME ) 
  {
   SPEAK -a ~£victory~ NOP
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
 SET £last_heard "NOHEAR"
 SET_EVENT AGRESSION ON
 SET_EVENT HEAR ON
 SET §fighting_mode 0
 SET §spoted 0
 IF (§looking_for == 3) 
 {
  SENDEVENT SPEAK_NO_REPEAT SELF "3 A £justyouwait"
 }
 SET §looking_for 0
 SET §reflection_mode 1
herosay -d "WEAPON OFF"
 WEAPON OFF
 GOSUB RESTORE_BEHAVIOR
 IF (£init_marker != "NONE")
 { // back to home...
  BEHAVIOR MOVE_TO
  SETTARGET -a ~£init_marker~
  SETMOVEMODE WALK
 }
 SET_NPC_STAT BACKSTAB 1
ACCEPT

//********************************
ON CALL_HELP 
{
 IF ( §controls_off != 0 ) ACCEPT
 IF (§sleeping == 1) ACCEPT
 SET §noise_heard 2
 IF (§player_in_sight == 1) GOTO ATTACK_PLAYER
 IF (^DIST_PLAYER < 500) GOTO ATTACK_PLAYER
 IF (§fighting_mode != 0) ACCEPT
 SET §enemy 1
 SET §panicmode 1
 SET §reflection_mode 0
 SET £helping_target ^SENDER
 GOSUB SAVE_BEHAVIOR
 BEHAVIOR MOVE_TO
 SETTARGET -na ~£helping_target~
 SETMOVEMODE RUN
 ACCEPT
}

//********************************
ON STEAL 
{
 IF (^$PARAM1 == "OFF") 
 {
   TIMERsteal OFF
   ACCEPT
 }
 IF ( §controls_off != 0 ) ACCEPT
 IF (§player_in_sight == 1) 
 {
  SPEAK -a ~£thief~ NOP
  TIMERsteal 1 5 GOTO ATTACK_PLAYER
  ACCEPT
 }
 ACCEPT
}

//********************************
ON LOOKME 
{
 IF (^$PARAM2 == "a") BEHAVIOR -a FRIENDLY
 ELSE BEHAVIOR FRIENDLY
 IF (^$PARAM1 == "PLAYER") SETTARGET PLAYER
 ELSE SETTARGET ^SENDER
 ACCEPT
}

//********************************
ON OTHER_REFLECTION
{ // someone has spoken 
  SET §last_reflection ^GAMESECONDS
  ACCEPT
}

//********************************
ON MISC_REFLECTION 
{
  // no reflection
  IF ( §reflection_mode == 0 ) ACCEPT
  IF ( #SHUT_UP == 1 ) ACCEPT // cinematics

  IF ( §reflection_mode == 2 )
  { // in fighting mode -> more reflections
   SET #TMP ~^RND_10~
   INC #TMP 3
  }
  ELSE
  { 
   SET #TMP ~^RND_40~
   INC #TMP 5
  }

	IF( "undead" ISIN £type )
	{
		HERO_SAY -d "undead misc"
		DIV #TMP 2
	}
	
  // set next reflection timer
  TIMERmisc_reflection OFF
  TIMERmisc_reflection -i 0 ~#TMP~ SENDEVENT MISC_REFLECTION SELF ""

  IF (§reflection_mode == 1) 
  {
    SENDEVENT SPEAK_NO_REPEAT SELF "10 N £misc"
  }
  ELSE
  {
   IF (§reflection_mode == 2) 
   {
    SENDEVENT SPEAK_NO_REPEAT SELF "3 A £threat"
   }
   ELSE
   {
    SENDEVENT SPEAK_NO_REPEAT SELF "3 N £search"
   }
  }
  ACCEPT
}

ON PATHFINDER_FAILURE {
 HEROSAY -d "Pathfinder failure"
 IF( §failed_path == 0 )
 {
  HEROSAY -d "first failure"
	//POPUP first_failure
  IF( §fighting_mode == 0 )
  {
   BEHAVIOR MOVE_TO
  } ELSE 
    IF( §fighting_mode == 1 )
    {
     BEHAVIOR -f MOVE_TO
    }
    ELSE BEHAVIOR FLEE 1000
  		    
  SETTARGET ^TARGET
  SET §failed_path 1
  ACCEPT
 }

 HEROSAY -d "another failure"
 SET §failed_path 0
 GOTO GO_HOME
 ACCEPT
}
// -------------------------------------------------------------------------------
// MAIN CLEVER INCLUDE END -------------------------------------------------------
// -------------------------------------------------------------------------------


//********************************

ON DIE {
 GOSUB CALL_FOR_HELP
 TIMERmisc_reflection OFF
 TIMERspell_decision OFF
 FORCEANIM DIE
 SPEAK ~£dying~ COLLISION OFF
 IF (£type == "human_ylside") SPECIALFX YLSIDE_DEATH
 IF( £type == "ratmen" ) INVENTORY ADDMULTI "Jewelry\\Gold_coin\\Gold_coin" ~§stealed_gold~
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
