
/obj/item/possessed
	name = "possessed item"
	desc = "Something is wrong with that object."
	icon = 'modular_robust/code/modules/demonology/icons.dmi'
	icon_state = "eye_box"


/obj/item/possessed/eyebox
	name = "possessed item"
	desc = "Something is wrong with that object."
	icon_state = "eye_box"

/obj/item/possessed/eyebox/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/demon_holder, \
		command_typepaths = list(/datum/demon_utterance/summon/bloodvine, /datum/demon_utterance/summon/blood))


/mob/living/basic/mushroom/with_demons
	name = "walking mushroom with demons in it"
	desc = "It's a massive mushroom... with legs?"

/mob/living/basic/mushroom/with_demons/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/demon_holder, \
		command_typepaths = list(/datum/demon_utterance/summon/bloodvine, /datum/demon_utterance/summon/blood))
