extends Area2D


# Detect if we are overlapping anything, if so get a push vector
# i.e. Keep enimies from overlapping on screen



func is_colliding() -> bool:
	return self.get_overlapping_areas().size() > 0
	
func get_push_vector() -> Vector2:
	var areas = self.get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if self.is_colliding():
		var area:Area2D = areas[0]
		push_vector = area.global_position.direction_to(self.global_position).normalized()
	return push_vector
