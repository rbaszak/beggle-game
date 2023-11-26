extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var SPEED: int = 30
export(int) var FRICTION: int = 15
var SHIFT_DIRECTION: Vector2 = Vector2(1,-1)

onready var player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	player.set_current_animation("showPoint")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += SPEED * SHIFT_DIRECTION * delta
	SPEED = max(SPEED - FRICTION * delta, 0)
