extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 5.5
const LERP_VAL = .15
var held_object = null



@onready var armature=$Armature
@onready var pivot: Node3D = $camOrigin
@onready var anim_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var camera = $camOrigin/SpringArm3D/Camera3D

@export_category("Holding Objects")
@export var throwForce = 7.5
@export var followSpead = 5.0
@export var followDistance = 2.5
@export var maxDistanceFromCanere = 5.0
@export var dropBelomPLayer = false

@onready var InteractRay=$camOrigin/SpringArm3D/Camera3D/InteractRay
var heldObject: RigidBody3D

@export var sens=0.5


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_grabbing: bool = false

func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y*sens))
		pivot.rotation.x=clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	if Input.is_action_pressed("grab"):
		if not is_grabbing:
			animation_player.play("grab")
			is_grabbing = true

	elif Input.is_action_pressed("letgo"):
		if is_grabbing:
			animation_player.play("letgo")
			is_grabbing = false
func _physics_process(delta: float) -> void:
	
	handle_holding_objects()
	
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
		#armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x,-velocity.z),LERP_VAL)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func set_held_object(body: RigidBody3D):
	if body is RigidBody3D:
		heldObject=body

func drop_held_object():
	heldObject=null

func throw_held_object():
	var obj = heldObject
	drop_held_object()
	obj.apply_central_impulse(-camera.global_transform.basis.z * throwForce * 10)
		
func handle_holding_objects():
	if Input.is_action_just_pressed("grab"):
		if heldObject != null :throw_held_object()
		
	if Input.is_action_just_pressed("interact"):
		if heldObject !=null: drop_held_object()
		elif InteractRay.is_colliding(): set_held_object(InteractRay.get_collider())
		
	if heldObject !=null:
		var targetpos= camera.global_transform.origin + (camera.global_basis*Vector3(0,0,-followDistance))
		var objectPos= heldObject.global_transform.origin
		heldObject.linear_velocity=(targetpos-objectPos)*followSpead
		
		if heldObject.global_position.distance_to(camera.global_position)> maxDistanceFromCanere:
			drop_held_object()
			
