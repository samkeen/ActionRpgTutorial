extends Area2D

const hitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value:bool):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration:float):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = hitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	# have to use self. to trigger setget's set_invincible 
	self.invincible = false


# have a moment of invencibility after being hit
func _on_HurtBox_invincibility_started():
	collisionShape.set_deferred("disabled",  true)
	
func _on_HurtBox_invincibility_ended():
	collisionShape.disabled = false
	
