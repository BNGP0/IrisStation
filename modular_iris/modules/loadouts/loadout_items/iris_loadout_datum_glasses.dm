/datum/loadout_item/glasses/prescription_glasses/transparent
	name = "Transparent Glasses"
	item_path = /obj/item/clothing/glasses/regular/transparent

/datum/loadout_item/glasses/prescription_glasses/circle_glasses/transparent
	name = "Transparent Circle Glasses"
	item_path = /obj/item/clothing/glasses/regular/circle/transparent

/datum/loadout_item/glasses/prescription_glasses/thin/transparent
	name = "Transparent Thin Glasses"
	item_path = /obj/item/clothing/glasses/regular/thin/transparent

/datum/loadout_item/glasses/hud/stealing/get_item_information()
	. = ..()
	.[FA_ICON_LINK] = "Takes in properties of other glasses!"

/datum/loadout_item/glasses/hud/stealing/techno_visor
	name = "Techno-Visor"
	item_path = /obj/item/clothing/glasses/techno_visor

//unrestricts sci an meson goggles
//Meson
/datum/loadout_item/glasses/mesonpatch
	restricted_roles = null


/datum/loadout_item/glasses/meson_prescription
	restricted_roles = null

/datum/loadout_item/glasses/prescription_aviator_meson
	restricted_roles = null

/datum/loadout_item/glasses/aviator_meson
	restricted_roles = null

/datum/loadout_item/glasses/retinal_projector_meson
	restricted_roles = null

//Science
/datum/loadout_item/glasses/scipatch
	restricted_roles = null

/datum/loadout_item/glasses/science_glasses
	restricted_roles = null

/datum/loadout_item/glasses/prescription_aviator_science
	restricted_roles = null

/datum/loadout_item/glasses/aviator_science
	restricted_roles = null

/datum/loadout_item/glasses/retinal_projector_science
	restricted_roles = null

