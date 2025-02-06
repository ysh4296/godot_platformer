extends Area2D

# if any physics body enters then this  function activate
func _on_body_entered(body: Node2D) -> void:
	# player with hit box
	if body is Player:
		body.player_die() 
	pass # Replace with function body.
