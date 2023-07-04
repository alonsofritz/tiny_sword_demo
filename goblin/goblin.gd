extends CharacterBody2D

@onready var animation: AnimationPlayer = get_node("Animation")
@onready var aux_animation_player: AnimationPlayer = get_node("AuxAnimation")

var dead: bool = false
var player_ref: CharacterBody2D = null

@export var health: int = 3
@export var move_speed: float = 192.0
@export var distance_threshold = 60.0

func _physics_process(_delta: float) -> void:
	if dead:
		return

	if player_ref == null:
		velocity = Vector2.ZERO
		animate()
		return
			
	var direction: Vector2 = global_position.direction_to(player_ref.global_position)
	var distance: float = global_position.distance_to(player_ref.global_position)
	
	if distance < distance_threshold:
		animation.play("attack")
		return
	
	velocity = direction * move_speed
	move_and_slide()
	animate()
	
func animate() -> void:
	if velocity != Vector2.ZERO:
		animation.play("run")
		return
	
	animation.play("idle")
	
func update_health(value: int) -> void:
	health -= value
	if health <= 0:
		dead = true
		animation.play("death")
		return
		
	aux_animation_player.play("hit")
	
func on_detection_area_body_entered(body):
	player_ref = body


func on_detection_area_body_exited(_body):
	player_ref = null


func on_animation_animation_finished(anim_name: String):
	if anim_name == "death":
		queue_free()
	
	pass # Replace with function body.
