extends CharacterBody2D

class_name Pig

@onready var animation = $AnimatedSprite2D
@onready var animationPlayer = $AnimatedSprite2D/AnimationPlayer

var die = false
var dir = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

func _ready():
	animation.play("run")
	animation.flip_h = dir > 0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if die: velocity.x = 0
	else: velocity.x = dir * 100
	move_and_slide()

func hit():
	die = true
	animationPlayer.play("hit")

func _on_body_body_entered(body):
	if not die: if body is Player: body.is_hit = true

func _on_body_body_exited(body):
	if body is Player: body.is_hit = false
