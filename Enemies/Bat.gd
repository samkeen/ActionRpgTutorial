extends KinematicBody2D

export(int) var FRICTION = 200
export(int) var KNOCKBACK_SPEED = 120
export(int) var ACCELERATION = 200
export(int) var MAX_SPEED = 50

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

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION*delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = self.playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			# face direction we are moving
			sprite.flip_h = velocity.x < 0 
	
	velocity = move_and_slide(velocity)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	
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
