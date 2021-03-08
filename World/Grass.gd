extends Node2D


func create_grass_effect():
	# intance the GrassEffect (die animation) to the position of the grass
	var grassEffect = load("res://Effects/GrassEffect.tscn").instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
