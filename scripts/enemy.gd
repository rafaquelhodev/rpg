extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
const IS_ENEMY = true
var player_in_attack_range = null
var attack_cooldown = true
var health = 100
const DAMAGE = 5
var alive = true

signal enemy_got_hit(amount)

func _physics_process(delta: float) -> void:
	if player:
		var dir_vector = (player.position - position)
		var dir_vector_normalized = dir_vector.normalized()
		var speed_vector = speed*dir_vector_normalized
		velocity = speed_vector
		maybe_flip(player)
		move_and_slide()
		
	attack_player()
	
	if health <= 0:
		alive = false
		health = 0
		print("enemy is dead")
		queue_free()

func maybe_flip(player):
	if (player.position.x - position.x) < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	$AnimatedSprite2D.play("walk")

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	$AnimatedSprite2D.play("idle")	

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		player_in_attack_range = body
		
func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.get("IS_PLAYER"):
		player_in_attack_range = null

func attack(player):
	player.handle_attack(DAMAGE)

func handle_attack(damage):
	health -= damage
	print("enemy health")
	print(health)

func attack_player():
	if player_in_attack_range and attack_cooldown:
		attack(player_in_attack_range)
		attack_cooldown = false
		$attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	attack_cooldown = true

