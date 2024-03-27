extends Node3D
@onready var player := $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	print('in jump')
	if player.linear_velocity.y <= 0:
		player.transition_state('fall')
		print("falling?")

func transition():
	player.apply_central_impulse(Vector3.UP * 15)
