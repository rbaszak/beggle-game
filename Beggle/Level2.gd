extends Node2D


# Declare member variables here. Examples:
# var a = 2
var rng = RandomNumberGenerator.new()

var powerupReady = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Vars.array.clear()
	Vars.activeBallsArr.clear()
	Vars.orangePegs.clear()
	if(Vars.marcinMode):
		Vars.balls = 5
	else:
		Vars.balls = 7
	Vars.points = 0
	Vars.pegsHit = 0
	Vars.locked = 0
	Vars.pointsHit = 0
	rng.randomize()
	while(Vars.orangePegs.size()<10):
		var rand_peg_no = rng.randi_range(0, 40)
		var wr = weakref(Vars.activePegs[rand_peg_no])
		if (wr.get_ref()):
			if(wr.get_ref().isOrange==false):
				wr.get_ref().isOrange = true
				Vars.orangePegs.append(Vars.activePegs[rand_peg_no])
	while(!powerupReady):
		var rand_peg_no = rng.randi_range(0, 40)
		var wr = weakref(Vars.activePegs[rand_peg_no])
		if (wr.get_ref()):
			if(wr.get_ref().isOrange==false):
				wr.get_ref().isPowerup = true
				wr.get_ref().name = "PegPower"
				powerupReady = true
	for i in range(0, Vars.activePegs.size()):
		Vars.activePegs[i]._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PegWheel.rotation_degrees += 20 * delta
	$Label.text = "Balls: " + str(Vars.balls)
	$PointLabel.text = "Score:\n" + str(Vars.points)
	if(Vars.orangePegs.empty()):
		$FinishPolygon.visible = true
		get_tree().paused = true

func _on_CheckButton_pressed():
	if(Music.playing):
		Vars.musicStop = Music.get_playback_position()
		Music.stop()
	else:
		Music.play(Vars.musicStop)

func _on_MarcinModeButton_pressed():
	if(Vars.marcinMode):
		Vars.marcinMode = false
	else:
		Vars.marcinMode = true
	$Button.emit_signal("pressed")
