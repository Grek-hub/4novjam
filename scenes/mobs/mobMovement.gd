extends CharacterBody3D


var speed = 2
var accel = 10
@onready var player = get_parent().get_parent().get_node("player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var nav: NavigationAgent3D = $navEng

func _physics_process(delta):
	
	
	
	var dire = Vector3()
	
	nav.target_position = player.global_position
	dire = nav.get_next_path_position() - global_position
	
	dire = dire.normalized()
	velocity = velocity.lerp(dire * speed, accel * delta )
	
	sprite_face_player()
	move_and_slide()




func sprite_face_player():
	var cam_pos = player.get_node("cam/playerCamera").global_position
	#print(cam_pos)
	self.rotation.x = 10	 # change this to change the rotat of the sprite facing player
	self.look_at(cam_pos)
	
