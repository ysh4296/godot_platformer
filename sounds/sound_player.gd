extends Node

const HIT = preload("res://sounds/hit.wav")
const JUMP = preload("res://sounds/jump.wav")

@onready var audioPlayerList = $AudioPlayerList

func play_sound(sound) -> void:
	for audioplayer in audioPlayerList.get_children():
		if not audioplayer.playing:
			audioplayer.stream = sound
			audioplayer.play()
			break
 
