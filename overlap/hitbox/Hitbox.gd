class_name Hitbox
extends Area2D

#export var damage = 0
#export var critical_chance = 0

#var crit_calulation = critical_chance / 100

#func crit():
#	var probability = randf()
#	if (probability > crit_calulation):
#		damage = damage * 2
#	else:
#		damage = damage
#	return damage
