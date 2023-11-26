extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var switch = 0

var point1
var point2
# Called when the node enters the scene tree for the first time.
func _ready():
	point1 = $Position2D.global_position.x
	point2 = $Position2D2.global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(position.x > point1 && switch == 0):
		position.x -= 1
	else:
		switch = 1
	if(position.x < point2 && switch == 1):
		position.x += 1
	else:
		switch = 0
