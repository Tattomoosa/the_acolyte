extends KinematicBody2D
class_name FireBall

var direction = Vector2()
var speed = 300.0
var velocity = Vector2()

var damage = 1
onready var sprite : AnimatedSprite = $AnimatedSprite

onready var visibility_notifier : VisibilityNotifier2D = $VisibilityNotifier2D
onready var collision_shape : CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if not visibility_notifier.is_on_screen():
		queue_free()
	velocity = direction.normalized() * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		on_did_damage()

func on_did_damage():
	direction = Vector2()
	remove_child(collision_shape)
	sprite.play('explode')
	sprite.connect('animation_finished', self, 'queue_free')
	