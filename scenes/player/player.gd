extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var max_hp = 100
var current_hp = 100

@onready var health_bar = $cam/playerCamera/healthbar
@onready var player_sprite = $playersprite
@onready var areaCollision = $colArea
@onready var rayMan = $rayMan
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var canGetHit = true


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
		$walk.play()
		
		
	move_and_slide()
	check_for_mobs()
	cam_rot()
	



func _process(delta):
	sprite_face_player()


func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()


func check_for_mobs():
	if canGetHit:
		var overLapBodies = areaCollision.get_overlapping_areas()
		for i in overLapBodies:
			var parent = i.get_parent()
			if i.name == "mobArea":
				get_hit(parent)
				canGetHit = false
				$push.play()
	else:
		return
	
	#print(len(overLapBodies))
	#if len(overLapBodies) > 2:
		#for i in overLapBodies:
			#if i.name == "mob":
				#get_hit(i)



func cam_rot():
	if Input.is_action_pressed("cam_right"):
		self.rotation.y -= 0.05

	if Input.is_action_pressed("cam_left"):
		self.rotation.y += 0.05
	
	
func sprite_face_player():
	var cam_pos = $cam/playerCamera.global_position
	cam_pos.y -= 2.5
	player_sprite.rotation.x = 10	 # change this to change the rotat of the sprite facing player
	player_sprite.look_at(cam_pos)
	
	
	

func _ready():
	healthBarRefresh()


func get_hit(body):
	var mob_pos = body.global_position
	var hit = mob_pos - self.global_position
	var dire = hit.normalized()
	
	velocity.x -= dire.x * 20
	velocity.z -= dire.z * 20
	
	#body is enemy here
	body.velocity.x += dire.x * 15
	body.velocity.z += dire.z * 15
	
	health_do(-10)
	

func shoot():
	var obj = $rayMan.get_collider()
	if obj == null:
		return
	
	var parent = obj.get_parent()
	if obj.name == "mobArea":
		parent.damage_process(self.position)
	
func _on_col_area_area_exited(area):
	canGetHit = true


func _on_col_area_area_entered(area):
	var mob = area.get_parent()
	# could if it but faster this way
	get_hit(mob)




func healthBarRefresh():
	health_bar.value = current_hp
	
	#every loop sets max lmao
	health_bar.max_value = max_hp
	

func health_do(nr):
	
	current_hp += nr
	
	healthBarRefresh()
	


func _on_health_regen_timeout():
	if current_hp < 100:
		current_hp += 2
		healthBarRefresh()
