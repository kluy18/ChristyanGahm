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
	'land' = $state/land,
	'crouch' = $state/crouch,
}
var current_state := 'idle';
var states_stack = []

var mouse_sensitivity := .001
var twist_input := 0.0
var pitch_input := 0.0
var look_basis = 0

var grounded := false
var jump := false
var crouch := false

var moving_horizontal := false
var inputting_horizontal := false
var moving_vertical := false

var feet_collisions = []

var input := Vector3.ZERO

##--- SPEED VARS ---##
var max_speed := 3
var accel := 2250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grounded:
		linear_damp = 5
	else:
		linear_damp = 0.5
		
	jump = Input.is_action_just_pressed("jump") && grounded
	crouch = Input.is_action_pressed("crouch") && grounded
			
	##--- Player movement ---##
	input = Vector3.ZERO
		
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("up", "down")
	
	if not Input.is_action_pressed('pan'):
		look_basis = twist_pivot.basis
	
	apply_central_force(look_basis * input * accel * delta)
	
	if Vector3(linear_velocity.x, 0, linear_velocity.z).length() > max_speed:
		var temp = Vector3(linear_velocity.x, linear_velocity.y, linear_velocity.z).normalized() * (max_speed - .001)
		linear_velocity.x = temp.x
		linear_velocity.y = temp.y
		linear_velocity.z = temp.z

	state_machine[current_state].update(delta)
	
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
	
	if abs(input.x) > 0 || abs(input.z) > 0:
		inputting_horizontal = true
	else:
		inputting_horizontal = false
		
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
