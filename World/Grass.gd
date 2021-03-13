extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
func create_grass_effect():
	# intance the GrassEffect (die animation) to the position of the grass
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
