/obj/effect/proc_holder/spell/invoked/silence
	name = "Silence"
	desc = "Quiet the target's tongue. Does not work against full-fledged mages."
	cost = 3
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 15
	recharge_time = 100 SECONDS
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "zizocloud"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	invocation = "Silentium"
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/silence/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC))
			to_chat(user, "<span class='warning'>The spell fizzles, it won't work on them!</span>")
			revert_cast()
			return
		if(HAS_TRAIT(target, TRAIT_ARCYNE_T3) || HAS_TRAIT(target, TRAIT_ARCYNE_T4))
			to_chat(user, "<span class='warning'>Their magic is too strong, it won't work on them!</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("The wind in my voice goes still. I can't speak!"))
		var/dur = max((10 * (user.get_skill_level(associated_skill))))
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
		return TRUE


/obj/effect/proc_holder/spell/invoked/silence/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
	to_chat(target, span_warning("My voice returns to me!"))
