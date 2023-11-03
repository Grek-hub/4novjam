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



func damage_process(playerpos):
	take_hit(playerpos)
	#self.queue_free()


func sprite_face_player():
	var cam_pos = player.get_node("cam/playerCamera").global_position
	cam_pos.y -= 2.5
	#print(cam_pos) # change this to change the rotat of the sprite facing player
	$mobSprite.look_at(cam_pos)

func take_hit(playerpos):
	var mob_pos = global_position
	var hit = mob_pos - playerpos
	var dire = hit.normalized()
	
	velocity.x += dire.x * 25
	velocity.z += dire.z * 25
	
