extends KinematicBody2D

export(int) var FRICTION = 200
export(int) var KNOCKBACK_SPEED = 120
export(int) var ACCELERATION = 200
export(int) var MAX_SPEED = 50
# since they never get exactly to target (0), we need a small number
#   to signify "close enough"
export(int) var WANDER_TARGET_WOBBLE_BUFFER = 4

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurbox = $HurtBox
onready var softCollisions = $SoftCollision
onready var wanderController = $WanderController

func _ready():
	state = self.pick_random_state([WANDER, IDLE])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION*delta)
	knockback = move_and_slide(knockback)
	match state:
		
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta) 
			# stop wobbling on target position
			if self.global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_WOBBLE_BUFFER:
				update_wander()
			
		CHASE:
			var player = self.playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func accelerate_towards_point(target, delta):
	var direction = self.global_position.direction_to(target)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	# face direction we are moving
	sprite.flip_h = velocity.x < 0 

func update_wander():
	state = self.pick_random_state([WANDER, IDLE])
	wanderController.start_wander_timer(rand_range(1,3))
		
func pick_random_state(states_list:Array):
	states_list.shuffle()
	return states_list.pop_front()
	
func _on_HurtBox_area_entered(hitter):
	# note, under the hood, this calls Bat.set_health(value) 
	stats.health -= hitter.damage
	knockback = hitter.knockback_vector * KNOCKBACK_SPEED
	hurbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffet = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffet)
	enemyDeathEffet.global_position = global_position
