extends CharacterBody2D

var direction = Vector2.LEFT
const SPEED = 20.0

@onready var EdgeCheckRight: =$EdgeCheckRight
@onready var EdgeCheckLeft: =$EdgeCheckLeft
@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("walking")
	print("애니메이션 'walking'이 없습니다.")

func _physics_process(delta: float) -> void:
	if is_on_wall() :
		direction *= -1
		
	if not EdgeCheckRight.is_colliding() or not EdgeCheckLeft.is_colliding():
		direction *= -1
		
	if !is_on_floor():
		# add gravity
		velocity.y = get_gravity().y * delta
	else:
		velocity.x  = (direction * SPEED).x
	_animated_sprite.flip_h = velocity.x > 0
	
	move_and_slide()
