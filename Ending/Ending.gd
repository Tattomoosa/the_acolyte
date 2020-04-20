extends Node2D

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var textbox : TextBox = $TextBox

func _ready():
	call_deferred('play')

func play():
	sprite.play('acolyte_still')
	textbox.start_conversation([
		'I have done it.',
		'Completed the task.'
	])
	textbox.connect('conversation_ended', self, 'play2')

func play2():
	textbox.disconnect('conversation_ended', self, 'play2')
	sprite.play('hole_still')
	textbox.start_conversation([
		'Now rise, master.',
		'And take your rightful place in the world.'
	])
	textbox.connect('conversation_ended', self, 'play3')

func play3():
	textbox.disconnect('conversation_ended', self, 'play3')
	$Song.stop()
	$Song2.play()
	sprite.play('hole_opening')
	sprite.connect('animation_finished', self, 'play4')

func play4():
	sprite.disconnect('animation_finished', self, 'play4')
	sprite.play('blast')
	textbox.start_conversation([
		'Yes...',
		'Rise and let me serve you.',
		'As my kind has done for generations!',
	])
	textbox.connect('conversation_ended', self, 'play5')

func play5():
	textbox.disconnect('conversation_ended', self, 'play5')
	sprite.play('tentacles')
	sprite.connect('animation_finished', self, 'play6')

func play6():
	sprite.disconnect('animation_finished', self, 'play6')
	sprite.play('acolyte_surprised')
	textbox.start_conversation([
		'Huh?'
	])
	textbox.connect('conversation_ended', self, 'play7')

func play7():
	textbox.disconnect('conversation_ended', self, 'play7')
	sprite.play('grab')
	textbox.start_conversation([
		'No...',
		'This cannot be...',
	])
	textbox.connect('conversation_ended', self, 'play8')

func play8():
	textbox.disconnect('conversation_ended', self, 'play8')
	sprite.play('grab2')
	sprite.connect('animation_finished', self, 'play9')

func play9():
	sprite.disconnect('animation_finished', self, 'play9')
	textbox.start_conversation([
		'The End',
	])
	textbox.connect('conversation_ended', self, 'play10')

func play10():
	textbox.disconnect('conversation_ended', self, 'play10')
	get_tree().change_scene("res://TitleScreen.tscn")
