ON INIT {
 SETGROUP UNDEAD
 
TIMERmisc_reflection -i 0 5 SENDEVENT MISC_REFLECTION SELF ""

//#init
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
 SET §ouch_tim 0
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
 SETDETECT 40
 SET §door_locked_attempt 0	// the number of attempt at passing a locked door
// ---------------------------------------------------------------------------------
// INIT INCLUDE END ----------------------------------------------------------------
// ---------------------------------------------------------------------------------

//#
 PHYSICAL RADIUS 30
 PHYSICAL HEIGHT 200
 SET_NPC_STAT reach 20
 SET_NPC_STAT RESISTMAGIC 70
 SET_NPC_STAT RESISTPOISON 100
 SET_NPC_STAT RESISTFIRE 70
 SET_NPC_STAT armor_class 12
 SET_NPC_STAT absorb 40
 SET_NPC_STAT damages 12
 SET_NPC_STAT tohit 20
 SET_NPC_STAT aimtime 500
 SET_NPC_STAT life 120
 SET_XP_VALUE 800
 SET_NPC_STAT mana 2000
 INVENTORY CREATE
 SETNAME [description_lyche]
 SETIRCOLOR 1.0 0.9 0.0
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_shoe
 SET_BLOOD 0.1 0.9 0.1
 SET §enemy 0                   //defines if uhe NPC is enemy to the player at the moment
 SET §panicmode 0               //when = 0, the NPC is not sure if he saw the player "did that thing move over there ?"
 SET §care_about_mice 0         //this is a specific function to gobs, when = 1, they attack mices, obviously, we set it to 0 when they attack the player, or when they have more important things to do.
 SET §tactic 0                  //0 = normal    1 = sneak   2 = rabit  3 = caster
 SET §current_tactic §tactic    //used to restore previous tactic after a repel undead
 SET §cowardice 0               //if life < cowardice, NPC flees
 SET §confusability 9           // level of magic needed to confuse this npc
 SET §pain 10                    //if damage < pain , no hit anim
 SET §low_life_alert 10         //set the value for the npc heals himself
 SET £type "undead_lich"
//**CASTERS ONLY
 TIMERspell_decision -i 0 4 SENDEVENT SPELLDECISION SELF ""
 SET §casting_lvl 9            //set level of casting, any NPC = 0, highpriests = 3, snakewom = 6, lich = 10
 SET §spell_ready 1            //to remove later, to simulate the spell system
 LOADANIM CAST_START                 "liche_castspell_in"
 LOADANIM CAST_CYCLE                 "liche_castspell_cycle"
 LOADANIM CAST                       "liche_castspell_cast"
 LOADANIM CAST_END                   "liche_castspell_out"  //un de trop ?
//** END CASTERS ONLY
 LOADANIM WALK_SNEAK                 "liche_fight_walk"
 loadanim BARE_READY                 "liche_castspell_in"
 loadanim BARE_UNREADY               "liche_castspell_out"
 loadanim BARE_WAIT                  "liche_fight_wait_toponly"
 loadanim BARE_STRIKE_LEFT_START     "liche_fight_attack_left_start"
 loadanim BARE_STRIKE_LEFT_CYCLE     "liche_fight_attack_left_cycle"
 loadanim BARE_STRIKE_LEFT           "liche_fight_attack_left_strike"
 loadanim BARE_STRIKE_RIGHT_START    "liche_fight_attack_right_start"
 loadanim BARE_STRIKE_RIGHT_CYCLE    "liche_fight_attack_right_cycle"
 loadanim BARE_STRIKE_RIGHT          "liche_fight_attack_right_strike"
 loadanim BARE_STRIKE_TOP_START      "liche_fight_attack_left_start"
 loadanim BARE_STRIKE_TOP_CYCLE      "liche_fight_attack_left_cycle"
 loadanim BARE_STRIKE_TOP            "liche_fight_attack_left_strike"
 loadanim BARE_STRIKE_BOTTOM_START   "liche_fight_attack_right_start"
 loadanim BARE_STRIKE_BOTTOM_CYCLE   "liche_fight_attack_right_cycle"
 loadanim BARE_STRIKE_BOTTOM         "liche_fight_attack_right_strike"
 LOADANIM GRUNT                      "liche_fight_grunt"
 loadanim FIGHT_STRAFE_RIGHT         "liche_strafe_right"
 loadanim FIGHT_STRAFE_LEFT          "liche_strafe_left"
 LOADANIM WALK                       "liche_normal_walk"
 LOADANIM RUN                        "human_normal_run"
 LOADANIM WAIT                       "liche_normal_wait"
 LOADANIM HIT                        "liche_receive_damage"
 LOADANIM HIT_SHORT                  "liche_hit_short"
 LOADANIM DIE                        "liche_death"
 LOADANIM TALK_NEUTRAL               "human_talk_angry_headonly"
 LOADANIM TALK_HAPPY                 "human_talk_angry_headonly"
 LOADANIM TALK_ANGRY                 "human_talk_angry_headonly"
 loadanim FIGHT_WALK_FORWARD         "liche_fight_walk"
 loadanim FIGHT_WALK_BACKWARD        "liche_fight_walk_back"
 loadanim FIGHT_WAIT                 "liche_fight_wait"
 SET £hail []
 SET £thief []
 SET £strike []
 SET £victory []
 SET £whogoesthere []
 SET £heardnoise []
 SET £back2guard []
 SET £misc []
 SET £threat [Liche_threat]
 SET £search []
 SET £youmad []
 SET £dying []
 SET £ouch [liche_ouch]
 SET £ouch_medium [liche_ouchM]
 SET £ouch_strong [liche_ouchS]
 SET £help []
 SET £comeback []
 SET £justyouwait []
 ACCEPT
}

ON INITEND {
 IF (§enemy == 1) SET_EVENT HEAR ON
 TIMERmain -i 0 2 GOTO MAIN_ALERT
// SET_MAIN_EVENT MAIN_ALERT //maybe this should be put in the local script...
 IF ( £friend != "NONE" ) SETGROUP £friend
 SET §scale 95
 SET #TMP ~^RND_10~
 INC §scale #TMP
 SETSCALE §scale
  HALO -oncs 0.8 0.8 0.8 30
 // HALO -c 1 1 1
 ACCEPT
}


//********************START*****************************


//********************************
//* specific section to this NPC *
//********************************

>>MAIN_ALERT 
 IF (#REPEL > 5) SET §tactic 2
 IF (#REPEL < 5) SET §tactic 0
 IF (^DIST_PLAYER < 500) {
  IF (§tactic == 2) GOTO FLEE
  SENDEVENT DETECTPLAYER SELF ""
  ACCEPT
 }
ACCEPT


ON COMBINE {
 IF (§dead == 0) ACCEPT
 IF (£type == "undead_base") {
  IF (^$PARAM1 ISCLASS "STAKE") {
   HEROSAY -d "Undead destroyed"
   TWEAK SKIN "item_stake" "item_stake"
  }
  ACCEPT
 }
 ACCEPT
}

//****************************************
//* END of specific section for this NPC *
//****************************************

//************************
//*   MAGIC              *
//************************
//#spellcaster
//----------------------------------------------------------------------------------
// SPELLCASTER INCLUDE START -------------------------------------------------------
//----------------------------------------------------------------------------------

>>SPELL_CASTED
 SET §spell_ready 0
 TIMERspellready 1 5 SET §spell_ready 1 
ACCEPT

ON COLLIDE_FIELD {
  IF (§casting_lvl == 0) ACCEPT
  IF (§spell_ready == 0) ACCEPT
  IF (§disp_field == 1) ACCEPT
  SET §disp_field 1
  TIMERdispfield 1 20 SET §disp_field 0
  SPELLCAST -f §casting_lvl DISPELL_FIELD PLAYER
  herosay -d "Dispell field"
  GOTO SPELL_CASTED
 ACCEPT
}

//*******************************************************
ON SPELLDECISION 
{
 IF (#SHUT_UP == 1) ACCEPT // pas de sorts pendant les cine !
 IF (§spell_ready == 0) ACCEPT
 IF (#NEGATE >= §casting_lvl) ACCEPT
 IF (^MYSPELL_INVISIBILITY == 1) ACCEPT
 IF (^MYSPELL_MANA_DRAIN == 1) ACCEPT
 IF (^MYSPELL_LIFE_DRAIN == 1) ACCEPT
 IF (^MYSPELL_HARM == 1) ACCEPT
 IF (^MANA < 10) ACCEPT
 SET #TMP ~^RND_10~
 INC #TMP 1
 IF (£type ISIN "snake_womanundead_lich") {
  IF (^PLAYERSPELL_FIREBALL == 1) {
   IF (§enemy == 0) ACCEPT
   IF (^DIST_PLAYER > 2000) ACCEPT
   IF (#TMP < 6) {
    SPELLCAST -f §casting_lvl DOUSE SELF
    herosay -d "Douse !"
    GOTO SPELL_CASTED
   }
   SPELLCAST -fd 10000 §casting_lvl FIRE_PROTECTION SELF
   herosay -d "Fire Protection"
   GOTO SPELL_CASTED
  }
  IF ( ^PLAYERSPELL_ICE_PROJECTILE == 1 ) {
   IF (#TMP < 5) {
    IF (§enemy == 0) ACCEPT
    IF (^DIST_PLAYER > 2000) ACCEPT
    SPELLCAST -f §casting_lvl COLD_PROTECTION
    herosay -d "Cold protection"
    GOTO SPELL_CASTED
   }
  }
 } 
>>SPELL_SUITE
 IF (^POISONED > 5) 
 {
  SPELLCAST -f §casting_lvl CURE_POISON SELF
  herosay -d "Cure poison"
  GOTO SPELL_CASTED
  accept
 }
 IF (^LIFE < §low_life_alert) 
 {
  IF (£type == "undead_lich") 
  {  
   SPELLCAST -fd 6500 §casting_lvl LIFE_DRAIN PLAYER
   herosay -d "drain life"
  }
  ELSE
  {
   IF (§freehealing > 1) ACCEPT
   SPELLCAST -f §casting_lvl HEAL SELF
   IF (£type ISIN "human_priest_highfelnor") INC §freehealing 1
   herosay -d "heal"
  }
  GOTO SPELL_CASTED
 }

 // Life is ok
 IF (£type ISIN "snake_womanundead_lichhuman_priest_highfelnor") {
  IF (§fighting_mode == 2) {
  //fleeing 
   IF (^MYSPELL_INVISIBILITY == 0) {
    SPELLCAST -fd 15000 §casting_lvl INVISIBILITY SELF
    herosay -d "invisibility"
    GOTO SPELL_CASTED
   }
  }
  IF (§looking_for == 2) {
   IF (^MYSPELL_DISPELL_ILLUSION == 0) 
   {
    SPELLCAST -fd 3000 §casting_lvl DISPELL_ILLUSION PLAYER
herosay -d "dispell illusion"
    GOTO SPELL_CASTED
   }
  }
 }

 // FIGHT !!! 
 IF (§fighting_mode == 1) {
  // HUMAN PRIEST ----------------------------------------------
  IF (£type ISIN "felnorhuman_priest_high") {
   IF (§player_in_sight == 1) {
    IF ( ^#PLAYERDIST > 250 ) {
     SPELLCAST -f §casting_lvl MAGIC_MISSILE PLAYER
     GOTO SPELL_CASTED
    }
   }
   IF (#TMP < 8) {
    SPELLCAST -fd 5000 §casting_lvl FIRE_FIELD PLAYER
    GOTO SPELL_CASTED
   }
   IF (^MYSPELL_ARMOR == 0) {
    SPELLCAST -fd 20000 §casting_lvl ARMOR SELF
    herosay -d "armor"
    GOTO SPELL_CASTED
   }   

   IF (^MYSPELL_HARM == 0) 
   {
    SPELLCAST -fd 10000 §casting_lvl HARM SELF
    GOTO SPELL_CASTED
   }
   
   ACCEPT
  }
  // SNAKEWOMAN ----------------------------------------------
  IF (£type == "snake_woman") {
   IF (§player_in_sight == 1) {
    IF ( ^#PLAYERDIST > 600 ) {
     IF (#TMP < 6) {
      SPELLCAST -f §casting_lvl MAGIC_MISSILE PLAYER
      GOTO SPELL_CASTED
     }
     SPELLCAST -f §casting_lvl POISON_PROJECTILE PLAYER
     herosay -d "poison projectile"
     GOTO SPELL_CASTED
    }
    IF (#TMP < 5) {
     herosay -d "lightning strike"
     SPELLCAST -f §casting_lvl LIGHTNING_STRIKE PLAYER
     GOTO SPELL_CASTED
    }
    IF (#TMP < 3) {
     SPELLCAST -df 10000 §casting_lvl MANA_DRAIN SELF
     herosay -d "mana drain"
     GOTO SPELL_CASTED
    }
    herosay -d "fire ball"
    SPELLCAST -f §casting_lvl FIREBALL PLAYER
    GOTO SPELL_CASTED
   }
   // player not in sight....
   IF (^MYSPELL_LOWER_ARMOR == 0) {
    IF (#TMP < 4) {
     herosay -d "lower armor"
     SPELLCAST -f §casting_lvl LOWER_ARMOR PLAYER
     GOTO SPELL_CASTED
    }
   }
   IF (^MYSPELL_SPEED == 0) {
    IF (#TMP < 4) {
     herosay -d "speed up"
     SPELLCAST -fd 10000 §casting_lvl SPEED SELF
     GOTO SPELL_CASTED
    }
   }
   IF (^MYSPELL_LIFE_DRAIN == 0) {
    herosay -d "lifedrain"
    SPELLCAST -fd 10000 §casting_lvl LIFE_DRAIN PLAYER
//    SPELLCAST -fd 10000 §casting_lvl HARM SELF
    GOTO SPELL_CASTED
   }
   ACCEPT
  }
  // LICHE ---------------------------------------------------
  IF (£type == "undead_lich") {
   IF (^MYSPELL_RAISE_DEAD == 0) {
     IF (#TMP < 6) {
      SPELLCAST -fd 25000 §casting_lvl RAISE_DEAD PLAYER
      herosay -d "RAISE DEAD"
      GOTO SPELL_CASTED
     }
    }
   IF (§player_in_sight == 1) 
   {
    IF (#TMP < 3) {
     SPELLCAST -f §casting_lvl POISON_PROJECTILE PLAYER
     herosay -d "poison projectile"
     GOTO SPELL_CASTED
    }
    IF (#TMP < 6) {
     SPELLCAST -f §casting_lvl LIGHTNING_STRIKE PLAYER
     herosay -d "lightning"
     GOTO SPELL_CASTED
    }
    IF (#TMP < 9) {
     SPELLCAST -fd 8000 §casting_lvl SLOWDOWN PLAYER
     herosay -d "slow down player"
     GOTO SPELL_CASTED
    }
    IF (^DIST_PLAYER > 1200) GOTO PARALSUITE
    IF (§paralplayer == 1) GOTO PARALSUITE
    SPELLCAST -fd 8000 §casting_lvl PARALYSE PLAYER
    SET §paralplayer 1
    TIMERparal 1 20 SET §paralplayer 0
    herosay -d "paralyse player"
    GOTO SPELL_CASTED
   }
   // player not in sight ....
>>PARALSUITE
   IF (#TMP < 7) {
    IF (^MYSPELL_INVISIBILITY == 0) {
     SPELLCAST -fd 12000 §casting_lvl INVISIBILITY SELF
     herosay -d "invisibility"
     GOTO SPELL_CASTED
    }
   }
   IF (^MYSPELL_CURSE == 0) {
    SPELLCAST -fd 8000 §casting_lvl CURSE PLAYER
    herosay -d "curse player"
    GOTO SPELL_CASTED
   }
  }
  ACCEPT
 }
 ACCEPT
}

//----------------------------------------------------------------------------------
// SPELLCASTER INCLUDE END ---------------------------------------------------------
//----------------------------------------------------------------------------------


//#

//#spell_reaction

//----------------------------------------------------------------
// SPELL_REACTION INLCUDE START ----------------------------------
//----------------------------------------------------------------

ON SPELLCAST 
{
 IF( #SHUT_UP == 1 ) ACCEPT // pas de spell pendant les cine !!
 IF (^SENDER != PLAYER) ACCEPT
 IF (§casting_lvl != 0) {
  IF (^$PARAM1 == NEGATE_MAGIC) {
   SET #NEGATE ^#PARAM2
   ACCEPT
  }
 }
 IF ( SELF ISGROUP UNDEAD )
 {
  IF (^$PARAM1 == REPEL_UNDEAD)
  {
  SET #REPEL ^#PARAM2
   IF (£type == "undead_lich")
   {
    IF (^#PARAM2 < 6)
    {
     HERO_SAY -d "pas assez fort, mon fils"
     ACCEPT
    }
   }
    GOTO REPEL
  }
 }
 IF (^$PARAM1 == CONFUSE) {
  IF (^#PARAM2 < §confusability) ACCEPT
  SENDEVENT UNDETECTPLAYER SELF ""
  SET §confused 1
  ACCEPT
 }
 IF (§enemy == 0) ACCEPT
 IF (£type == "human_ylside") ACCEPT
 IF (£type == "undead_lich") ACCEPT
 IF (^$PARAM1 == HARM) {
  IF (^PLAYER_LIFE < 20) ACCEPT 
  GOTO NO_PAIN_REPEL
 }
 IF (^$PARAM1 == LIFE_DRAIN) {
  IF (^PLAYER_LIFE < 20) ACCEPT 
  GOTO NO_PAIN_REPEL
 }
 IF (^$PARAM1 == MANA_DRAIN) {
  IF (§casting_lvl == 0) ACCEPT
  IF (^PLAYER_LIFE < 20) ACCEPT 
  GOTO NO_PAIN_REPEL
 }
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
 set §fighting_mode 0
 IF ( §enemy == 1 ) GOTO ATTACK_PLAYER
 ACCEPT
//********************************


ON _PELLEND 
{
 IF (^SENDER != PLAYER) ACCEPT
 IF (§casting_lvl != 0) {
  IF (^$PARAM1 == NEGATE_MAGIC) {
   SET #NEGATE 0
   ACCEPT
  }
 }
 IF ( SELF ISGROUP UNDEAD )
 {
  IF (^$PARAM1 == REPEL_UNDEAD) {
   SET #REPEL 0
  }
 }
 IF (^$PARAM1 == CONFUSE) {
  SET §confused 0
  ACCEPT
 }
 IF (§enemy == 0) ACCEPT
 IF (£type == "human_ylside") ACCEPT
 IF (£type == "undead_lich") ACCEPT
 IF (^$PARAM1 == HARM) GOTO END_PAIN_REPEL
 IF (^$PARAM1 == LIFE_DRAIN) GOTO END_PAIN_REPEL
 IF (^$PARAM1 == MANA_DRAIN) GOTO END_REPEL
ACCEPT
}
//----------------------------------------------------------------
// SPELL_REACTION INLCUDE END  -----------------------------------
//----------------------------------------------------------------

//#

//************************
//*   MAGIC END          *
//************************


ON CHAT {
 IF (§enemy == 1) SENDEVENT DETECTPLAYER SELF ""
 ACCEPT
}

//#behavior

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
 TIMERcolplayer OFF 
// to avoid TIMERcolplayer to restore the behavior 1 sec later
 IF (§main_behavior_stacked == 0) 
 {
  IF (§frozen == 1)
  { 
// frozen anim -> wake up !
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


//#main_clever
// -------------------------------------------------------------------------------
// MAIN CLEVER INCLUDE START -----------------------------------------------------
// -------------------------------------------------------------------------------

ON GAME_READY {
 SET_EVENT COLLIDE_NPC ON
 IF (§casting_lvl != 0) SET #NEGATE 0
 IF (SELF ISGROUP UNDEAD) {
  SET §paralplayer 0
  SET #REPEL 0
 }
 IF (£type ISIN "human_priest_highfelnor") SET §freehealing 0 //for priests healing too much
 ACCEPT
}

ON RELOAD {
 IF (SELF ISGROUP "kingdom") {
  IF (#PLAYER_ON_QUEST == 6) {
   SET §reflection_mode 0
   OBJECT_HIDE SELF YES
   ACCEPT
  }
  IF (#PLAYER_ON_QUEST == 7) {
   SET §reflection_mode 1
   OBJECT_HIDE SELF NO
  }
 }
 IF (£type == "human_guard_ss") {
  IF (#DISSIDENT_ENEMY == 1) SET §enemy 1
  IF (#weapon_enchanted == 1) {
   IF (§dead == 1) ACCEPT
   TELEPORT ~£dying_marker~
   SET £dying []
   SETGROUP -r £friend
   SET £friend "NONE"
   FORCEDEATH SELF
   ACCEPT
  }
  IF (§enemy == 1) {
   IF (#weapon_enchanted == 2) OBJECT_HIDE -m SELF YES
   ACCEPT
  }
 }
 IF (§totaldead == 0) { 
  IF (§fighting_mode > 0) {
   IF (£init_marker != "NONE") TELEPORT ~£init_marker~
   IF (£init_marker == "NONE") TELEPORT -i
  // WEAPON OFF
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
 IF ( §controls_off == 0 ) ACCEPT
 SET §controls_off 0
 SET §reflection_mode §saved_reflection
 SET #SHUT_UP 0
 IF (§enemy == 0) ACCEPT
 IF (§frozen == 1) ACCEPT
 COLLISION ON
 BEHAVIOR UNSTACK
 ACCEPT
}

ON CONTROLS_OFF
{
 SET §controls_off 1
 SET §saved_reflection §reflection_mode
 SET §reflection_mode 0
 SET #SHUT_UP 1
 IF (§enemy == 0) ACCEPT
 IF (§frozen == 1) ACCEPT
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
 IF (^SENDER != PLAYER) ACCEPT
 IF (§controls_off != 0 ) ACCEPT
 IF (§fighting_mode == 2) ACCEPT
 IF (^PLAYER_SKILL_STEALTH > 50) {
  IF (§fighting_mode != 1) STEAL_NPC
 }
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
 if (^DIST_PLAYER < 200) accept
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
herosay -d "detect"
>>PLAYER_DETECTED
 IF ( §controls_off != 0 ) ACCEPT
 // IF (§player_in_sight == 1) ACCEPT
 IF ( SELF ISGROUP UNDEAD ) {
 // TIMERmain OFF
 }
 IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT
 IF (§confused == 1) ACCEPT
 SET §player_in_sight 1
 SET_NPC_STAT BACKSTAB 0

 IF (§enemy == 0) ACCEPT
 IF (§fighting_mode == 2) ACCEPT
 IF (§sleeping == 1) ACCEPT
 IF (§panicmode > 0) GOTO ATTACK_PLAYER
 IF (^DIST_PLAYER < 600) GOTO ATTACK_PLAYER

 TIMERdoubting 1 3 GOTO ATTACK_PLAYER
 SET §panicmode 2  // this sets the NPC in doubting mode 
 SET §noise_heard 2
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
IF (§confused == 1) ACCEPT

 //-----[FLURE] if no noise during 2 minutes, reinit the ON HEAR
 SET #TMP ^GAMESECONDS
 DEC #TMP §snd_tim
 IF (#TMP > 120) {
   SET §noise_heard 2
   SET §snd_tim ^GAMESECONDS
 }
 //-----

 IF (§sleeping == 1) 
 {
  SET §sleeping 0
  ACCEPT
 }
 IF (§enemy == 0) {
  IF (§force_hear == 0) ACCEPT //to set to 1 in local scripts for sacred dagger
 }
 IF (§player_in_sight == 1) ACCEPT
 IF (§panicmode == 2) ACCEPT
 IF (§looking_for >= 1) GOTO ATTACK_PLAYER 	// [FLURE](§looking_for>=1)
 IF (§fighting_mode >= 1) GOTO PLAYER_DETECTED
 IF ( ^SENDER == PLAYER )
 {
  IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
 }
 IF (^SENDER == £last_heard) {
  SET #TMP ^GAMESECONDS
  DEC #TMP §snd_tim
  IF (#TMP < 2) ACCEPT
 // same sound source won't be heard during 2 seconds
 }
 TIMERheard OFF
 INC §noise_heard 1
 IF (§noise_heard > 3) GOTO PLAYER_DETECTED
 // 3 different sounds -> auto detect player
 SET £last_heard ^SENDER
 SET §snd_tim ^GAMESECONDS
 IF (§panicmode != 2) SET §panicmode 1
 SET §reflection_mode 0
 TIMERquiet OFF
 GOSUB SAVE_BEHAVIOR
 RANDOM 50 SPEAK -a ~£heardnoise~ NOP
 IF( §noise_heard == 1 ) {
  BEHAVIOR NONE
  SETTARGET NONE
  BEHAVIOR FRIENDLY
  SETTARGET ^SENDER
  HEROSAY -d "turning to face the sound"
  TIMERheard 1 6 SENDEVENT SPEAK_NO_REPEAT SELF "3 N £back2guard" GOSUB RESTORE_BEHAVIOR
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
 IF ( SELF ISGROUP ISGROUP UNDEAD )
 {
  TIMERmain -i 0 2 GOTO MAIN_ALERT
 }
 IF (§enemy == 0) SET_NPC_STAT BACKSTAB 1 ACCEPT
 IF (§panicmode == 2) 
 { 
// didn't find player
  TIMERdoubting OFF
  SET §panicmode 1
  TIMERabandon 1 5 GOTO GO_HOME
  TIMERquiet 1 6 SPEAK ~£back2guard~
 }
 IF (§fighting_mode != 1) ACCEPT
 SET_NPC_STAT BACKSTAB 1
 IF (^TARGET == PLAYER) 
 {
  IF (§looking_for == 0) 
  {
   IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
   IF (§confused == 1) GOTO LOOK_FOR_SUITE
   SET §looking_for 1
   SET §reflection_mode 0
   TIMERlookfor 1 3 GOTO LOOK_FOR
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
 IF (§player_in_sight == 1) GOTO ATTACK_PLAYER
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
    if ( #TMP > ^PLAYER_GOLD )
    {
     DIV #TMP 2
     GOTO TEST_PLAYER_GOLD
    }
   }
   
   ADD_GOLD -~#TMP~
   INC §stolen_gold #TMP
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
 SET $TMP " "
 SENDEVENT NPC_OPEN £targeted_door ~£key_carried~~$TMP~~§enemy~
 TIMERcloseit 1 4 SENDEVENT NPC_CLOSE £targeted_door ~£key_carried~
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
   IF (§fighting_mode == 2) SENDEVENT -gr ~£friend~ CALL_HELP 1200 ""
   ELSE SENDEVENT -gr ~£friend~ CALL_HELP 600 ""
   SET §last_call_help ^GAMESECONDS
  }
 }
RETURN

//*******************************************************
ON OUCH 
{
>>OUCH_START
 HEROSAY -d "OUCH"
 HEROSAY -d ^#PARAM1
 HEROSAY -d §pain
 // visualy react to ouch -------------
 IF (^#PARAM1 < §pain) 
 {
  IF (^PLAYERCASTING == 0) FORCEANIM HIT_SHORT
  IF (§enemy == 0) SPEAK [] NOP // no Pain !
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
  {
   RANDOM 50 {
    SPEAK -a ~£ouch_strong~ NOP
   }
  }
  ELSE
  {
   SET &TMP §pain
   MUL &TMP 2
   IF (^#PARAM1 >= &TMP) 
   {
    RANDOM 50 { 
     SPEAK -a ~£ouch_medium~ NOP
    }
   }
   ELSE
   {
    RANDOM 50 {
     SPEAK -a ~£ouch~ NOP
    }
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

  SET_EVENT AGGRESSION OFF
  SET §spoted 1 // OK, I've seen you !

  GOTO ATTACK_PLAYER_AFTER_OUCH
 }
 ACCEPT
}

//*******************************************************
>>ATTACK_PLAYER
 IF (^SPEAKING != 0) {
  IF (§enemy == 0) SPEAK [] NOP 	// to stop misc reflections
 } 
>>ATTACK_PLAYER_AFTER_OUCH
 SET §ignorefailure 0
 IF (^PLAYERSPELL_INVISIBILITY == 1) GOTO LOOK_FOR_SUITE
 TIMERlookfor OFF
 TIMERheard OFF
 SET §panicmode 1
 SET §looking_for 0
 SET §enemy 1
 CLOSE_STEAL_BAG
 SET_EVENT HEAR OFF
 //IF ( SELF ISGROUP UNDEAD ) TIMERmain OFF
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
 SET_NPC_STAT BACKSTAB 0	
 IF (^LIFE < §cowardice) GOTO FLEE		// low life
 IF (§fighting_mode == 2) ACCEPT		// fleeing
 IF (§fighting_mode == 1) 
 {
  SET §reflection_mode 2
  ACCEPT
 }
 IF ( £attached_object != "NONE" )
 {
  DETACH ~£attached_object~ SELF
  OBJECT_HIDE ~£attached_object~ ON
  SET £attached_object "NONE"
 }
 GOSUB SAVE_BEHAVIOR
 SENDEVENT MISC_REFLECTION SELF "" 		// to reset misc_reflection timer

 IF (§fighting_mode == 3) {
  IF (^LIFE < §cowardice) GOTO FLEE		// end of flee -> flee again
 }
 IF (§tactic == 2) GOTO FLEE 			// coward

 // start of fighting behavior
 IF ( §spoted == 0 )
 { 
// first time player is spotted HAIL !
  SET §spoted 1
//  SENDEVENT SPEAK_NO_REPEAT SELF "3 A £hail"
  SPEAK -a ~£hail~ NOP
 }
 SET §reflection_mode 2				// fight misc_ref
 SET §fighting_mode 1
 IF (£type == "human_ylside") GOSUB TRAMPLE_ATTACK
 IF (§tactic == 0) BEHAVIOR -f MOVE_TO
 IF (§tactic == 1) BEHAVIOR -fs MOVE_TO
 IF (§tactic == 3) BEHAVIOR -m MOVE_TO
 SETTARGET -a PLAYER
HEROSAY -d "WEAPON ON"
 WEAPON ON
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
   // SET #TMP ~^DIST_PLAYER~
   // INC #TMP 1000
   // IF (#TMP > 2500) SET #TMP 2500
   // BEHAVIOR FLEE #TMP
    BEHAVIOR FLEE 1000
    SETTARGET PLAYER
    SETMOVEMODE RUN
    IF (SELF ISGROUP UNDEAD) SETMOVEMODE WALK
  }
  ELSE {
    SENDEVENT PANIC £flee_marker ""
    BEHAVIOR MOVE_TO
    SETTARGET -a £helping_buddy
    SETMOVEMODE RUN
    IF (SELF ISGROUP UNDEAD) SETMOVEMODE WALK
  }

  GOSUB CALL_FOR_HELP				// call friends
  TIMERcoward 1 2 SENDEVENT SPEAK_NO_REPEAT SELF "5 A £help"
  TIMERhome 1 30 GOTO GO_HOME
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
 IF (§looking_for > 2) GOTO PLAYER_DETECTED //in case NPC already looking for
 IF ( §fighting_mode > 1 ) ACCEPT
 BEHAVIOR LOOK_FOR 500
 SETTARGET -a PLAYER
 SETMOVEMODE WALK
 SET §looking_for 2
 SET §fighting_mode 0
 SET_EVENT HEAR ON
 SET §reflection_mode 3
 TIMERhome 1 18 GOTO GO_HOME 	//[FLURE] TIMERhome 1 30 GOTO GO_HOME
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
   IF (§confused == 1) ACCEPT
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
  IF (§fighting_mode != 2) ACCEPT
  SENDEVENT -rn DELATION 500 ~£flee_marker~
  DIV §cowardice 2
  SET £helping_buddy "NOBUDDY" //ca ne marche qu'une fois
//newto test
  SET §reflection_mode 0
  SET £helping_target £flee_marker
  BEHAVIOR MOVE_TO
  SETTARGET -a £helping_target
  SETMOVEMODE RUN
//endnew to test sinon remettre GOTO FLEE_END
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
 IF (§fighting_mode != 0) ACCEPT
 SET £helping_target ^$PARAM1
 SET §noise_heard 2
 IF (§player_in_sight == 1) GOTO ATTACK_PLAYER
 IF (^DIST_PLAYER < 500) GOTO ATTACK_PLAYER
 GOSUB SAVE_BEHAVIOR
 SET §reflection_mode 0
 BEHAVIOR MOVE_TO
 SETTARGET -a £helping_target
 SETMOVEMODE RUN
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
  IF (£type == "human_guard_ss") {
    SET #DISSIDENT_ENEMY 1
    GOTO OUCH_START
    ACCEPT
  }
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
   SPEAK -oa ~£victory~ NOP
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
 SET_EVENT AGGRESSION ON
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
 SET_NPC_STAT BACKSTAB 1
ACCEPT

//********************************
ON CALL_HELP 
{
 IF ( §controls_off != 0 ) ACCEPT
 IF (§sleeping == 1) ACCEPT
 SET §noise_heard 2
 SET §panicmode 1
 IF (§player_in_sight == 1) GOTO ATTACK_PLAYER
 IF (^DIST_PLAYER < 500) GOTO ATTACK_PLAYER
 IF (§fighting_mode != 0) ACCEPT
 TIMER kill_local
 SET §enemy 1
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
  TIMERsteal 1 2 GOTO ATTACK_PLAYER
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
{ 
// someone has spoken 
  SET §last_reflection ^GAMESECONDS
  ACCEPT
}

//********************************
ON MISC_REFLECTION 
{
  IF (^POISONED > 0) {
   IF (§enemy == 1) ACCEPT
   SET §enemy 1
   GOTO OUCHSUITE
   ACCEPT
   }
  IF ( §reflection_mode == 0 ) ACCEPT
  IF ( #SHUT_UP == 1 ) ACCEPT // cinematics
  IF ( §reflection_mode == 2 )
  {
 // in fighting mode -> more reflections
   SET #TMP ~^RND_10~
   INC #TMP 3
  }
  ELSE
  { 
   SET #TMP ~^RND_32~
   INC #TMP 5
  }
  IF( "undead" ISIN £type )
  {
   DIV #TMP 2
  }
  // set next reflection timer
  TIMERmisc_reflection -i 0 ~#TMP~ SENDEVENT MISC_REFLECTION SELF ""

  IF (§reflection_mode == 1) 
  {
   IF (£misc == "[]") ACCEPT
   IF (§short_reflections == 1) {
    RANDOM 50 SENDEVENT SPEAK_NO_REPEAT SELF "6 N [Human_male_misc_short]" ACCEPT
   }
   SENDEVENT SPEAK_NO_REPEAT SELF "10 N £misc"
  }
  ELSE
  {
   IF (§reflection_mode == 2) 
   {
    IF (£threat == "[]") ACCEPT
    SENDEVENT SPEAK_NO_REPEAT SELF "3 A £threat"
   }
   ELSE
   {
    IF (£search == "[]") ACCEPT
    SENDEVENT SPEAK_NO_REPEAT SELF "3 N £search"
   }
  }
  ACCEPT
}

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
// -------------------------------------------------------------------------------
// MAIN CLEVER INCLUDE END -------------------------------------------------------
// -------------------------------------------------------------------------------
 
//#

//********************************

//#die_clever
ON DIE {
 SETEVENT CHAT OFF
 GOSUB CALL_FOR_HELP
 TIMERmisc_reflection OFF
 TIMERspell_decision OFF
 FORCEANIM DIE
 IF (#SHUT_UP == 0) SPEAK ~£dying~ NOP
 COLLISION OFF
 SETDETECT -1
 SET §totaldead 1
 IF (£type == "human_ylside") {
  TIMERsnd 1 1 PLAY "YLSIDE_DEATH"
  SPECIALFX YLSIDE_DEATH
  IF (^MYSPELL_SPEED == 1) SPELLCAST -k SPEED
  ACCEPT
 }
 IF (£type == "undead_lich") {
  IF (^MYSPELL_RAISE_DEAD == 1) SPELLCAST -k RAISE_DEAD
 }
 IF( £type == "ratmen" ) {
   IF (§stolen_gold == 0) ACCEPT
   INVENTORY ADDMULTI "Jewelry\\Gold_coin\\Gold_coin" ~§stolen_gold~
   ACCEPT
 }
 ACCEPT
}
ON SPELLEND 
{
 IF (^SENDER != PLAYER) ACCEPT
 IF (§casting_lvl != 0) {
  IF (^$PARAM1 == NEGATE_MAGIC) {
   SET #NEGATE 0
   ACCEPT
  }
 }
 IF ( SELF ISGROUP UNDEAD )
 {
  IF (^$PARAM1 == REPEL_UNDEAD) {
   SET #REPEL 0
  }
 }
 IF (^$PARAM1 == CONFUSE) {
  SET §confused 0
  ACCEPT
 }
 IF (§enemy == 0) ACCEPT
 IF (§fighting_mode != 2) {
  SET §tactic §current_tactic
  ACCEPT 
 }
 IF (£type == "human_ylside") ACCEPT
 IF (£type == "undead_lich") ACCEPT
 IF (^$PARAM1 == HARM) GOTO END_PAIN_REPEL
 IF (^$PARAM1 == LIFE_DRAIN) GOTO END_PAIN_REPEL
 IF (^$PARAM1 == MANA_DRAIN) GOTO END_REPEL
ACCEPT
} 
//#

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
