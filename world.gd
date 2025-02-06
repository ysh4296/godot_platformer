extends Node2D

@onready var camera: = $Camera2D
@onready var player = $player
@onready var timer = $Timer

var player_spawn_location = Vector2.ZERO
const playerScene = preload("res://player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.LIGHT_BLUE)
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	Events.player_died.connect(_on_player_died)
	Events.hit_checkpoint.connect(_hit_checkpoint)
	pass # Replace with function body.

func _on_player_died():
	timer.start(1.0)
	await timer.timeout
	var player = playerScene.instantiate()
	player.global_position = player_spawn_location
	add_child(player)
	player.connect_camera(camera)

func _hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position
