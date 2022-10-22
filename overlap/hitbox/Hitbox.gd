class_name Hitbox, "HitBox.svg"
extends Area2D

export var damage = 0
export var critical_chance := 1.0

var crit_happened = false

func _ready():
# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "_hit_body")

func crit():
	var cc = critical_chance / 100
	
	var prob = rand_range(0.0, 1.0)
	if prob < cc:
		Events.emit_signal("crit_happened_t")
		if not crit_happened:
			damage = damage * 2
		crit_happened = true
		damage = damage
	else:
		Events.emit_signal("crit_happened_f")
		if crit_happened:
# warning-ignore:integer_division
			damage = damage / 2
		crit_happened = false
		damage = damage
	return damage
	
func _hit_body(body: Node) -> void:
	if not body.has_method("take_damage"):
		return
	body.take_damage(crit())
