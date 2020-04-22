extends Node2D

func _input(_e):
	# if e is InputEventKey and e.pressed and e.scancode == KEY_SPACE:
	if Input.is_action_pressed('attack'):
		var _result = get_tree().change_scene("res://Game.tscn")
