extends CharacterBody2D

signal hit_bottom

@export var speed: float = 600.0
var direction: Vector2 = Vector2.DOWN.rotated(randf_range(-0.5, 0.5))
var is_active: bool = false

func start():
	is_active = true
	direction = Vector2.DOWN.rotated(randf_range(-0.8, 0.8)).normalized()
	


func _physics_process(delta: float) -> void:
	if not is_active:
		return
	
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		direction = direction.bounce(collision.get_normal())

func die():
	is_active = false
	hit_bottom.emit()
	queue_free()
