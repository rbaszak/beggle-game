extends Node2D


var onButton = 0
var nextBall = 0
var connected = false

var scene = load("res://Ball.tscn")
var scene2 = load("res://PowerBall.tscn")

var reload = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if not Music.playing:
		Music.play()

func powerup():
	nextBall = 1

func playSound():
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(connected==false):
		var pointNode = get_tree().get_root().find_node("PegPower",true,false)
		if(pointNode!=null):
			print("Powerup connected!")
			pointNode.connect("powerup",self,"powerup")
			connected = true
		else:
			print("Powerup didn't connect :c")
	look_at(get_global_mouse_position())
	if(rotation_degrees < 0):
		rotation_degrees = 0
	elif(rotation_degrees > 180):
		rotation_degrees = 180
	var dir = get_global_mouse_position()
	if(Input.is_action_just_pressed("Click") && Vars.locked == 0 && Vars.balls>0 && onButton == 0 && nextBall == 0):
		var ball = scene.instance()
		ball.connect("playSound",self,"playSound")
		ball.start = dir
		ball.position = position
		get_parent().get_parent().add_child(ball)
		Vars.locked = 1
		Vars.balls -= 1
	elif(Input.is_action_just_pressed("Click") && Vars.locked == 0 && Vars.balls>0 && onButton == 0 && nextBall == 1):
		var powerBall = scene2.instance()
		powerBall.connect("playSound",self,"playSound")
		powerBall.start = dir
		powerBall.position = position
		get_parent().get_parent().add_child(powerBall)
		Vars.locked = 1
		Vars.balls -= 1
		nextBall = 0

func _on_Button_pressed():
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
	reload = true
	print(get_tree().reload_current_scene())

func _on_Button_focus_entered():
	onButton = 1

func _on_Button_focus_exited():
	onButton = 0

func _on_CheckButton_mouse_entered():
	onButton = 1

func _on_CheckButton_mouse_exited():
	onButton = 0

func _on_MarcinModeButton_mouse_entered():
	onButton = 1

func _on_MarcinModeButton_mouse_exited():
	onButton = 0
