extends Node3D
@onready var player := $"../.."

var run_max_speed = 5.0
var run_accel = 1750.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if not player.grounded:
		player.transition_state('fall')
	elif player.jump:
		player.transition_state('jump')
	elif Input.is_action_just_released("sprint"):
		player.transition_state('walk')

func transition():
	player.max_speed = run_max_speed
	player.accel = run_accel
