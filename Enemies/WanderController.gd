extends Node2D

export(int) var wander_range = 32
# get our position once we've been instanced. This never changed in the game,
#   we will return to this position when we return to a WANDER state
onready var start_position = global_position
# position we wander twoards
onready var target_position = global_position
onready var timer = $Timer

func _ready():
	self.update_target_position()

func update_target_position():
	var target_vector = Vector2(
		rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	# move but relative to start_position (stay in range of "home")
	self.target_position = start_position + target_vector

func get_time_left():
	return timer.time_left
	
func start_wander_timer(duration: int):
	self.timer.start(duration)
	
func _on_Timer_timeout():
	self.update_target_position()
