extends Node2D

export var speed := 37.5
export var lifetime := 0.5

onready var _anim_sprite := $AnimatedSprite
onready var _explosion := $Particles2D
onready var _hitbox := $HitBox
onready var _queue_timer := $Timer
onready var _lifetime_timer := $Lifetime
onready var _light := $Light2D

var direction := Vector2.ZERO

func _ready():
# warning-ignore:return_value_discarded
	_queue_timer.connect("timeout", self, "queue_free")
# warning-ignore:return_value_discarded
	_hitbox.connect("body_entered", self, "destroy")
# warning-ignore:return_value_discarded
	_lifetime_timer.connect("timeout", self, "lifetime_runout")
	
	_lifetime_timer.wait_time = lifetime
	set_as_toplevel(true)
	look_at(position + direction)
	
	_lifetime_timer.start()

# warning-ignore:unused_argument
func _physics_process(delta):
	position += direction * speed * delta
	_anim_sprite.play("Fireball")

func destroy(body: Node):
	if body:
		speed = 0.0
		_explosion.emitting = true
		_queue_timer.start()
		_anim_sprite.visible = false
		_light.visible = false

func lifetime_runout():
	speed = 0.0
	_explosion.emitting = true
	_queue_timer.start()
	_anim_sprite.visible = false
	_light.visible = false
