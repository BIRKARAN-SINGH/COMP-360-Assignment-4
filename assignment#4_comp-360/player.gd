extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var pivot: Node3D = $camOrigin
@export var sens=0.5
@onready var Ray_Cast=$camOrigin/SpringArm3D/Camera3D/RayCast3D
var object_held: RigidBody3D
@onready var camera = $camOrigin/SpringArm3D/Camera3D
@onready var grab =$"../arm/Armature/Grab"
@onready var ball_material = $"../Ball/MeshInstance3D".material_override  # Reference to the ball's material



@export_group("Holding Objects")
@export var throwPower = 7.5
@export var pullSpeed = 5.0
@export var following = 2.5

var pickedObject

func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
		# Connect Area3D signals
	grab.connect("body_entered", Callable(self, "_on_body_entered"))
	grab.connect("body_exited", Callable(self, "_on_body_exited"))

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y*sens))
		pivot.rotation.x=clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		



func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()* delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func set_object_held(body):
	if body is RigidBody3D:
		object_held = body
		
func dropping_object_held():
	object_held = null
	
func throwing_object_held():
	var obj = object_held
	dropping_object_held()
	obj.apply_central_impulse(-camera.global_basis.z * throwPower * 10)	

func control_holding_objects():
	# Throwing Object
	if Input.is_action_just_pressed("letgo"):
		if object_held != null:
			throwing_object_held()
			
	# Dropping Object
	if Input.is_action_just_pressed("grab"):
		if object_held != null:
			dropping_object_held()
		elif Ray_Cast.is_colliding():
			set_object_held(Ray_Cast.get_collider())

	# Object Following
	if object_held != null:
		var targetPos = camera.global_transform.origin + (camera.global_basis * Vector3(0, 0, -following))  # Object held in front of arm
		var objectPos = object_held.global_transform.origin  
		object_held.linear_velocity = (targetPos - objectPos) * pullSpeed 

#func _on_body_entered(body):
	#if body.name == "Ball":  
		#print("Ball entered grabbing area!")
		#highlight_grabbing_area(true)
#
## Handle when a body exits the grabbing area
#func _on_body_exited(body):
	#if body.name == "Ball":  
		#print("Ball exited grabbing area!")
		#highlight_grabbing_area(false)
#
#func highlight_grabbing_area(enable):
	#if enable:
		#ball_material.albedo_color = Color(1, 0, 0)  # Change to red when in grabbing area
	#else:
		#ball_material.albedo_color = Color(1, 1, 1)  # Reset to white when out of grabbing area
