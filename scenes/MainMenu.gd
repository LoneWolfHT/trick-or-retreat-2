extends Node2D

func _ready():
	$Difficulty.value = Settings.difficulty_mult
	$Volume.value = Settings.audio_volume_shift
	Audio.play("main_menu")

func _on_button_activate(button):
	Audio.stop("main_menu")

	if button == "exit":
		self.get_tree().free()
	elif button == "play_game":
		# if Settings.showed_tutorial:
		get_tree().change_scene("res://scenes/Level1.tscn")
		# else:
		# 	Settings.showed_tutorial = true
		# 	get_tree().change_scene("res://scenes/Tutorial.tscn")


func _on_Volume_changed(newval):
	Settings.audio_volume_shift = newval
	print("New Volume: " + String(newval))

func _on_Difficulty_changed(newval):
	Settings.difficulty_mult = newval
	print("New Difficulty: " + String(newval))
