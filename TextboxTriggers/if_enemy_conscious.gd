extends TextboxTrigger

export var enemy_name : String

var enemy

func _ready():
	enemy = weakref(get_parent().get_parent().find_node(enemy_name))

func validate():
	var e = enemy.get_ref()
	if e and not e.is_knocked_out:
		return true
	queue_free()
	return false
