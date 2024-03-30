extends Node3D
@onready var player := $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if Input.is_action_pressed("sprint"):
		player.transition_state('run')
	elif player.moving_horizontal || player.inputting_horizontal:
		player.transition_state('walk')
	else:
		player.transition_state('idle')

func transition():
	player.gravity_scale = 2.8
