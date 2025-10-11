
/obj/effect/proc_holder/spell/invoked/projectile/spitfire
	name = "Spitfire"
	desc = "Shoot out a low-powered ball of fire that shines brightly on impact, potentially blinding a target. \n\
	Damage is increased by 100% versus simple-minded creechurs."
	clothes_req = FALSE
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue2
	overlay_state = "fireball_multi"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE
	releasedrain = 30
	chargedrain = 1
	chargetime = 1
	recharge_time = 4 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocation = "Evomere Flammas!"
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	cost = 3

/obj/projectile/magic/aoe/fireball/rogue2
	name = "spitfire"
	exp_heavy = 0
	exp_light = 0
	exp_flash = 1
	exp_fire = 0
	damage = 20
	npc_damage_mult = 2 // Makes it more effective against NPCs.
	damage_type = BURN
	nodamage = FALSE
	flag = "magic"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0

/obj/projectile/magic/aoe/fireball/rogue2/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(L.has_status_effect(/datum/status_effect/buff/frost) || L.has_status_effect(/datum/status_effect/buff/frostbite))
				visible_message(span_warning("[src] extinguishes on contact with [target]!"))
				playsound(get_turf(target), 'sound/items/firesnuff.ogg', 100)
				L.remove_status_effect(/datum/status_effect/buff/frost)
				L.remove_status_effect(/datum/status_effect/buff/frostbite)
				qdel(src)
				return BULLET_ACT_BLOCK
			new /obj/effect/temp_visual/snap_freeze(get_turf(L))
	qdel(src)
