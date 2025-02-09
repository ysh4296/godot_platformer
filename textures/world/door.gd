extends Area2D

@export_file("*.tscn") var target_level_path = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("entered")
	print(target_level_path)
	if target_level_path.is_empty(): return
	if body is Player:
		get_tree().change_scene_to_file(target_level_path)
		pass # Replace with function body.
