//-=+=-=+=-=+-=+=- SUMMON
/datum/demon_utterance/summon
	speech_commands = list("summon something")
	effect_message = "Attempts to summon something"
	effect_range = 2
	var/summon_type = /obj/item/flashlight/flare/candle
// for unlimited targets just put a very big number there
	var/max_summons = 15
	duration = 0 SECONDS
	duration_multiplier = 1
	var/dont_summon_on_walls = TRUE
	var/use_target_factions = TRUE
	must_have_a_target = FALSE
	center_at_target = FALSE

//something is telling me i'd probably need to change how target works
// actually i'm not even sure if it is selected in the procs at the moment
/datum/demon_utterance/summon/perform_utterance_effect(atom/movable/parent,mob/living/commander,mob/living/target)
//code copied from the conjure spell
//	. = ..()
	var/atom/spawn_center = parent
	if (center_at_target && !isnull(target))
		spawn_center = target

	parent.audible_message(span_hear("Summoning utterance objects. parent is [parent], commander is [commander], target is [target]"))
	//commander is the parent for some reason

	var/total_lifespan = duration * duration_multiplier
	var/list/to_summon_in = list()
	for(var/turf/summon_turf in range(effect_range, spawn_center))
		if(dont_summon_on_walls && summon_turf.density)
			continue
		to_summon_in += summon_turf

	for(var/i in 1 to max_summons)//UNFINISHED!CONTINUE FROM HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		if(!length(to_summon_in))
			break

//		var/atom/summoned_object_type = summon_type// replace all of summoned_object_type with summon_type as it is no longer random picked from a list
		var/turf/spawn_place = pick(to_summon_in)
		//if(summon_respects_prev_spawn_points)
		to_summon_in -= spawn_place

		if(ispath(summon_type, /turf)) //checks if the summoned object is a turf i think?
			if(isclosedturf(spawn_place))
				spawn_place.ChangeTurf(summon_type, flags = CHANGETURF_INHERIT_AIR)
				return //wouldn't the returns end the loop too early? figure out why it was in the conjure code later
			if(ispath(summon_type, /turf/closed))
				if (spawn_place.overfloor_placed)
					spawn_place.ChangeTurf(summon_type, flags = CHANGETURF_INHERIT_AIR)
				else
					spawn_place.place_on_top(summon_type, flags = CHANGETURF_INHERIT_AIR)
				return
			var/turf/open/open_turf = spawn_place
			open_turf.replace_floor(summon_type, flags = CHANGETURF_INHERIT_AIR)
			return

		var/atom/summoned_object = new summon_type(spawn_place)
// add some code that copies the mob faction
//code copied from my advanced conjuration
		if(istype(summon_type, /mob/living))
			var/mob/living/L = summoned_object
			var/changed_factions_already = FALSE
			if(isliving(parent))
				var/mob/living/Lparent = parent
				L.faction = Lparent.faction
				changed_factions_already = TRUE
			//all these nested ifs seem to be a clusterfuck but this should work for now
			if (changed_factions_already && use_target_factions && !isnull(target))
				L.faction |= target.faction
			else if (use_target_factions && !isnull(target))
				L.faction = target.faction
//code copied from my advanced conjuration END
		summoned_object.flags_1 |= ADMIN_SPAWNED_1
		ADD_TRAIT(summoned_object, TRAIT_SPAWNED_MOB, INNATE_TRAIT)
		if(total_lifespan > 0)
			QDEL_IN(summoned_object, total_lifespan)
//conjure spell code end
	return


/* //why did i copy this in here? double check it then delete if unneeded
/datum/demon_utterance/summon
	speech_commands = list("summon something")
	effect_message = "Attempts to summon something"
	effect_range = 2
	var/summon_type = /obj/item/flashlight/flare/candle
// for unlimited targets just put a very big number there
	var/max_summons = 15
// how long do summoned objects persist. 0 for infinite
	var/summon_lifespan = 0
// multiplies the summon lifespan. made a separate variable for some complex stat fuckery that i might implement someday
	var/summon_lifespan_multiplier = 1
	var/dont_summon_on_walls = TRUE
	var/use_target_factions = TRUE
*/


/datum/demon_utterance/summon/bloodvine
	effect_message = "Attempts to summon bloodvines"
	speech_commands = list("summon blodvines") //just in case so debug text doesn't trigger it
	effect_range = 2
	summon_type = /mob/living/simple_animal/hostile/horrormob/bloodvine
// for unlimited targets just put a very big number there
	max_summons = 6
// how long do summoned objects persist. 0 for infinite
	summon_lifespan = 6 SECONDS
// multiplies the summon lifespan. made a separate variable for some complex stat fuckery that i might implement someday
	summon_lifespan_multiplier = 3
	dont_summon_on_walls = TRUE
	use_target_factions = TRUE

/datum/demon_utterance/summon/blood
	effect_message = "Attempts to summon blood in a radius"
	speech_commands = list("summon bloood")// so it doesn't conflict with bloodvines invocation
	effect_range = 4
	summon_type = /obj/effect/decal/cleanable/blood/splatter
// for unlimited targets just put a very big number there
	max_summons = 14
// how long do summoned objects persist. 0 for infinite
	summon_lifespan = 0
// multiplies the summon lifespan. made a separate variable for some complex stat fuckery that i might implement someday
	summon_lifespan_multiplier = 0
	dont_summon_on_walls = TRUE
	use_target_factions = TRUE

// /obj/effect/decal/cleanable/blood/splatter

//to do: add a variable for a trait mobs with which the demon can not target
/datum/demon_utterance/trait
	speech_commands = list("give me trait")
	effect_message = "Attempts give it's target a trait"
	effect_range = 2
// for unlimited targets just put a very big number there
	duration = 6 SECONDS //should be like from 3 to 12
	duration_multiplier = 3 //2 to 4
	must_have_a_target = TRUE
	var/list/traits_to_grant //the traits themselves.










/*
TYPES OF EFFECTS

	Areal
		Summon effect around yourself
			gibs
			blood
			fire
		Convert tiles
			Turn tiles to sand and sandstone

	Mob targeting
		Flesh sculpt: Deal some damage to the least favorable human and then construct an object using their flesh as material
			statue of the demon / posessed item
			statue of the target (the flesh donor)
			statue of the most favorable character in range
			flehs crate
			flesh chair
		Stun mob and spawn a fake pit effect under them
			The most favorable
			The least favorable
			The closest

	Summon entity: The entity randomly coppies the faction of the most favorable character in the radius and disappears after a cooldown
		summon shade that is hard to notice, but it follows people and does nothing. takes longer to disappear
		summon razor eyes that basically have the ability of watchers you can dodge by looking away, but instead of stunning they
hit you with a small sharp attack.
		summon bloodvines

		Give temporary trait
		to favorable or unfavorable characters
			TRAIT_FORCED_STANDING
			TRAIT_LITERATE
			TRAIT_FAT_IGNORE_SLOWDOWN
			TRAIT_FAT
			TRAIT_FIST_MINING //long term
			TRAIT_DISCOORDINATED_TOOL_USER
			TRAIT_DEATHCOMA - double check if removing the trait makes you leave the coma
			TRAIT_FAKEDEATH //long term
			TRAIT_SLEEPIMMUNE
			TRAIT_TESLA_SHOCKIMMUNE
			TRAIT_UNHUSKABLE //long term
			TRAIT_NOFIRE_SPREAD
		to favorable characters
			TRAIT_PERFECT_ATTACKER //might sound OP but there isn't that many attacks that even check for doges anyway
			TRAIT_LITERATE
			TRAIT_FAT_IGNORE_SLOWDOWN
			TRAIT_FIST_MINING
			TRAIT_SLEEPIMMUNE
			TRAIT_SHOCKIMMUNE
			TRAIT_BOMBIMMUNE - if it's too op could be removd
			TRAIT_UNHUSKABLE //long term
			TRAIT_NOFIRE - hopefully not too op if temporary
			TRAIT_NOHUNGER - might
		to unfavorable characters
			TRAIT_CLUMSY
			TRAIT_FAT
			TRAIT_DISCOORDINATED_TOOL_USER

	use these traits as placeholders if you need to remove existing ones from the list without fucking up their order and changing seed results
		TRAIT_SPACE_ANT_IMMUNITY

	Make the demon/posessed object attack someone


*/









