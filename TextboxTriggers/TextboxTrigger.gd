extends Area2D
class_name TextboxTrigger

onready var ui : UIController = get_parent().get_parent().get_node('UIController')

var was_triggered = false

export (PoolStringArray) var text : PoolStringArray

func _ready():
	var _s = .connect('body_entered', self, 'trigger_textbox')

func trigger_textbox(_arg):
	if validate():
		ui.trigger_textbox(text)
		was_triggered = true

# default behavior is only to trigger once
func validate():
	return not was_triggered