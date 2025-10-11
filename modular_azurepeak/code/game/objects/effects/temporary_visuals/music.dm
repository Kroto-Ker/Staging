/obj/effect/temp_visual/music_rogue //color is white by default, set to whatever is needed
	name = "music"
	icon = 'modular_azurepeak/icons/effects/music-note.dmi'
	icon_state = "music_note"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/music_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/atom/movable/screen/alert/status_effect/buff/playing_music
	name = "Playing Music"
	desc = "Let the world hear my craft."
	icon_state = "buff"

/datum/status_effect/buff/playing_music
	id = "play_music"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_music
	var/effect_color
	var/datum/stressevent/stress_to_apply
	var/pulse = 0
	var/ticks_to_apply = 10

/datum/status_effect/buff/playing_music/on_creation(mob/living/new_owner, stress, colour)
	stress_to_apply = stress
	effect_color = colour
	return ..()

/datum/status_effect/buff/playing_music/tick()
	var/obj/effect/temp_visual/music_rogue/M = new /obj/effect/temp_visual/music_rogue(get_turf(owner))
	M.color = effect_color
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		for (var/mob/living/carbon/human/H in hearers(7, owner))
			if (!H.client)
				continue
			if (!H.has_stress_event(stress_to_apply))
				add_sleep_experience(owner, /datum/skill/misc/music, owner.STAINT)
				H.add_stress(stress_to_apply)
				if (prob(50))
					to_chat(H, stress_to_apply.desc)
			
			// Apply Xylix buff to those with the trait who hear the music
			// Only apply if the hearer is not the one playing the music
			if (H != owner && HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("The music brings a smile to my face, and fortune to my steps!"))
////////////////////
///HARPY SINGING///
//////////////////
// i dont wanna refactor how instruments function, so this is how we go about an instrument that can't be dropped bc it's inside of us
// since stopping playing relies on dropping item to stop unconscious people playing music
/datum/status_effect/buff/harpy_sing 
	id = "harpy_sing"
	alert_type = null
	tick_interval = 10
	duration = -1
	var/mob/living/carbon/human/harpy

/datum/status_effect/buff/harpy_sing/tick()
	. = ..()
	harpy = owner
	if(harpy.has_status_effect(STATUS_EFFECT_UNCONSCIOUS))
		harpy.remove_status_effect(/datum/status_effect/buff/harpy_sing)
	if(harpy.has_status_effect(STATUS_EFFECT_SLEEPING))
		harpy.remove_status_effect(/datum/status_effect/buff/harpy_sing)

/datum/status_effect/buff/harpy_sing/on_remove()
	. = ..()
	harpy = owner
	if(harpy.has_status_effect(/datum/status_effect/buff/playing_music))
		var/obj/item/organ/vocal_cords/harpy/vocal_cords = harpy.getorganslot(ORGAN_SLOT_VOICE)
		vocal_cords.vocals.attack_self(harpy)
