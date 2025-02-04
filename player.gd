extends CharacterBody2D

enum {
	MOVE,
	CLIMB,
	A,
	B,
	C
}

@export var MoveData: PlayerData = preload("res://FasterPlayerData.tres") as PlayerData
@onready var LadderCheck = $LadderCheck
@onready var BottomCheck = $BottomCheck
@onready var TopCheck = $TopCheck
@onready var AnimatedSprite = $AnimatedSprite2D
@onready var JumpBifferTimer = $JumpBufferTimer
@onready var CoyoteJumpTimer = $CoyoteJumpTimer
 
const JUMP_VELOCITY = -300.0
var double_jump = MoveData.MAXDOUBLEJUMP
var state = MOVE
var buffered_jump = false 
var coyote_jump = false 

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
	# restore double jump	
	if is_on_floor():
		double_jump = MoveData.MAXDOUBLEJUMP
		
		
	# Handle jump.
	if is_on_floor():
		if buffered_jump:
			buffered_jump = false
		else: 
			input_jump()
	# do aditional jump
	elif not is_on_floor():
		velocity += get_gravity() * delta
		# but still we can double jump
		if (double_jump > 0 or coyote_jump):
			if input_jump():
				if coyote_jump: coyote_jump = false
				else: double_jump -= 1
		if Input.is_action_just_pressed("ui_accept") and double_jump == 0:
			buffered_jump = true
			JumpBifferTimer.start()
			
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

	var was_on_floor = is_on_floor()

	move_and_slide()	
	
	var just_left_ground = not is_on_floor() and was_on_floor 
	
	# just left & not moved by jump 
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		CoyoteJumpTimer.start()
	pass

func climb_state(delta):
	if not is_on_ladder():
		state = MOVE
	var directionx := Input.get_axis("ui_left","ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")
	
	velocity.y = directiony * MoveData.CLIMBSPEED
	velocity.x = directionx * MoveData.CLIMBSPEED
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
	
func _on_jump_buffer_timer_timeout() -> void:
	buffered_jump = false
	pass # Replace with function body.

func _on_coyote_jump_timer_timeout() -> void:
	coyote_jump = false 
	pass # Replace with function body.

# do jump with input
func input_jump():
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		AnimatedSprite.play("jump")
		return true;
	return false
