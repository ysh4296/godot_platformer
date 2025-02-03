extends Area2D

# if any physics body enters then this  function activate
func _on_body_entered(body: Node2D) -> void:
	# player with hit box
	if body.name == "player":
		get_tree().reload_current_scene()
	pass # Replace with function body.
