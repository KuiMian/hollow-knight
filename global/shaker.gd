extends Node


func shake(obj: Node2D, strength: float, duration: float = 0.2) -> void:
	var original_position := obj.position
	var shake_count := 10
	var tween := create_tween()
	
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target := original_position + strength * shake_offset
		
		if i % 2 == 0:
			target = original_position
		
		tween.tween_property(obj, "position", target, duration / float(shake_count))
		strength *= 0.75
	
	tween.finished.connect(func(): obj.position = original_position)
