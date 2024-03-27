extends RigidBody3D

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var collision_shape := $CollisionShape3D

@onready var state_machine = {
	'idle' = $state/idle,
	'walk' = $state/walk,
	'run' = $state/run,
	'jump' = $state/jump,
	'fall' = $state/fall,
}
var current_state := 'idle';
var states_stack = []

var mouse_sensitivity := .001
var twist_input := 0.0
var pitch_input := 0.0

var grounded := false
var jump := false
var moving_horizontal := false
var moving_vertical := false
var feet_collisions = []

##--- SPEED VARS ---##
var walk_max_speed = 5.0
var walk_accel = 2000.0

var run_max_speed = 7.0
var run_accel = 2250.0

var air_max_speed = 20
var air_accel = 500

var max_speed = walk_max_speed
var accel = walk_accel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	jump = Input.is_action_just_pressed("jump") && grounded
	state_machine[current_state].update(delta)
	##--- Player movement ---##
	var input := Vector3.ZERO
	
	if current_state == 'run':
		max_speed = run_max_speed
		accel = run_accel
	elif not grounded:
		max_speed = air_max_speed
		accel = air_accel
	else:
		max_speed = walk_max_speed
		accel = walk_accel
		
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("up", "down")
	apply_central_force(twist_pivot.basis * input * accel * delta)
	
	if linear_velocity.x > max_speed:
		linear_velocity.x = max_speed
	elif linear_velocity.x < -max_speed:
		linear_velocity.x = -max_speed
		
	if linear_velocity.z > max_speed:
		linear_velocity.z = max_speed
	elif linear_velocity.z < -max_speed:
		linear_velocity.z = -max_speed
	
	##--- Free Mouse on esc ---##
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	##--- Camera Movement ---##
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(-30),
		deg_to_rad(30))
		
	twist_input = 0.0
	pitch_input = 0.0
	
	##--- State related flags ---##
	if feet_collisions.size() > 0:
		grounded = true
	else:
		grounded = false
		
	if abs(linear_velocity.x) < .005 && abs(linear_velocity.z) < .005:
		moving_horizontal = false
	else:
		moving_horizontal = true
		
	if abs(linear_velocity.y) < .005:
		moving_vertical = false
	else:
		moving_vertical = true
	
func transition_state(new_state):
	current_state = new_state
	states_stack.push_front(new_state)
	state_machine[current_state].transition()

##--- Camera Movement ---##
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity

func _on_feet_body_entered(body):
	if body != self:
		feet_collisions.append(body)

func _on_feet_body_exited(body):
	if body != self:
		feet_collisions.erase(body)
