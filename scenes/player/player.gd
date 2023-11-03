extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var player_sprite = $playersprite
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("m_up", "m_down", "m_right", "m_left")
	
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	#print(self.global_position)
	
	cam_rot()
	



func _process(delta):
	sprite_face_player()


func cam_rot():
	if Input.is_action_pressed("cam_right"):
		self.rotation.y -= 0.025

	if Input.is_action_pressed("cam_left"):
		self.rotation.y += 0.025
	
	
func sprite_face_player():
	var cam_pos = $cam/playerCamera.global_position
	player_sprite.rotation.x = 10	 # change this to change the rotat of the sprite facing player
	player_sprite.look_at(cam_pos)
	
