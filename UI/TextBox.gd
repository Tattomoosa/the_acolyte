extends Node2D
class_name TextBox

onready var textbox_text : Label = $Control/NinePatchRect/TextBoxContent

var player : Player

var conversation : Array = ['']

signal conversation_ended

func _ready():
	print(textbox_text)
	player = get_parent().get_parent().get_node('YSort/Player')
	hide()
	# show()
	# next()

func show():
	visible = true
	if not player == null:
		player.disable()
	next()

func hide():
	conversation = []
	visible = false
	if not player == null:
		player.enable()

func _process(_delta):
	if not visible:
		return
	if Input.is_action_just_pressed('attack'):
		next()


func set_text(text: String):
	textbox_text.text = text

func next():
	if conversation.size() > 0:
		set_text(conversation.pop_front())
	else:
		hide()
		emit_signal('conversation_ended')

func start_conversation(c):
	conversation = c
	show()
