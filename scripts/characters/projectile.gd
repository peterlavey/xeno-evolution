extends Area2D
class_name Projectile

@export var is_explosive: bool = false
@export var explosion_radius: float = 100.0

var speed: float = 400.0
var damage: int = 10
var target: BattleUnit = null
var direction: Vector2 = Vector2.ZERO
var knockback_force: float = 0.0
var attacker_pos: Vector2 = Vector2.ZERO
var team: String = ""

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
	if body is BattleUnit and body.team != team:
		if is_explosive:
			_explode()
		else:
			body.take_damage(damage, attacker_pos, knockback_force)
			queue_free()

func _explode():
	print("¡EXPLOSIÓN! Radio: %f" % explosion_radius)
	# Buscar unidades en el radio
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = explosion_radius
	query.shape = shape
	query.transform = global_transform
	query.collision_mask = 1 # Ajustar según capas si es necesario
	
	var results = space_state.intersect_shape(query)
	for result in results:
		var hit_body = result.collider
		if hit_body is BattleUnit and hit_body.team != team:
			# El daño de explosión podría disminuir con la distancia, pero por ahora es fijo
			hit_body.take_damage(damage, global_position, knockback_force * 1.5)
	
	# Aquí se podría instanciar un efecto visual de explosión
	queue_free()
