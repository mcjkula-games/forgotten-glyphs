extends KinematicBody2D

var min_speed = 750.0
var max_speed = 999.0

var min_accel = 999.0
var max_accel = 999.0
var velocity = Vector2.ZERO

var player = null
var amount = 5

onready var detection_zone := $DetectionZone
onready var object := $Object

onready var collision := $DetectionZone/CollisionShape2D

func _ready():
# warning-ignore:return_value_discarded
	detection_zone.connect("body_entered", self, "flow_towards_player")
# warning-ignore:return_value_discarded
	object.connect("body_entered", self, "gain_experience_to")
# warning-ignore:return_value_discarded
	detection_zone.connect("body_exited", self, "flow_towards_zero")

	recheck_collision()

func _physics_process(delta):
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * rand_range(min_speed, max_speed), rand_range(min_accel, max_accel) * delta)
	else:
		velocity = velocity.move_toward(Vector2(0, 0), rand_range(min_accel, max_accel))
	velocity = move_and_slide(velocity, Vector2.DOWN)

func flow_towards_player(body: Player):
	player = body

func flow_towards_zero(_body: Player):
	player = null

func gain_experience_to(_p: Player):
	if _p != null:
		Events.emit_signal("experience_collected", amount)
		queue_free()

func recheck_collision() -> void:
	collision.disabled = true
	collision.disabled = false
