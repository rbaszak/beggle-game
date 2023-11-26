extends RigidBody2D
# Declare member variables here. Examples:
export (Vector2) var start
export (Vector2) var dir
export (int) var first = 1
export (int) var speed = 1

var rng = RandomNumberGenerator.new()
const INDICATOR = preload("res://FreeBallIndicator.tscn")
var marian = Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	dir = -(position - start).normalized()
	for i in range(0, Vars.activePegs.size()):
		var wr = weakref(Vars.activePegs[i])
		if (wr.get_ref()):
			wr.get_ref().get_node("CollisionShape2D").disabled = true
	marian = get_tree().get_root().find_node("Marian",true,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(first):
		linear_velocity = dir * delta * 60000 * speed
		first = 0

signal playSound

func _on_Area2D_area_entered(area):
	if(area.name != "PegArea"):
		print(area.name)
		if(area.name == "BasketArea"):
			spawn_indicator()
			print("Free Ball!")
			Vars.balls += 1
		print("Ball destroyed")
		Vars.locked = 0
		marian.visible = false
		queue_free()
		for i in range(0, Vars.array.size()):
			Vars.activePegs.erase(Vars.array[i])
			if(Vars.array[i].isOrange):
				Vars.orangePegs.erase(Vars.array[i])
			Vars.array[i].queue_free()
			Vars.pointsHit += 100
			Vars.points += 100
		if(Vars.pegsHit>4):
			Vars.pointsHit += 100 * Vars.pegsHit
			Vars.points += 100 * Vars.pegsHit
		if(Vars.pegsHit==0):
			var rand = rng.randi_range(0, 1)
			if(rand==1):
				spawn_indicator()
				print("Free Ball!")
				Vars.balls += 1
			else:
				emit_signal("playSound")
		Vars.pegsHit = 0
		if(Vars.pointsHit >= 2000):
			spawn_indicator()
			print("Free Ball!")
			Vars.balls += 1
		else:
			emit_signal("playSound")
		Vars.pointsHit = 0
		Vars.array.clear()
		get_tree().get_root().find_node("Multikill",true,false).visible = false

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position):
	if EFFECT:
		var effect = EFFECT.instance()
		get_tree().current_scene.add_child(effect)
		effect.global_position = get_tree().get_root().find_node("Plus1Position",true,false).position

func spawn_indicator():
	var indicator = spawn_effect(INDICATOR)
