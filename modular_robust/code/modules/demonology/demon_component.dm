// Demon component. based on code/datums/components/pet_commands/obeys_commands.dm
#define DEMON_HOLDER_COMPONENT_TRAIT "demon holder component"

/**
 * # Obeys Commands Component
 * Manages a list of pet command datums, allowing you to boss it around
 * Creates a radial menu of pet commands when this creature is alt-clicked, if it has any
 */

/datum/component/demon_holder
	/// List of commands you can give to the owner of this component
	var/list/available_commands = list()
// seed for the pseudo-random generator
	var/seed = 1
// range in which we look for the most and least favorable characters
	var/favorability_check_range = 9

//start from checking the longest utterances and end with checking the shortest


//CHECK THIS. THE PROC FOR ATTACHING THE DATUM TO THE TARGET MIGHT BE MISSING, THERE'S ONLY THE INITIALIZE ONE
/// The available_commands parameter should be passed as a list of typepaths
/datum/component/demon_holder/Initialize(list/command_typepaths = list())
	. = ..()
	if (!isatom(parent)) // should be attachable to items that have ai controllers
		return COMPONENT_INCOMPATIBLE
	var/atom/atom_parent = parent
//	if (!parent.ai_controller)
//		return COMPONENT_INCOMPATIBLE
	if (!length(command_typepaths))
		CRASH("Initialised demon holder component with no commands.")
	atom_parent.audible_message(span_hear("Initializing the demon holder component and command datums..."))
	var/list/new_commands = new/list()
	atom_parent.audible_message(span_hear("The initial command type list contains these items: "))
	atom_parent.audible_message(span_hear("<-=-=-=->"))
	for (var/command_path in command_typepaths)
		atom_parent.audible_message(span_hear("typepath item: [command_path]"))
		var/datum/demon_utterance/new_command = new command_path(parent,src)
		new_commands.Add(new_command)
		//available_commands["[new_command]"] = new_command // i think this should work as well as it did originally. or i could just add an utterance name variable
	atom_parent.audible_message(span_hear("<-=-=-=-=->"))

	atom_parent.audible_message(span_hear("The new command reference list contains these items: "))
	atom_parent.audible_message(span_hear("<-=-=-=-=-=->"))
	for (var/command_ref in command_typepaths)
		atom_parent.audible_message(span_hear("reference item: [command_ref]"))
	atom_parent.audible_message(span_hear("<-=-=-=-=-=-=->"))

	available_commands = new_commands



/datum/component/demon_holder/Destroy(force)
	QDEL_LIST_ASSOC_VAL(available_commands)
	return ..()


//REGISTERING
/datum/component/demon_holder/RegisterWithParent()
	if (!ismovable(parent))
		return
	var/atom/movable/parent_atom = parent
	parent_atom.become_hearing_sensitive(DEMON_HOLDER_COMPONENT_TRAIT)
	parent_atom.audible_message(span_hear("Beginning to register the list of demon hearing signals. The list length is [available_commands.len]"))
	for (var/datum/demon_utterance/utt in available_commands)
		parent_atom.audible_message(span_hear("Trying to register a demon hearing signal..."))
		utt.register_to_parent(parent)


/*
	RegisterSignal(parent, COMSIG_LIVING_BEFRIENDED, PROC_REF(add_friend))
	RegisterSignal(parent, COMSIG_LIVING_UNFRIENDED, PROC_REF(remove_friend))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
*/

/datum/component/demon_holder/UnregisterFromParent()
	for (var/datum/demon_utterance/utt in available_commands)
		utt.unregister_from_parent(parent)
	if (!ismovable(parent))
		return
	var/atom/movable/parent_atom = parent
	parent_atom.lose_hearing_sensitivity(DEMON_HOLDER_COMPONENT_TRAIT)


//	UnregisterSignal(parent, list(COMSIG_LIVING_BEFRIENDED, COMSIG_LIVING_UNFRIENDED, COMSIG_ATOM_EXAMINE, COMSIG_CLICK_ALT))
//REGISTERING END


//least and most favorable mob detection should later actually check for favorability using one of the randomly chosen criteria
//for now it is just range based with preference for carbons as a proof of concept
/datum/component/demon_holder/proc/get_most_fav_mob()
	// For now it just returns the last mob it finds nearby or the first carbon if there is one
	var/mob/living/main_candidate

	for(var/mob/living/mob_nearby in range(favorability_check_range))
		if (!can_see(parent, mob_nearby, favorability_check_range)) // check if parent can see the target
			continue
		main_candidate = mob_nearby
		if (iscarbon(mob_nearby))
			return mob_nearby
	return main_candidate

/datum/component/demon_holder/proc/get_least_fav_mob()
	// For now it just returns the first non-carbon or the last carbon it finds in range
	var/mob/living/main_candidate

	for(var/mob/living/mob_nearby in range(favorability_check_range))
		if (!can_see(parent, mob_nearby, favorability_check_range)) // check if parent can see the target
			continue
		main_candidate = mob_nearby
		if (!iscarbon(mob_nearby))
			return mob_nearby
	return main_candidate




//idk what exactly this should be doing
/*
/datum/component/demon_holder/RegisterWithParent() //idk what exactly this should be doing
//	RegisterSignal(parent, COMSIG_LIVING_BEFRIENDED, PROC_REF(add_friend))
//	RegisterSignal(parent, COMSIG_LIVING_UNFRIENDED, PROC_REF(remove_friend))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/demon_holder/UnregisterFromParent() // figure out what this does
	UnregisterSignal(parent, list(COMSIG_LIVING_BEFRIENDED, COMSIG_LIVING_UNFRIENDED, COMSIG_ATOM_EXAMINE, COMSIG_CLICK_ALT))
*/


//more pet command code for refference
//don't forget to remove it later before finishing the PR
/*
/// Add someone to our friends list
/datum/component/obeys_commands/proc/add_friend(datum/source, mob/living/new_friend)
	SIGNAL_HANDLER
	RegisterSignal(new_friend, COMSIG_KB_LIVING_VIEW_PET_COMMANDS, PROC_REF(on_key_pressed))
	RegisterSignal(new_friend, DEACTIVATE_KEYBIND(COMSIG_KB_LIVING_VIEW_PET_COMMANDS), PROC_REF(on_key_unpressed))
	for (var/command_name in available_commands)
		var/datum/pet_command/command = available_commands[command_name]
		INVOKE_ASYNC(command, TYPE_PROC_REF(/datum/pet_command, add_new_friend), new_friend)

/datum/component/obeys_commands/proc/on_key_unpressed(mob/living/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_ATOM_MOUSE_ENTERED)
	remove_from_viewers(source)

/datum/component/obeys_commands/proc/remove_from_viewers(mob/living/source)
	radial_viewers -= REF(source)

/// Remove someone from our friends list
/datum/component/obeys_commands/proc/remove_friend(datum/source, mob/living/old_friend)
	SIGNAL_HANDLER
	UnregisterSignal(old_friend, list(
		COMSIG_KB_LIVING_VIEW_PET_COMMANDS,
		DEACTIVATE_KEYBIND(COMSIG_KB_LIVING_VIEW_PET_COMMANDS),
	))
	for (var/command_name in available_commands)
		var/datum/pet_command/command = available_commands[command_name]
		INVOKE_ASYNC(command, TYPE_PROC_REF(/datum/pet_command, remove_friend), old_friend)

/// Add a note about whether they will follow the instructions of the inspecting mob
/datum/component/obeys_commands/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if (IS_DEAD_OR_INCAP(source))
		return
	if (!(user in source.ai_controller?.blackboard[BB_FRIENDS_LIST]))
		return
	examine_list += span_notice("[source.p_They()] seem[source.p_s()] happy to see you!")

/datum/component/obeys_commands/proc/on_key_pressed(mob/living/friend)
	SIGNAL_HANDLER
	RegisterSignal(friend, COMSIG_ATOM_MOUSE_ENTERED, PROC_REF(on_mouse_hover))

/datum/component/obeys_commands/proc/on_mouse_hover(mob/living/friend, atom/mouse_hovered)
	SIGNAL_HANDLER
	if(mouse_hovered == parent)
		display_menu(friend)
		return

	var/mob/living/owner = parent
	if(isliving(mouse_hovered) && mouse_hovered.loc != owner.loc)
		remove_from_viewers(friend)

/// Displays a radial menu of commands
/datum/component/obeys_commands/proc/display_menu(mob/living/friend)

	var/mob/living/living_parent = parent
	if (IS_DEAD_OR_INCAP(living_parent) || friend.stat != CONSCIOUS)
		return
	if (!(friend in living_parent.ai_controller?.blackboard[BB_FRIENDS_LIST]))
		return // Not our friend, can't boss us around
	if(radial_viewers[REF(friend)])
		return
	if(!can_see(friend, parent, DEFAULT_RADIAL_VIEWING_DISTANCE))
		return
	INVOKE_ASYNC(src, PROC_REF(display_radial_menu), friend)

/// Actually display the radial menu and then do something with the result
/datum/component/obeys_commands/proc/display_radial_menu(mob/living/friend)
	var/list/radial_options = list()
	for (var/command_name in available_commands)
		var/datum/pet_command/command = available_commands[command_name]
		var/datum/radial_menu_choice/choice = command.provide_radial_data()
		if (!choice)
			continue
		radial_options += choice
	radial_viewers[REF(friend)] = world.time + radial_menu_lifetime
	var/pick = show_radial_menu(friend, parent, radial_options, radius = radial_menu_radius, button_animation_flags = BUTTON_FADE_IN | BUTTON_FADE_OUT, custom_check = CALLBACK(src, PROC_REF(check_menu_viewer), friend), check_delay = 0.15 SECONDS, display_close_button = FALSE, radial_menu_offset = radial_menu_offset, user_space = radial_relative_to_user)
	remove_from_viewers(friend)
	if(!pick)
		return
	var/datum/pet_command/picked_command = available_commands[pick]
	picked_command.try_activate_command(friend, radial_command = TRUE)

/datum/component/obeys_commands/proc/check_menu_viewer(mob/living/user)
	if(QDELETED(user) || !radial_viewers[REF(user)])
		return FALSE
	if(world.time > radial_viewers[REF(user)])
		return FALSE
	var/viewing_distance = DEFAULT_RADIAL_VIEWING_DISTANCE
	if(!can_see(user, parent, viewing_distance))
		return FALSE
	return TRUE
*/








