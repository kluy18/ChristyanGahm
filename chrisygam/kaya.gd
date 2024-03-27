extends Node3D
@onready var camera = $"../TwistPivot/PitchPivot/Camera3D"
@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  not Input.is_action_pressed('pan'):
		look_at(Vector3(camera.global_position.x, 0, camera.global_position.z))
		rotation.x = 0
	if player.moving_horizontal:
		$AnimationPlayer.play('mixamo_com')
		$AnimationPlayer.speed_scale = max(abs(player.linear_velocity.x), abs(player.linear_velocity.z)) / 2
		
	else:
		$AnimationPlayer.pause()
