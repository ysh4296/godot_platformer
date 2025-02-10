extends CanvasLayer

@onready var animationPlayer = $AnimationPlayer

func play_exit_transition():
	if animationPlayer:
		animationPlayer.play("exit_level")
		await animationPlayer.animation_finished
	
func play_enter_transition():
	if animationPlayer:
		animationPlayer.play("enter_level")
		await animationPlayer.animation_finished 
		
	
