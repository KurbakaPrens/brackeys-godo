extends CharacterBody2D


const SPEED = 180.0
const JUMP_VELOCITY = -380.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $jump_sound
@onready var coyote_timer = $CoyoteTimer
@export var Coyote_Time = 0.1

var Jump_Available: bool = true


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Jump_Available:
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time)
			#get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		velocity.y += gravity * delta
	else:
		Jump_Available = true
		coyote_timer.stop()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and Jump_Available:
		velocity.y = JUMP_VELOCITY
		Jump_Available = false
		jump_sound.play()

	#Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
		
		
	#Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	if Input.is_action_just_pressed("drop_down") and is_on_floor():
		position.y += 1

	move_and_slide()
	
func Coyote_Timeout():
	Jump_Available = false


func _on_coyote_timer_timeout():
	Jump_Available = false
