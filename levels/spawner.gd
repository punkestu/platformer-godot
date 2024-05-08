extends Marker2D

@export var enemy: PackedScene
@export var dir = 1

func _on_timer_timeout():
	var player = get_parent().get_node("player")
	var mob: Pig = enemy.instantiate()
	mob.dir = dir
	add_child(mob)
