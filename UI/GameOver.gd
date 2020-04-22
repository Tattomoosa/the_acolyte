extends Node2D

func _input(e):
	# if Input.is_action_pressed('attack'):
	if Input.is_action_just_pressed('attack'):
		get_tree().change_scene("res://TitleScreen.tscn")


