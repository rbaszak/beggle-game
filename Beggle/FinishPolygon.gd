extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Level2.tscn")
	for i in range(0, Vars.array.size()):
			Vars.array[i].queue_free()
	for i in range(0, Vars.activeBallsArr.size()):
		Vars.activeBallsArr[i].queue_free()
	for i in range(0, Vars.activePegs.size()):
		var wr = weakref(Vars.activePegs[i])
		if (wr.get_ref()):
			if(wr.get_ref().get_node("CollisionShape2D").disabled==true):
				wr.get_ref().get_node("CollisionShape2D").disabled = false
			else:
				break
	Vars.activePegs.clear()
