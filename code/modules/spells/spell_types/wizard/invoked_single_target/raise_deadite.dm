/obj/effect/proc_holder/spell/invoked/raise_deadite
	name = "Raise Deadite"
	desc = "Infuse a corpse with quick acting Rot, raising it as a deadite. It will not be friendly to you."
	cost = 3
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 60
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "raiseskele"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocation = "Vivere Putrescere!"
	invocation_type = "shout"
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/raise_deadite/cast(list/targets, mob/user)
	. = ..()
	for(var/mob/living/carbon/human/M in targets)
		if(!HAS_TRAIT(M, TRAIT_ZOMBIE_IMMUNE) && ishuman(M) && M.mind)
			if (M.stat < DEAD)
				to_chat(user, span_notice("They are still alive!"))
				revert_cast()
			else
				playsound(get_turf(M), 'sound/magic/magnet.ogg', 80, TRUE, soundping = TRUE)
				user.visible_message("[user] mutters an incantation and [M] twitches with unnatural life!")
				M.zombie_check_can_convert()
				var/datum/antagonist/zombie/Z = M.mind.has_antag_datum(/datum/antagonist/zombie)
				if(Z)
					Z.wake_zombie(TRUE)
				M.emote("scream")
		else
			to_chat(user, span_notice("They can not be risen!"))
			revert_cast()

	return
