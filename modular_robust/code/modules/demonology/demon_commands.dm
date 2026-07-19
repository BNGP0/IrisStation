
// COMSIG_MOVABLE_HEAR

// a lot of code was copied from obey commands component and /datum/pet_command

GLOBAL_LIST_INIT(demon_alphabet, list(
	"abc",
	"abd",
	"ank",
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
	"yank"
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
	/// Blackboard key for targeting strategy, this is likely going to need it
	var/targeting_strategy_key = BB_PET_TARGETING_STRATEGY
// only needed while the utterances have no real effect and only send debug text
	var/effect_debug_text = "attempts to trigger an empty effect"

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
	if (!can_see(parent, source, sense_radius)) // Basically the same rules as hearing
		parent.audible_message(span_hear("The demon inside [parent] can't see what it's hearing"))
		return
	var/spoken_text = hearing_args[HEARING_RAW_MESSAGE]
	if (!find_command_in_text(spoken_text))
		parent.audible_message(span_hear("The demon inside [parent] did not find the command in the sentence it heard"))
		return
	try_activate_command(commander = source, radial_command = FALSE)

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
/datum/demon_utterance/proc/try_activate_command(mob/living/commander, radial_command)
	if(!demon_able_to_respond())
		return FALSE
//	var/atom/movable/parent = weak_parent.resolve()
//	set_command_active(parent, commander, radial_command)
	perform_utterance_effect()
	return TRUE


/datum/demon_utterance/proc/find_command_in_text(spoken_text, check_verbosity = FALSE)
	for (var/command in speech_commands)
		if (!findtext(spoken_text, command))
			continue
		if(check_verbosity && length(spoken_text) > length(command) + MAX_NAME_LEN)
			continue
		return TRUE
	return FALSE

//the main effect proc
/datum/demon_utterance/proc/perform_utterance_effect(mob/living/most_fav_mob,mob/living/least_fav_mob)
	var/atom/movable/parent = weak_parent.resolve()
	if (!parent)
		return
	parent.audible_message(span_hear("[parent] " + effect_debug_text))
	return

/datum/demon_utterance/proc/show_utterance_fail()
	var/atom/movable/parent = weak_parent.resolve()
	parent.balloon_alert_to_viewers("Fails to respond")//maybe make a better message later
	return

// for now, placeholder effects only send a message of what they're supposed to be doing.
// when there's code to make them actually do that, sending the message shouldn't be needed

