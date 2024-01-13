extends CharacterBody2D

const SPEED = 100.0
enum DIRECTIONS {LEFT, RIGHT, UP, DOWN, NONE}
var current_direction = DIRECTIONS.NONE
var enemy_in_attack_range = null
var attack_cooldown = true
var health = 100
var alive = true
const IS_PLAYER = true
const DAMAGE = 15
var attack_in_progress = false

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	play_attack()
	
	if health <= 0:
		alive = false
		health = 0
		print("player is dead")
		queue_free()
	
func player_movement(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		current_direction = DIRECTIONS.LEFT
		play_animation(true)
		velocity.x = -SPEED
		velocity.y = 0.0
	elif Input.is_action_pressed("ui_right"):
		current_direction = DIRECTIONS.RIGHT
		play_animation(true)		
		velocity.x = SPEED
		velocity.y = 0.0
	elif Input.is_action_pressed("ui_up"):
		current_direction = DIRECTIONS.UP
		play_animation(true)		
		velocity.x = 0.0
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		current_direction = DIRECTIONS.DOWN
		play_animation(true)		
		velocity.x = 0.0
		velocity.y = SPEED
	else:
		play_animation(false)		
		velocity.x = 0.0
		velocity.y = 0.0
		
	move_and_slide()
	
func play_animation(is_moving):
	var anim = $AnimatedSprite2D
	
	if current_direction == DIRECTIONS.RIGHT:
		anim.flip_h = false
		if is_moving:
			anim.play("side_walk")
		else:
			if !attack_in_progress:
				anim.play("side_idle")
			
	if current_direction == DIRECTIONS.LEFT:
		anim.flip_h = true
		if is_moving:
			anim.play("side_walk")
		else:
			if !attack_in_progress:
				anim.play("side_idle")
			
	if current_direction == DIRECTIONS.UP:
		anim.flip_h = false
		if is_moving:
			anim.play("back_walk")
		else:
			if !attack_in_progress:			
				anim.play("back_idle")
			
	if current_direction == DIRECTIONS.DOWN:
		anim.flip_h = true
		if is_moving:
			anim.play("front_walk")
		else:
			if !attack_in_progress:			
				anim.play("front_idle")
			
func play_attack():
	var dir = current_direction
	if Input.is_action_just_pressed("attack") and attack_cooldown:
		print("play attack!!")
		attack_in_progress = true
	
		var anim = $AnimatedSprite2D
		$animation_attack_timer.start()
		
		if current_direction == DIRECTIONS.RIGHT:
			anim.flip_h = false
			anim.play("side_attack")
				
		if current_direction == DIRECTIONS.LEFT:
			anim.flip_h = true
			anim.play("side_attack")
				
		if current_direction == DIRECTIONS.UP:
			anim.flip_h = false
			anim.play("back_attack")
				
		if current_direction == DIRECTIONS.DOWN:
			anim.flip_h = true
			anim.play("front_attack")
			
		attack_enemy()
			
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.get("IS_ENEMY"):
		enemy_in_attack_range = body
		
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.get("IS_ENEMY"):
		enemy_in_attack_range = null

func attack(enemy):
	enemy.handle_attack(DAMAGE)

func handle_attack(damage):
	health -= damage
	print("player health")
	print(health)
	
func attack_enemy():
	if enemy_in_attack_range:
		attack(enemy_in_attack_range)
		attack_cooldown = false
		$attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	attack_cooldown = true

func _on_animation_attack_timer_timeout() -> void:
	print("timeout!!!")
	$animation_attack_timer.stop()
	attack_in_progress = false
	
