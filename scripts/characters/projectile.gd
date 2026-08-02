extends Area2D
class_name Projectile

var speed: float = 400.0
var damage: int = 10
var target: BattleUnit = null
var direction: Vector2 = Vector2.ZERO
var knockback_force: float = 0.0
var attacker_pos: Vector2 = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	# Autodestrucción después de 5 segundos para evitar fugas de memoria
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _physics_process(delta):
	if is_instance_valid(target):
		direction = global_position.direction_to(target.global_position)
	
	position += direction * speed * delta
	rotation = direction.angle()

func _on_body_entered(body):
	if body is BattleUnit and body == target:
		body.take_damage(damage, attacker_pos, knockback_force)
		queue_free()
