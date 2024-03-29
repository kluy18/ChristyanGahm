extends Node3D
@onready var player := $"../.."
var crouch_max_speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if Input.is_action_pressed("crouch"):
		player.transition_state("crouch")
	elif not player.crouch:
		player.transition_state("idle")

func transition():
	player.max_speed = crouch_max_speed
