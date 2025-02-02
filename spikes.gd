extends Area2D

# if any physics body enters then this  function activate
func _on_body_entered(body: Node2D) -> void:
	# player + spike => die
	if body.name == "player":
		#body.queue_free()
		get_tree().reload_current_scene()
	pass # Replace with function body.
