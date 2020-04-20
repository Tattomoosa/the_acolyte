extends Node
class_name UIController


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera : Camera2D
var textbox : TextBox

var player : Player


# Called when the node enters the scene tree for the first time.
func _ready():
	var nodes = get_parent().get_children()
	for node in nodes:
		print(node.name)
	camera = get_parent().get_node('Camera2D')
	textbox = camera.get_node('TextBox')
	player = get_parent().get_node('YSort/Player')
	print('player', player)
	print(player.is_enabled)
	print(player.sprite)
	# player.is_enabled = false
	trigger_textbox([
		'...',
		'I am the last of an ancient order',
		'Long ago tasked with an important duty',
		'See, true evil exists in this world...',
	])

	call_deferred('intro')

func intro():
	player.play('priest')
	textbox.connect('conversation_ended', self, 'intro_2')

func intro_2():
	player.play('transform')
	player.get_node('Whoosh').play()
	get_parent().get_node('Music').play()
	textbox.disconnect('conversation_ended', self, 'intro_2')
	trigger_textbox([
		"And I am the one who feeds it.",
	])
	textbox.connect('conversation_ended', self, 'intro_3')

func intro_3():
	textbox.disconnect('conversation_ended', self, 'intro_3')


func trigger_textbox(string_array: Array):
	# textbox.show()
	textbox.start_conversation(string_array)
