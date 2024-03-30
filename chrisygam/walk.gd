extends Node3D
@onready var player := $"../.."
var walk_max_speed = 3.0
var walk_accel = 2250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if not player.grounded:
		player.transition_state('fall')
	elif not player.moving_horizontal:
		player.transition_state('idle')
	elif Input.is_action_pressed("sprint"):
		player.transition_state('run')
	elif Input.is_action_pressed("crouch"):
		player.transition_state('crouch')
	elif player.jump:
		player.transition_state('jump')
	

func transition():
	player.max_speed = walk_max_speed
	player.accel = walk_accel
