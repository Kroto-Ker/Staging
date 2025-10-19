
/obj/item/bomb
	name = "bottle bomb"
	desc = "A fiery explosion waiting to be coaxed from its glass prison."
	icon_state = "bbomb"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	//dropshrink = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	var/fuze = null //randomized on init
	var/lit = FALSE
	var/prob2fail = 5
	grid_width = 32
	grid_height = 64

/obj/item/bomb/Initialize()
	. = ..()
	fuze = rand(40,60)

/obj/item/bomb/spark_act()
	light()

/obj/item/bomb/fire_act()
	light()

/obj/item/bomb/ex_act()
	if(!QDELETED(src))
		lit = TRUE
		explode(TRUE)

/obj/item/bomb/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = "bbomb-lit"
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/bomb/extinguish()
	snuff()

/obj/item/bomb/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = "bbomb"
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/bomb/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				explosion(T, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
		else
			if(prob(prob2fail))
				snuff()
			else
				playsound(T, 'sound/items/firesnuff.ogg', 100)
				new /obj/item/natural/glass_shard (T)
	qdel(src)

/obj/item/bomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	explode()

/obj/item/bomb/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/smokebomb
	name = "smoke bomb"
	desc = "A soft sphere with an alchemical mixture and a dispersion mechanism hidden inside. Any pressure will detonate it."
	icon_state = "smokebomb"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	//dropshrink = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	grid_width = 32
	grid_height = 32

/obj/item/smokebomb/attack_self(mob/user)
    ..()
    explode()

/obj/item/smokebomb/ex_act()
	if(!QDELETED(src))
		..()
	explode()

/obj/item/smokebomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	explode()

/obj/item/smokebomb/proc/explode()
    STOP_PROCESSING(SSfastprocess, src)
    var/turf/T = get_turf(src)
    if (!T) return
    playsound(src.loc, 'sound/items/smokebomb.ogg', 50)
    var/radius = 3
    var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread
    S.set_up(radius, T)
    S.start()
    new /obj/item/ash(T)
    qdel(src)

/obj/item/tntstick
	name = "blackpowder stick"
	desc = "A bit of gunpowder in paper shell..."
	icon_state = "dinamite"
	var/lit_state = "dinamitelit"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	var/fuze = 50
	var/lit = FALSE
	var/prob2fail = 1 

/obj/item/tntstick/spark_act()
	light()

/obj/item/tntstick/fire_act()
	light()

/obj/item/tntstick/ex_act()
	if(!QDELETED(src))
		lit = TRUE
		explode(TRUE)

/obj/item/tntstick/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = lit_state
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/tntstick/extinguish()
	snuff()

/obj/item/tntstick/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = initial(icon_state)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/tntstick/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				explosion(T, devastation_range = 2, heavy_impact_range = 3, light_impact_range = 4, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
				qdel(src) //IMPORTANT!! go into walls /turf/closed/wall/ and see /turf/closed/wall/ex_act. Its bounded with /proc/explosion. Same for /obj/structure and /obj/structure/ex_act because if you going to fuck intergity or whatever this shit called players will skin you alive for breaking their equipment and keys
		else //also /turf/open/floor/ex_act for comment above
			if(prob(prob2fail))
				snuff()

/obj/item/tntstick/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/satchel_bomb
	name = "bomb satchel"
	desc = "A satchel full of gunpowder..."
	icon_state = "dinamitesatchel"
	var/lit_state = "dinamitesatchellit"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_BULKY 
	throwforce = 0
	throw_range = 2
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.3
	var/fuze = 50
	var/lit = FALSE
	var/prob2fail = 1 

/obj/item/satchel_bomb/spark_act()
	light()

/obj/item/satchel_bomb/fire_act()
	light()

/obj/item/satchel_bomb/ex_act()
    if(!QDELETED(src))
        lit = TRUE
        explode(TRUE)

/obj/item/satchel_bomb/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = lit_state
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/satchel_bomb/extinguish()
	snuff()

/obj/item/satchel_bomb/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = initial(icon_state)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/satchel_bomb/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				explosion(T, devastation_range = 3, heavy_impact_range = 5, light_impact_range = 8, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
				qdel(src)

		else
			if(prob(prob2fail))
				snuff()

/obj/item/satchel_bomb/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)		


/obj/item/impact_grenade
	name = "impact grenade"
	desc = "Some substance, hidden under paper"
	icon_state = "impactgrenade"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 1

	// Define a base explodes() proc that subtypes can override because its now explodes proc
	proc/explodes()
		STOP_PROCESSING(SSfastprocess, src)
		qdel(src) // Delete the grenade after use boy (ALWAYS USE IT)

/obj/item/impact_grenade/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	explodes() //

/obj/item/impact_grenade/attack_self(mob/user)
	..()
	explodes() 

/obj/item/impact_grenade/explosion
	name = "Impact grenade"
	desc = "Some substance, hidden under some paper and skin. This one sparks..."

	explodes() 
		STOP_PROCESSING(SSfastprocess, src)
		var/turf/T = get_turf(src)
		if(T)
			explosion(T, heavy_impact_range = 1, light_impact_range = 2, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
			qdel(src)

/obj/item/impact_grenade/smoke
	name = "Impact grenade"
	desc = "Some substance, hidden under some paper and skin. This one emits clouds of harmless smoke..."

	explodes()
		STOP_PROCESSING(SSfastprocess, src)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
		for(T in view(1, T))
			new /obj/effect/particle_effect/smoke(T)
		qdel(src)

/obj/item/impact_grenade/poison_gas
	name = "Impact grenade"
	desc = "Some substance, hidden under some paper and skin. The smell of this one makes you to gasp..."

	explodes() 
		STOP_PROCESSING(SSfastprocess, src)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
		for(T in view(2, T))
			new /obj/effect/particle_effect/smoke/poison_gas(T)
		qdel(src)

/obj/item/impact_grenade/healing_gas
	name = "impact grenade"
	desc = "Some substance, hidden under some paper and skin. The smell of this one reminds you the taste of red..."

	explodes() 
		STOP_PROCESSING(SSfastprocess, src)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
		for(T in view(2, T))
			new /obj/effect/particle_effect/smoke/healing_gas(T)
		qdel(src)

/obj/item/impact_grenade/fire_gas
	name = "impact grenade"
	desc = "Some substance, hidden under some paper and skin. Smells like a chicken and burns your hand..."

	explodes() 
		STOP_PROCESSING(SSfastprocess, src)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
		for(T in view(2, T))
			new /obj/effect/particle_effect/smoke/fire_gas(T)
		qdel(src)

/obj/item/impact_grenade/blind_gas
	name = "impact grenade"
	desc = "Some substance, hidden under some paper and skin. The smell that comes from this one makes your eyes to cry."

	explodes() 
		STOP_PROCESSING(SSfastprocess, src)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
		for(T in view(2, T))
			new /obj/effect/particle_effect/smoke/blind_gas(T)
		qdel(src)

/obj/item/impact_grenade/mute_gas
	name = "impact grenade"
	desc = "Some substance, hidden under some paper and skin. Smell of this one makes your mind clean and not able to say a word."

	explodes() 
		STOP_PROCESSING(SSfastprocess, src)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
		for(T in view(2, T))
			new /obj/effect/particle_effect/smoke/mute_gas(T)
		qdel(src)		
