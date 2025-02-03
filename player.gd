extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -300.0

enum {
	MOVE,
	CLIMB,
	A,
	B,
	C
}

@export var MoveData: PlayerData
@onready var LadderCheck = $LadderCheck
@onready var BottomCheck = $BottomCheck
@onready var TopCheck = $TopCheck
@onready var AnimatedSprite = $AnimatedSprite2D

var state = MOVE

func _physics_process(delta: float) -> void:
	match state:
		MOVE: move_state(delta)
		CLIMB: climb_state(delta)
	pass


func is_on_ladder():
	if LadderCheck.is_colliding():
		var collider = LadderCheck.get_collider()
		if not collider is Ladder:
			return false
		else:
			return true
			
func has_next_ladder(direction):
	#check top
	if direction < 0:
		if TopCheck.is_colliding():
			var collider = TopCheck.get_collider()
			if collider is Ladder:
				return true
	#check bottom
	else:
		if BottomCheck.is_colliding():
			var collider = BottomCheck.get_collider()
			if collider is Ladder:
				return true
	return false		

func move_state(delta):
	# Add the gravity.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if is_on_ladder() && Input.is_action_pressed("ui_up"):
		state = CLIMB
		AnimatedSprite.play("idle")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		AnimatedSprite.play("jump")
	if not Input.is_action_pressed("ui_accept") and not is_on_floor() and velocity.y < 0:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = move_toward(velocity.x, direction * MoveData.SPEED, 20)
		AnimatedSprite.play("run")
		
	else:
		velocity.x = move_toward(velocity.x, 0, 20)
		AnimatedSprite.play("idle")
	
	if not velocity.x == 0:
		AnimatedSprite.flip_h = velocity.x > 0

	move_and_slide()
	pass

func climb_state(delta):
	if not is_on_ladder():
		state = MOVE
	var directionx := Input.get_axis("ui_left","ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")
	
	velocity.y = directiony * 50
	velocity.x = directionx * 50
	if directiony != 0:
		if not has_next_ladder(directiony):
			velocity.y = 0
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		state = MOVE
		velocity.y = JUMP_VELOCITY
		AnimatedSprite.play("jump")
	
	if velocity.length() > 0:
		AnimatedSprite.play("run")
	else:
		AnimatedSprite.play("idle")
	
	if not velocity.x == 0:
		AnimatedSprite.flip_h = velocity.x > 0

	move_and_slide()
	pass
	
