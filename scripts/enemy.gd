extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:
	if player:
		position += (player.position - position)/speed
		maybe_flip(player)
		move_and_slide()

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
	
