ON INIT {
tweak skin "npc_human_female_base_head" "npc_human_ylside_head_mx"
tweak lower Y_mx2
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
 SET_NPC_STAT BACKSTAB 0
 PHYSICAL RADIUS 30
 SET_MATERIAL FLESH
 SET_ARMOR_MATERIAL METAL
 SET_STEP_MATERIAL Foot_metal
// SET_BLOOD 0.9 0.1 0.1
 SET_NPC_STAT RESISTMAGIC 40
 SET_NPC_STAT RESISTPOISON 40
 SET_NPC_STAT RESISTFIRE 40
 SETBLOOD 0.6 0.6 1.0
 SETIRCOLOR 0.5 0.5 1.0
 SET §panicmode 0               //when = 0, the NPC is not sure if he saw the player "did that thing move over there ?"
 SET §care_about_mice 0         //this is a specific function to gobs, when = 1, they attack mices, obviously, we set it to 0 when they attack the player, or when they have more important things to do.
 SET §tactic 0                  //0 = normal    1 = sneak   2 = rabit  3 = caster
 SET §casting_lvl 0		  //set level of casting, the higher, the better
 SET §cowardice 8
 SET §pain 2
 SET §low_life_alert 10         //set the value for the npc heals himself
 ACCEPT
}

ON INITEND {
 SET §scale 110
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

  LOADANIM WALK        "human_woman_normal_walk"
  LOADANIM RUN         "human_woman_normal_run"
  LOADANIM WAIT        "human_woman_normal_wait"
  LOADANIM HIT         "human_fight_receive_damage"
  LOADANIM DIE         "human_woman_death"
  SETNAME [description_human_female]
  SET_NPC_STAT armor_class 30
  SET_NPC_STAT absorb 30
  SET_NPC_STAT damages 100
  SET_NPC_STAT tohit 300
  SET_NPC_STAT aimtime 10
  SET_NPC_STAT life 1200
  SET_XP_VALUE 3000
  SET §cowardice 10
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
 SETWEAPON SWORD_MX
 WEAPON ON
 SETMOVEMODE RUN
 BEHAVIOR -f MOVE_TO
 SETTARGET -a PLAYER
 SPELLCAST -smfd 10000 20 SPEED SELF
 timer 0 10 SPELLCAST -smfd 10000 20 SPEED SELF
 SPELLCAST -smfd 10000 50 CURSE PLAYER
// timer 0 10  SPELLCAST -smfd 10000 50 CURSE PLAYER
 timer 0 16 goto inyourface
 ACCEPT
}
ON GAME_READY {
 SETMOVEMODE RUN
 BEHAVIOR -f MOVE_TO
 SETTARGET -a PLAYER
 ACCEPT
}
>>inyourface
if (^rnd_100 > 30)
{
  SPELLCAST -smfd 500 50 LIGHTNING_STRIKE PLAYER
}
if (^rnd_100 > 10)
{
  SPELLCAST -smfd 10000 50 CURSE PLAYER
}
if (^rnd_100 > 10)
{
  SPELLCAST -smf 50 MAGIC_MISSILE PLAYER
}
if (^rnd_100 > 10)
{
  SPELLCAST -smf 50 SLOWDOWN PLAYER
}
if (^rnd_100 > 10)
{
  SPELLCAST -smfd 2000 50 MANA_DRAIN PLAYER
}
if (^rnd_100 > 10)
{
  SPELLCAST -smfd 2000 50 LIFE_DRAIN PLAYER
}
if (^rnd_100 > 10)
{
  SPELLCAST -smfd 2000 50 INVISIBILITY SELF
}
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
 GOTO FAILED_PATHFIND
 ACCEPT
}

//*******************************************************
ON OUCH 
{
 HEROSAY ^LIFE
  FORCEANIM HIT_SHORT
//  FORCEANIM HIT
//   SPEAK -a ~£ouch_strong~ NOP
//    SPEAK -a ~£ouch_medium~ NOP
 SPEAK -a ~£ouch~ NOP
 if (^life < 600) {
  if (§loc == 0 ) {
    FORCEANIM DIE
    SPEAK ~£dying~ NOP
    set §loc 1
  }
 }
 ACCEPT
}

ON DIE {
 FORCEANIM DIE
 SPEAK ~£dying~ COLLISION OFF
 SPECIALFX YLSIDE_DEATH 
 if (^rnd_3 > 2)
 {
   INVENTORY PLAYERADD "Armor\\Chest_plate_cm\\Chest_plate_cm"
   ACCEPT
 }
 else if (^rnd_2 > 1)
 {
   INVENTORY PLAYERADD "Armor\\helmet_plate_cm\\helmet_plate_cm"
   ACCEPT
 }
 INVENTORY PLAYERADD "Armor\\legging_plate_cm\\legging_plate_cm"
 ACCEPT
}

ON HIT {
  IF (^sender == "player") {
    SENDEVENT DEALT_DAMAGE player "~^&param1~ ~^me~"
  }
  ACCEPT
}
