>>TRAMPLE_ATTACK
 IF (^MYSPELL_SPEED == 1) RETURN
 TIMERflash 1 2 SPELLCAST -smdf 20000 10 SPEED SELF
 TIMERspeedagain 1 4 SPELLCAST -smdf 10000 10 SPEED SELF
 RETURN

ON INIT {
 SETGORE OFF
 SET £voice ""     //possible combo are _vb _vc (for guards)
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
 SETSTAREFACTOR 0.4
 PHYSICAL RADIUS 30
 SET_NPC_STAT reach 20
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL LEATHER
 SET_STEP_MATERIAL Foot_shoe
// SET_BLOOD 0.9 0.1 0.1
 SET_NPC_STAT RESISTMAGIC 10
 SET_NPC_STAT RESISTPOISON 10
 SET_NPC_STAT RESISTFIRE 10
 INVENTORY CREATE
 SETIRCOLOR 0.8 0.0 0.0
 SET §panicmode 0               //when = 0, the NPC is not sure if he saw the player "did that thing move over there ?"
 SET §enemy 0                   //defines if the NPC is enemy to the player at the moment
 SET §care_about_mice 0         //this is a specific function to gobs, when = 1, they attack mices, obviously, we set it to 0 when they attack the player, or when they have more important things to do.
 SET §tactic 0                  //0 = normal    1 = sneak   2 = rabit  3 = caster
 SET §casting_lvl 0		  //set level of casting, the higher, the better
 SET §cowardice 8
 SET §confusability 4           // level of magic needed to confuse this npc
 SET §pain 2
 SET §low_life_alert 15         //set the value for the npc heals himself
 SET £friend "human_kingdom"
 SET £type "human_villager"
 ACCEPT
}

ON INITEND {
//#belongings
 
 // removed for now

//#

 IF ( §care_about_mice == 1 )
 {
   SETGROUP MICECARE
 }
 IF (§enemy == 1) SET_EVENT HEAR ON
 SET §scale 98
 SET §rnd ~^RND_4~
 INC §scale §rnd
 SETSCALE §scale
 LOADANIM WALK_SNEAK                 "human_walk_sneak"    //*****************  NEW
 LOADANIM CAST_START                 "human_npc_cast_start"
 LOADANIM CAST_CYCLE                 "human_npc_cast_cycle"
 LOADANIM CAST                       "human_npc_cast_cast"
 LOADANIM CAST_END                   "human_npc_cast_end"
//LOADANIM CAST_HOLD                 "human_npc_cast_hold"
 LOADANIM WALK                       "human_normal_walk_guard"
 LOADANIM RUN                        "Human_normal_run"
 LOADANIM WAIT                       "Human_normal_wait"
 LOADANIM HIT                        "Human_fight_receive_damage"
 LOADANIM HIT_SHORT                  "human_hit_short"
 LOADANIM DIE                        "Human_death"
 LOADANIM TALK_NEUTRAL               "human_talk_neutral_headonly"
 LOADANIM TALK_ANGRY                 "human_talk_angry_headonly"
 LOADANIM TALK_HAPPY                 "human_talk_happy_headonly"
 LOADANIM GRUNT                      "human_fight_grunt"
 loadanim FIGHT_WAIT                 "human_fight_wait"
 loadanim FIGHT_WALK_FORWARD         "human_fight_walk"
 loadanim FIGHT_WALK_BACKWARD        "human_fight_walk_backward"
 loadanim FIGHT_STRAFE_RIGHT         "human_fight_strafe_right"
 loadanim FIGHT_STRAFE_LEFT          "human_fight_strafe_left"
 loadanim BAE_READY                  "human_fight_ready_noweap"
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
 loadanim 1H_READY_PART_1            "human_fight_ready_1handed_start"
 loadanim 1H_READY_PART_2            "human_fight_ready_1handed_end"
 loadanim 1H_UNREADY_PART_1          "human_fight_unready_1handed_start"
 loadanim 1H_UNREADY_PART_2          "human_fight_unready_1handed_end"
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
 IF (£type == "human_villager") 
 {
  SETNAME [description_human_male]
  SET_NPC_STAT armor_class 8
  SET_NPC_STAT absorb 10
  SET_NPC_STAT damages 5
  SET_NPC_STAT tohit 30
  SET_NPC_STAT aimtime 1000
  SET_NPC_STAT life 32
  SET_XP_VALUE 40
  SET §short_reflections 1
  SET £hail []
  SET £thief [human_male_thief]
  SET £strike [human_male_striking]
  SET £victory []
  SET £whogoesthere []
  SET £heardnoise []
  SET £back2guard []
  SET £misc [human_male_misc]
  SET £threat []
  SET £search []
  SET £youmad []
  SET £dying [human_male_dying]
  SET £ouch [human_male_ouch]
  SET £ouch_medium [human_male_ouch_medium]
  SET £ouch_strong [human_male_ouch_strong]
  SET £help [human_male_help]
  SET £comeback []
  SET £justyouwait []
  TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
 }
 IF (£type == "human_female_base") 
 {
  LOADANIM WALK        "human_woman_normal_walk"
  LOADANIM RUN         "human_woman_normal_run"
  LOADANIM WAIT        "human_woman_normal_wait"
  LOADANIM HIT         "human_fight_receive_damage"
  LOADANIM DIE         "human_woman_death"
  SETNAME [description_human_female]
  SET_NPC_STAT armor_class 3
  SET_NPC_STAT absorb 3
  SET_NPC_STAT damages 3
  SET_NPC_STAT tohit 30
  SET_NPC_STAT aimtime 2000
  SET_NPC_STAT life 16
  SET_XP_VALUE 30
  SET §cowardice 10
  SET §confusability 3           // level of magic needed to confuse this npc
  SET §pain 1
  SET §tactic 2
  SET £hail []
  SET £thief [human_female_thief]
  SET £strike [female_striking]
  SET £victory []
  SET £whogoesthere []
  SET £heardnoise []
  SET £back2guard []
  SET £misc [human_female_misc]
  SET £threat []
  SET £search []
  SET £youmad []
  SET £dying [human_female_dying]
  SET £ouch [female_ouch]
  SET £ouch_medium [female_ouch_medium]
  SET £ouch_strong [female_ouch_strong]
  SET £help [human_female_help]
  SET £comeback []
  SET £justyouwait []
  TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
 }
 IF (£type == "human_child") 
 {
  LOADANIM WALK        "child_walk"
  LOADANIM RUN         "child_run"
  LOADANIM WAIT        "child_wait"
  LOADANIM HIT         "child_get_hit"
  LOADANIM HIT_SHORT   "child_get_hit"
  LOADANIM DIE         "child_dead"
  LOADANIM ACTION2     "child_play"
  LOADANIM ACTION3     "child_run_funny"
  SETNAME [description_shany] 
  SET_NPC_STAT armor_class 2
  SET_NPC_STAT absorb 1
  SET_NPC_STAT damages 1
  SET_NPC_STAT tohit 2
  SET_NPC_STAT aimtime 3000
  SET_NPC_STAT life 5
  SET_XP_VALUE 0
  SET §cowardice 5
  SET §confusability 2           // level of magic needed to confuse this npc

  SET §pain 0
  SET §tactic 2
  SET £hail []
  SET £thief []
  SET £strike []
  SET £victory []
  SET £whogoesthere []
  SET £heardnoise []
  SET £back2guard []
  SET £misc [Shany_misc]
  SET £threat []
  SET £search []
  SET £youmad []
  SET £dying []
  SET £ouch [Shany_ouch]
  SET £ouch_medium [Shany_ouch]
  SET £ouch_strong [Shany_ouch]
  SET £help [Shany_help]
  SET £comeback []
  SET £justyouwait []
  TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF "" 
 }
 IF (£type ISCLASS "human_guard") 
 {
  SET §short_reflections 1
  SET_ARMOR_MATERIAL METAL_CHAIN
  SET_STEP_MATERIAL Foot_metal_chain
  SETWEAPON LONG_SWORD
  TWEAK ALL "human_chainmail"
  SETNAME [description_guard]
  SET_NPC_STAT armor_class 18
  SET_NPC_STAT absorb 40
  SET_NPC_STAT damages 15
  SET_NPC_STAT tohit 70
  SET_NPC_STAT aimtime 1000
  SET_NPC_STAT life 60
  SET_XP_VALUE 100
  SET §cowardice 10
  SET §confusability 5           // level of magic needed to confuse this npc
  SET §pain 4
  SET §morning_task 0
  SET §doing_task 0
  SET §evening_task 0
  SET §current_day_period 0
  LOADANIM WALK                  "human_normal_walk_guard"
  SET £hail [human_guard_hail]
  SET £thief [human_male_thief]
  SET £strike [human_male_striking]
  SET £threat [human_guard_threat]
  SET £whogoesthere [human_Guard_guardmode]
  SET £heardnoise [Human_guard_hear]
  SET £back2guard [human_guard_back2guard]
  SET £search [human_guard_search]
  SET £youmad [Human_guard_mad]
  SET £dying [human_male_dying]
  SET £ouch [Human_guard_ouch]
  SET £ouch_medium [Human_guard_ouch_medium]
  SET £ouch_strong [Human_guard_ouch_strong]
  SET £help [Human_guard_help]
  SET £comeback [Human_guard_comeback]
  SET £justyouwait [Human_guard_justyouwait]
  TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
  IF (£type == "human_guard_kingdom") 
  {
    TWEAK SKIN "npc_human_chainmail_body" "npc_human_chainmail_guard_body"
    TWEAK SKIN "npc_human_chainmail_hero_head" "npc_human_chainmail_guard_head"
    SET £victory [Human_guard_victory]
    SET £misc [Human_guard_misc~£voice~]
    LOADANIM ACTION2 "human_normal_lay_in"
    LOADANIM ACTION3 "human_normal_lay_cycle"
    LOADANIM ACTION4 "human_normal_lay_out"
    SET_ARMOR_MATERIAL METAL_CHAIN
    SET_STEP_MATERIAL Foot_metal_chain
  }
  IF (£type == "human_guard_ss") 
  {
   
   SET £friend "sacred_sword"
   TWEAK SKIN "npc_human_chainmail_body" "npc_human_chainmail_sacred_body"
   TWEAK SKIN "npc_human_chainmail_hero_head" "npc_human_chainmail_sacred_head"
   SET £victory [Human_guard_sacred_victory]
   SET £misc [Human_male_misc_short]
   SET_ARMOR_MATERIAL METAL_CHAIN
    SET_STEP_MATERIAL Foot_metal_chain
  }
 }
 IF (£type == "human_ylside") 
 {
  SETGORE ON
  INVENTORY DESTROY
  SET_ARMOR_MATERIAL METAL
  SET_STEP_MATERIAL Foot_metal_plate
  SET §enemy 1
  SET_EVENT HEAR ON
  SET £key_carried "NOTHINGCARRIED"
  SET £friend "akbaa"
  TWEAK LOWER "human_ylside"
  TWEAK SKIN "npc_human_base_hero_head" "npc_human_ylside_head"
  SETNAME [description_ylside]
  SETWEAPON SWORD_2HANDED
  SET_NPC_STAT RESISTMAGIC 60
  SET_NPC_STAT RESISTPOISON 50
  SET_NPC_STAT RESISTFIRE 60
  SET_NPC_STAT armor_class 70
  SET_NPC_STAT absorb 50
  SET_NPC_STAT damages 30
  SET_NPC_STAT tohit 90
  SET_NPC_STAT aimtime 300
  SET_NPC_STAT life 60
  SET_XP_VALUE 500
  SET §cowardice 0
  SET §confusability 7           // level of magic needed to confuse this npc
  SET §pain 7
  LOADANIM WALK                  "Ylside_walk"
  LOADANIM RUN                   "Ylside_run"
  LOADANIM WAIT                  "Ylside_wait"
  LOADANIM GRUNT                 "Ylside_fight_grunt"
  LOADANIM HIT                   "Ylside_fight_receive_damage"
  LOADANIM DIE                   "Ylside_death"
  loadanim FIGHT_WALK_FORWARD    "Ylside_fight_walk_forward"
  loadanim FIGHT_WALK_BACKWARD   "Ylside_fight_walk_backward"
  SET £hail []
  SET £thief []
  SET £strike []
  SET £threat []
  SET £whogoesthere []
  SET £heardnoise []
  SET £back2guard []
  SET £misc []
  SET £search []
  SET £youmad []
  SET £dying []
  SET £ouch []
  SET £ouch_medium []
  SET £ouch_strong []
  SET £help []
  SET £comeback []
  SET £justyouwait []
 }
 IF (£type == "human_king") 
 {
  SETNAME [description_king]
  SET_NPC_STAT armor_class 25
  SET_NPC_STAT absorb 40
  SET_NPC_STAT damages 18
  SET_NPC_STAT tohit 60
  SET_NPC_STAT aimtime 1500
  SET_NPC_STAT life 65
  SET_XP_VALUE 700
  SET §cowardice 0
  SET §confusability 6           // level of magic needed to confuse this npc
  SET §pain 3
  SET £hail []
  SET £thief []
  SET £strike [human_male_striking]
  SET £threat []
  SET £whogoesthere []
  SET £heardnoise []
  SET £back2guard []
  SET £misc []
  SET £search []
  SET £youmad []
  SET £dying [human_male_dying]
  SET £ouch [human_male_ouch]
  SET £ouch_medium [human_male_ouch_medium]
  SET £ouch_strong [human_male_ouch_strong]
  SET £help []
  SET £comeback []
  SET £justyouwait []
 }
 IF (£type ISCLASS "human_priest") 
 {
  SET §short_reflections 1
  SET £friend "akbaa"
  SETWEAPON DAGGER
  SETNAME [description_priest]
  IF (£type == "human_priest_base") 
  {
   SET §tactic 0
   SET_NPC_STAT armor_class 10
   SET_NPC_STAT absorb 5
   SET_NPC_STAT damages 12
   SET_NPC_STAT tohit 40
   SET_NPC_STAT aimtime 300
   SET_NPC_STAT life 25
   SET_NPC_STAT mana 0
   SET_XP_VALUE 70
   SET §cowardice 10
   SET §confusability 6           // level of magic needed to confuse this npc

   SET §pain 2
  }
  IF (£type == "human_priest_high") 
  {
   SET §short_reflections 1
   SET §tactic 0
   SET_NPC_STAT RESISTMAGIC 50
   SET_NPC_STAT armor_class 20
   SET_NPC_STAT absorb 5
   SET_NPC_STAT damages 16
   SET_NPC_STAT tohit 40
   SET_NPC_STAT aimtime 300
   SET_NPC_STAT life 35
   SET_NPC_STAT mana 200
   SET_XP_VALUE 100
   SET §cowardice 12
   SET §confusability 7           // level of magic needed to confuse this npc
   SET §pain 2
   SET §spell_ready 1
   SET §casting_lvl 5
   TIMERspell_decision -i 0 5 SENDEVENT SPELLDECISION SELF ""
  }
  SET £hail [priest_intruder]
  SET £thief []
  SET £strike [human_male_striking]
  SET £victory [priest_victory]
  SET £whogoesthere []
  SET £heardnoise []
  SET £back2guard []
  SET £misc [priest_misc]
  SET £threat []
  SET £search []
  SET £youmad []
  SET £dying [human_male_dying]
  SET £ouch [human_male_ouch]
  SET £ouch_medium [human_male_ouch_medium]
  SET £ouch_strong [human_male_ouch_strong]
  SET £help [priest_intruder]
  SET £comeback []
  SET £justyouwait [priest_justyouwait]
  TIMERmisc_reflection -i 0 10 SENDEVENT MISC_REFLECTION SELF ""
 }
  IF (£type == "felnor") {
   SET §short_reflections 1
   SET §tactic 0
   SET_NPC_STAT RESISTMAGIC 60
   SET_NPC_STAT armor_class 20
   SET_NPC_STAT absorb 5
   SET_NPC_STAT damages 18
   SET_NPC_STAT tohit 40
   SET_NPC_STAT aimtime 300
   SET_NPC_STAT life 70
   SET_NPC_STAT mana 200
   SET_XP_VALUE 100
   SET §cowardice 12
   SET §confusability 8           // level of magic needed to confuse this npc
   SET §pain 2
   SET §spell_ready 1
   SET §casting_lvl 7
   TIMERspell_decision -i 0 5 SENDEVENT SPELLDECISION SELF ""
  }
 IF ( £friend != "NONE" ) SETGROUP £friend
 IF (£type == "Ghost") {
  LOADANIM ACTION1 "human_normal_lay_out"
  LOADANIM ACTION2 "human_intro_dead_cycle"
  INVENTORY DESTROY
  SETGROUP -r £friend
  SET £friend "NONE"
  SETINTERACTIVITY NONE
  SET_BLOOD 0.9 0.9 0.9
  SET_XP_VALUE 100
  TWEAK SKIN "npc_gore" "alpha"
  TWEAK SKIN "npc_human_base_hero_head" "alpha"
  TWEAK SKIN "npc_human_hero_naked_body" "alpha"
  SET_SHADOW OFF
  SET §reflection_mode 0
  SET §cowardice 0
  SET §confusability 8           // level of magic needed to confuse this npc
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
  SET £dying []
  SET £ouch []
  SET £ouch_medium []
  SET £ouch_strong []
  SET £help []
  SET £comeback []
  SET £justyouwait []
  SET_ARMOR_MATERIAL METAL
  SET_STEP_MATERIAL NONE
  SET_NPC_STAT armor_class 18
  SET_NPC_STAT absorb 40
  SET_NPC_STAT damages 15
  SET_NPC_STAT tohit 70
  SET_NPC_STAT aimtime 1000
  SET_NPC_STAT life 60
  SET_NPC_STAT RESISTMAGIC 50
  SET_XP_VALUE 100
  SETWEAPON LONG_SWORD
  PLAYANIM -l ACTION2
  TIMERin -mi 0 500 GOTO GHOST
  ACCEPT
 }
 ACCEPT
}
>>GHOST
IF (^DIST_PLAYER > 500) ACCEPT
 TIMERin OFF
 PLAYANIM -e ACTION1 SENDEVENT ATTACK_PLAYER SELF ""
 ACCEPT

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

//#LocalChat
// ---------------------------------------------------------------------------------
// LocalChat INCLUDE START ---------------------------------------------------------
// ---------------------------------------------------------------------------------
>>START_CHAT
 // save misc reflection mode
 SET §saved_reflection §reflection_mode
 // no more stupid reflections !
 SET §reflection_mode 0
 // fo not change behavior if frozen
 IF ( §frozen == 1 ) RETURN
 // save behavior (if not saved)
 GOSUB SAVE_BEHAVIOR
 // look at player
 BEHAVIOR FRIENDLY
 SETTARGET PLAYER
RETURN

>>END_CHAT
 SET_EVENT COLLIDE_NPC ON
 SET §collided_player 0
 // restor behavior only if not in fighting mode
 IF ( §fighting_mode == 0 )
 {
  // restore misc reflection mode
  SET §reflection_mode §saved_reflection
  // if frozen : don't restore behavior
  IF ( §frozen == 1 ) RETURN
  // restore behavior
  GOSUB RESTORE_BEHAVIOR
 }
RETURN
// ---------------------------------------------------------------------------------
// LocalChat INCLUDE END -----------------------------------------------------------
// ---------------------------------------------------------------------------------

//#
>>END_GARLIC
 IF ( §fighting_mode != 0 ) ACCEPT
 SET #GARLIC_EATEN 0
 SET §reflection_mode 1
 GOSUB RESTORE_BEHAVIOR
ACCEPT

ON CHAT {
  IF (§enemy == 1) {
   SENDEVENT DETECTPLAYER SELF ""
   ACCEPT
  }
  IF (£type == "human_female_base")
  {
   IF ( #GARLIC_EATEN == 1 )
   {
     IF ( §fighting_mode != 0 ) ACCEPT
     GOSUB SAVE_BEHAVIOR
     HEROSAY [garlic_attack]
     SPEAK £help NOP
     BEHAVIOR FLEE 500
     SETTARGET PLAYER
     TIMERgarlic 1 10 GOTO END_GARLIC
     ACCEPT
   }
  }
  IF (^SPEAKING == 1) ACCEPT
  IF (£type ISCLASS "human_guard") { 
    IF (£type == "human_guard_kingdom") {
      IF (#CARLO_INTRODUCED == 0) {
       GOSUB START_CHAT
       SPEAK [human_guard_1st_time~£voice~] GOSUB END_CHAT
       ACCEPT
      }
      IF (#PLAYER_ON_QUEST > 2) {
       GOSUB START_CHAT
       SPEAK [Human_guard_greetings_guardian~£voice~] GOSUB END_CHAT
       ACCEPT
      }
      IF (§chatpos == 0) {
       GOSUB START_CHAT
       SPEAK [Human_guard_generic~£voice~] GOSUB END_CHAT
       ACCEPT
      }
     ACCEPT
    }
    IF (£type == "human_guard_ss") {
      IF (#shield_elder_retrieved == 1) {
       GOSUB START_CHAT
       SPEAK [Human_guard_greetings_sacred_after_shield~£voice~] GOSUB END_CHAT
       ACCEPT
      }
       GOSUB START_CHAT
       SPEAK [Human_guard_sacred_generic~£voice~] GOSUB END_CHAT
     ACCEPT
    }
   ACCEPT
  }
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

//#mice_main

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
 {
  BEHAVIOR FRIENDLY
  SETTARGET ~£targeted_mice~
  SENDEVENT STOP_MOUSE ~£targeted_mice~ ""
  PLAYANIM ACTION1
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
ON _OLLIDE_NPC
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
 // IF (§player_in_sight == 1) ACCEPT
 IF ( SELF ISGROUP UNDEAD ) {
 // TIMERmain OFF
 }
 IF (^PLAYERSPELL_INVISIBILITY == 1) ACCEPT
 IF (§confused == 1) ACCEPT
 SET §player_in_sight 1
 IF ( §controls_off != 0 ) ACCEPT
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
 SET §player_in_sight 0
 IF ( §controls_off != 0 ) ACCEPT
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
 IF (^$PARAM1 == "BACK") ACCEPT
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

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
