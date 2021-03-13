extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

enum {MOVE, ROLL, ATTACK}

var state
var velocity = Vector2.ZERO
# this allows us to role in the direction of movement. (we start by facing down,
#   so start roll vector as down.
var roll_vector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox


func _ready():
	state = MOVE
	animationTree.active = true
	animationTree.set("parameters/Idle/blend_position", Vector2.DOWN)
	# keep this the same as our movement direction
	swordHitbox.knockback_vector = roll_vector
	
 
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		
func move_state(delta:float):
	var input_vector:Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector 
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func attack_state(delta:float):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	# Note: move_and_slide handles (* delta) for us  
	velocity = move_and_slide(velocity)
	
func on_attack_animation_finished():
	state = MOVE

func on_roll_animation_finished():
	# reduce so we don't slide as much at end of roll
	velocity = velocity * 0.8
	state = MOVE
	
	
	
