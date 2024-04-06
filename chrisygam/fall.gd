extends Node3D
@onready var player := $"../.."
var fall_max_speed = 6
var fall_accel = 800

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if player.grounded:
		player.transition_state('land')

func transition():
	player.max_speed = fall_max_speed
	player.accel = fall_accel
	player.gravity_scale = 2.8
