
// COMSIG_MOVABLE_HEAR

// a lot of code was copied from obey commands component and /datum/pet_command

#define DEMON_TARGETS_SELF 0
#define DEMON_TARGETS_SPEAKER 1
#define DEMON_TARGETS_LEAST_FAV 2
#define DEMON_TARGETS_MOST_FAV 3

GLOBAL_LIST_INIT(demon_alphabet, list(
	"abc", //1
	"abd", //2
	"ank", //3
	"ano",
	"brc",
	"ckt",
	"edt",
	"eng",
	"enk",
	"ent",
	"erd",
	"err",
	"esf",
	"etz",
	"hes",
	"ind",
	"ing",
	"ink",
	"ion",
	"nce",
	"nde",
	"ntn",
	"oft",
	"rey",
	"sth",
	"tha",
	"til",
	"tio",
	"tis",
	"yank" //30
)) // there's supposed to be more

// a single demon language word that coresponds to a single command. the component should handle having multiple of these
/datum/demon_utterance
// a refference to the demon component in case we need it
	var/datum/component/demon_holder/demon_comp
// Weak reference to who follows this command
	var/datum/weakref/weak_parent
// Should maaaaybe be shown after a use of a magic scanner
//	var/command_name // will be un-commented if i find it a use
// Speech strings to listen out for
	var/list/speech_commands = list() //when assigning random utterances, REMOVE THE DEFAULT NON-RANDOM ONES
// Shown above the mob's head when it hears you
//	var/command_feedback
	/// How close a mob needs to be to a target to respond to a command
	var/sense_radius = 7
	//range of the effect
	var/effect_range = 7
	/// Blackboard key for targeting strategy, for demons with AI controllers
	var/targeting_strategy_key = BB_PET_TARGETING_STRATEGY
//true if the effect completely breaks without a target, false if it can still work
	var/must_have_a_target = TRUE
// message sent when the effect is happening
	var/effect_message = "attempts to trigger an empty effect"
//if true, the message of the effect will start with the name of the object the demon is attached to
	var/add_name_before_effmessage = TRUE
	var/center_at_target = FALSE
	var/target_choise = DEMON_TARGETS_SPEAKER

// how long does the effect last. 0 for infinite
	var/duration = 0 SECONDS
// multiplies the effect duration. made a separate variable for some complex stat fuckery that i might implement someday
	var/duration_multiplier = 1

//figure out what callouts were doing in the pet code


//reminder to make them react when someone points at them

/datum/demon_utterance/New(atom/parent,datum/component/demon_holder/demon_component)
	. = ..()
	weak_parent = WEAKREF(parent)
	demon_comp = demon_component
	parent.audible_message(span_hear("Creating a demon utterance datum for [parent]..."))



/// Respond to speech that contains some words in demon language
/datum/demon_utterance/proc/respond_to_utterance(atom/source, list/hearing_args)
	SIGNAL_HANDLER
	//var/mob/living/parent = weak_parent.resolve()
	var/atom/movable/parent = weak_parent.resolve() //changed from mob to movable so it could include items
	if (!parent)// if datums isn't attached to something, then stop
		return
	parent.audible_message(span_hear("The demon inside [parent] is hearing something"))
//	if (!can_see(parent, source, sense_radius)) // Basically the same rules as hearing
//		parent.audible_message(span_hear("The demon inside [parent] can't see what it's hearing"))
//		return
	var/spoken_text = hearing_args[HEARING_RAW_MESSAGE]
	if (!find_command_in_text(spoken_text))
		parent.audible_message(span_hear("The demon inside [parent] did not find the command in the sentence it heard"))
		return
	try_activate_command(commander = hearing_args[HEARING_SPEAKER])//WARNING!!! aparently the source is the parent and not the speaker. gotta figure out why it works like that
//this might fix it

//REGISTERING
/datum/demon_utterance/proc/register_to_parent(atom/parent)
	RegisterSignal(parent, COMSIG_MOVABLE_HEAR, PROC_REF(respond_to_utterance))
	parent.audible_message(span_hear("Demon's hearing signal should have been added to [parent]..."))


/datum/demon_utterance/proc/unregister_from_parent(atom/parent)
	UnregisterSignal(parent, list(COMSIG_MOVABLE_HEAR))
	parent.audible_message(span_hear("Unregerestering demons out of [parent]..."))


//REGISTERING END




/datum/demon_utterance/proc/demon_able_to_respond()
	return TRUE //optionally add more checks later

/// Apply a command state if conditions are right, return command if successful
/datum/demon_utterance/proc/try_activate_command(mob/living/commander)//, radial_command)
	if(!demon_able_to_respond())
		return FALSE
// add a check for if the demon ignores the command from it's least favorable target
// add a check for if the demon only performs commands from it's most favorable target
	var/atom/movable/parent = weak_parent.resolve()
	if (!parent)
		return FALSE
// sellecting a target (this code would probably need to get un-spaghettified if possible)
	var/chosen_target = parent
// add some check for if the parent isn't a mob. if it's an item, parent target should use it's holder. if mob target couldn't be found, then target the speaker
	switch (target_choise)
		if(DEMON_TARGETS_SPEAKER)
			chosen_target = commander
		if(DEMON_TARGETS_LEAST_FAV)
			chosen_target = demon_comp.get_least_fav_mob()
			if (isnull(chosen_target))
				chosen_target = commander//if we can't find the least favorite mob, use the commander instead cause fuck em
		if(DEMON_TARGETS_MOST_FAV)
			chosen_target = demon_comp.get_most_fav_mob()
			if (isnull(chosen_target))// if we can't find the most favorite mob, target yourself of course
				chosen_target = parent
//if we couldn't find a proper living target where we were supposed to, let's just dump whatever shit we're casting on whoever we like the least
	if (!istype(chosen_target, /mob/living))
		chosen_target = demon_comp.get_least_fav_mob()
	if (isnull(chosen_target) && must_have_a_target)// if we still somehow didn't find it after all that redundant shit from above, try returning
		return FALSE
//doing the main effect
	parent.audible_message(span_hear("[add_name_before_effmessage ? "[parent] ":""]" + effect_message))
	perform_utterance_effect(parent, commander, chosen_target)
	return TRUE

//the main effect proc
/datum/demon_utterance/proc/perform_utterance_effect(atom/movable/parent,mob/living/commander,mob/living/target) //add a check for most and least favorable mobs to the proc itself if needed
//	var/atom/movable/parent = weak_parent.resolve()
//	if (!parent)
//		return
//	parent.audible_message(span_hear("[parent] " + effect_message))
	return

/datum/demon_utterance/proc/find_command_in_text(spoken_text, check_verbosity = FALSE)
	for (var/command in speech_commands)
		if (!findtext(spoken_text, command))
			continue
		if(check_verbosity && length(spoken_text) > length(command) + MAX_NAME_LEN)
			continue
		return TRUE
	return FALSE


/datum/demon_utterance/proc/show_utterance_fail()
	var/atom/movable/parent = weak_parent.resolve()
	parent.balloon_alert_to_viewers("Fails to respond")//maybe make a better message later
	return

/datum/demon_utterance/proc/randomise_stats(seed = 1)
	return

// for now, placeholder effects only send a message of what they're supposed to be doing.
// when there's code to make them actually do that, sending the message shouldn't be needed

