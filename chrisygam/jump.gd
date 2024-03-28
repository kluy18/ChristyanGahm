extends Node3D
@onready var player := $"../.."
@onready var feet := $"../../Feet"
@onready var timer := $"../../Timer"
var jump_max_speed = 10
var jump_accel = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if timer.is_stopped():
		if player.linear_velocity.y <= 0:
			player.transition_state('fall')
		if player.grounded:
			player.transition_state('land')

func transition():
	player.max_speed = jump_max_speed
	player.accel = jump_accel
	player.apply_central_impulse(Vector3.UP * 5)
	timer.start(.2)
