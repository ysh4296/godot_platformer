@tool
extends Path2D

enum AnimationType {
	LOOP, BOUNCE
}

@export var state: AnimationType:
	set(value):
		state=value
		play_updated_animation()  # 애니메이션 갱신
	get():
		return state  # _state 반환
		
@export var speed:float = 1.0:
	set(value):
		speed=value
		set_speed()
	get():
		return speed

@onready var animationPlayer := $AnimationPlayer
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	play_updated_animation()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_updated_animation():
	var ap = find_child("AnimationPlayer")
	if ap:
		match state:
			AnimationType.LOOP: ap.play("movingenemyLoop")
			AnimationType.BOUNCE: ap.play("movingenemyBounce")
	
func set_speed():
	var ap = find_child("AnimationPlayer")
	if ap: ap.speed_scale = speed
	
