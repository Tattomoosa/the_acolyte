extends Node2D

func _input(e):
	if e is InputEventKey and e.pressed and e.scancode == KEY_SPACE:
		get_tree().change_scene("res://Game.tscn")
