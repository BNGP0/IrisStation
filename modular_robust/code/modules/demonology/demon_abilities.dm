

/datum/demon_utterance/summon_entity
//	var/entity_type //finish this
	speech_commands = list("summon entity")
	effect_debug_text = "Attempts to summon something"

/datum/demon_utterance/summon_entity/bloodvine
	effect_debug_text = "Attempts to summon bloodvines"
	speech_commands = list("summon blodvines") //just in case so debug text doesn't trigger it

/datum/demon_utterance/summon_effect
	effect_debug_text = "Attempts to summon some effect in a radius"
	speech_commands = list("summon effect")

/datum/demon_utterance/summon_effect/blood
	effect_debug_text = "Attempts to summon blood in a radius"
	speech_commands = list("summon bloood")// so it doesn't conflict with bloodvines invocation


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









