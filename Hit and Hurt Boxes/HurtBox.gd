extends Area2D

const hitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

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


# this is a bit of weirdness, since we are only triggering damage on the enter of the
#   hurtox, if the enemy hovers over us, they trigger no furhter damage.  We toggle 
#   monitorable sot the enemy re-enters hurtbox when monitorable is turned back on.
func _on_HurtBox_invincibility_ended():
	set_deferred("monitorable",  false)


func _on_HurtBox_invincibility_started():
	monitorable = true
