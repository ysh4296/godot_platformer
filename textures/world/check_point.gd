extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.emit_signal("hit_checkpoint",position)
		animated_sprite.play("Checked")
	pass # Replace with function body.
