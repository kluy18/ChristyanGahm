extends Node3D
@onready var player := $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if player.moving_horizontal:
		if Input.is_action_pressed("sprint"):
			player.transition_state('run')
		else:
			player.transition_state('walk')
	if player.jump:
		player.transition_state('jump')

func transition():
	pass
