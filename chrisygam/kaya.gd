extends Node3D
@onready var camera = $"../../TwistPivot/PitchPivot/Camera3D"
@onready var player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  not Input.is_action_pressed('pan'):
		rotation.y = player.moving_direction
	if player.moving_horizontal:
		if player.grounded:
			if player.current_state == 'crouch':
				$AnimationPlayer.play('walking_crouched/mixamo_com')
			else:
				$AnimationPlayer.play('walking_normal/mixamo_com')
		
		$AnimationPlayer.speed_scale = Vector3(player.linear_velocity.x, 0, player.linear_velocity.z).length() / 2
		
	else:
		$AnimationPlayer.pause()
