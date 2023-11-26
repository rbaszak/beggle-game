extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const INDICATOR = preload("res://HitIndicator.tscn")

var isPowerup = false
var active = 1
var played = false
var isOrange = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Vars.activePegs.append(self)
	if(isPowerup):
		$Sprite.texture = load("res://peg_green.png")
	elif(isOrange):
		$Sprite.texture = load("res://peg_orange.png")
	else:
		$Sprite.texture = load("res://peg_blue.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
var marian = Sprite
#	pass
signal powerup

func _on_Area2D_area_entered(area):
	if(isPowerup && active ==1):
		print("Marian złapany")
		marian = get_tree().get_root().find_node("Marian",true,false)
		marian.visible = true
		$PowerSound.play()
		emit_signal("powerup")
	if(active == 1):
		var timer = Timer.new()
		timer.connect("timeout",self,"_on_timer_timeout")
		add_child(timer)
		timer.set_wait_time(4)
		timer.start()
		print("Bonk")
		if(Vars.pegsHit > 4):
			get_tree().get_root().find_node("Multikill",true,false).visible = true
		spawn_indicator()
		if(isPowerup):
			$Sprite.texture = load("res://peg_green2.png")
		elif(isOrange):
			$Sprite.texture = load("res://peg_orange2.png")
		else:
			$Sprite.texture = load("res://peg_blue2.png")
		Vars.array.append(self)
		Vars.pegsHit += 1
		active = 0
	if(area.name == "PowerBallArea"):
		kill()
	

func kill():
	Vars.activePegs.erase(self)
	Vars.array.erase(self)
	Vars.pointsHit += 100
	Vars.points += 100
	if(isOrange):
		Vars.orangePegs.erase(self)
	queue_free()

func _on_timer_timeout():
	kill()

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = effect_position

func spawn_indicator():
	var indicator = spawn_effect(INDICATOR)
