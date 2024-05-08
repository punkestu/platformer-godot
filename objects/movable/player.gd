extends CharacterBody2D

class_name Player

@onready var animation = $AnimatedSprite2D
@onready var animationPlayer = $AnimatedSprite2D/AnimationPlayer

const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed = 100.0
var is_grounded = false
var is_hit = false
var state = ""
var flip_h = false
var hp: float = 100

func _ready():
	animationPlayer.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		is_grounded = false
		velocity.y += gravity * delta
		if velocity.y > 0 and not state == "attacking" and not is_hit:
			state = "falling"
	else:
		is_grounded = true
		if state == "falling" and not state == "attacking" and not is_hit:
			state = "raising"
		elif not state == "jumping" and not state == "raising" and not state == "attacking" and not is_hit:
			state = "idle"
	
	if Input.is_action_pressed("jump") and is_grounded:
		velocity.y = JUMP_VELOCITY
		if not state == "attack":
			state = "jumping"
	
	var mouse = get_local_mouse_position()
	var move = clamp(mouse.x, -1, 1)
	move = 1 if (flip_h and move == -1) or (not flip_h and move == 1) else -1
	if move:
		velocity.x = move * speed
		if (flip_h and velocity.x > 0) or (!flip_h and velocity.x < 0): scale.x = -1
		flip_h = move < 0
		if is_grounded and not state == "jumping" and not state == "attacking" and not is_hit:
			state = "running"
	else:
		velocity.x = move_toward(velocity.x, 0, delta * speed * 4)
	
	if Input.is_action_just_pressed("attack"):
		state = "attacking"
	
	move_and_slide()
	handle_animation()

func _input(event):
	if event.is_action_pressed("speed_up"):
		speed += 2
	if event.is_action_pressed("speed_down"):
		speed -= 2
	speed = clamp(speed, 0, 200)

func netral():
	state = ""

func handle_animation():
	if state == "attacking":
		animationPlayer.play("attack")
	else:
		if is_hit:
			animation.play("hit")
			hp = clamp(hp - 0.1, 0, 100)
			animation.material.set_shader_parameter("hp", hp)
		elif is_grounded:
			if state == "jumping":
				animation.play("jump")
			elif state == "raising":
				animationPlayer.play("raise")
			elif state == "running":
				animation.play("run")
			elif state == "idle":
				animation.play("idle")
		elif state == "falling":
			animation.play("fall")

func _on_attack_range_body_entered(body):
	if body is Pig:
		body.hit()
