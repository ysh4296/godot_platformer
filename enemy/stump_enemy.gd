extends Node2D

enum {
	HOVER,
	RISE,
	FALL,
	LAND 
}

var state = HOVER

@onready var start_position = global_position
@onready var timer = $Timer
@onready var raycast = $RayCast2D
@onready var animation = $AnimatedSprite2D
@onready var particles = $GPUParticles2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		HOVER: hover()
		RISE: rise(delta)
		FALL: fall(delta)
		LAND: land()
	pass

func hover():
	if timer.time_left != 0: return
	state = FALL
	animation.play("falling")

func fall(delta):
	position.y += 100*delta 
	if raycast:
		if raycast.is_colliding():
			var collision_point = raycast.get_collision_point()
			position.y = collision_point.y
			state = LAND
			animation.play("rising")
			timer.start(1.0)
			particles.emitting = true;

func rise(delta):
	position.y = move_toward(position.y,start_position.y,10*delta)
	if position.y == start_position.y:
		state = HOVER
		timer.start(1)
		
func land():
	if timer.time_left == 0:
		state = RISE
	pass
