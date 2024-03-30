extends Label3D
@onready var player := $".."
@onready var camera := $"../TwistPivot/PitchPivot/Camera3D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(player.current_state)
