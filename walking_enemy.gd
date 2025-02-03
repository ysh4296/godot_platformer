extends CharacterBody2D


@export var moveData: PlayerData

@onready var EdgeCheckRight: =$EdgeCheckRight
@onready var EdgeCheckLeft: =$EdgeCheckLeft
@onready var _animated_sprite = $AnimatedSprite2D


func _ready():
	_animated_sprite.play("walking")
	
func _physics_process(delta: float) -> void:
	if is_on_wall() :
		moveData.direction *= -1
		
	if not EdgeCheckRight.is_colliding() or not EdgeCheckLeft.is_colliding():
		moveData.direction *= -1
		
	if !is_on_floor():
		# add gravity
		velocity.y = get_gravity().y * delta
	else:
		velocity.x  = (moveData.direction * moveData.SPEED).x
	_animated_sprite.flip_h = velocity.x > 0
	
	move_and_slide()
