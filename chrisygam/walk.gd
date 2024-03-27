extends Node3D
@onready var player := $"../.."

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
	if player.jump:
		player.transition_state('jump')

func transition():
	pass
