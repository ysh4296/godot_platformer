extends Area2D

@export_file("*.tscn") var target_level_path = ""

# is the player is on the door?
var over_player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up") && over_player:
		go_next_level()

func go_next_level():
	if target_level_path.is_empty(): return

	var tree = get_tree()  # 씬 트리 참조 유지

	await Transition.play_exit_transition()
	Transition.play_enter_transition()
	tree.change_scene_to_file(target_level_path)
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		over_player = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		over_player = false
