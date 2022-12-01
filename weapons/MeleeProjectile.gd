extends Node2D

export var speed := 37.5
export var lifetime := 0.5

onready var _anim_sprite := $AnimatedSprite

var direction := Vector2.ZERO

func _ready():
# warning-ignore:return_value_discarded
	_anim_sprite.connect("animation_finished", self, "destroy")
	
	set_as_toplevel(true)
	look_at(position + direction)

# warning-ignore:unused_argument
func _physics_process(delta):
	position += direction * speed * delta
	_anim_sprite.play("Aerial Splash")
	

func destroy():
	queue_free()
