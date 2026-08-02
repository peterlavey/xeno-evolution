extends CharacterBody2D
class_name BattleUnit

@export var data: Resource # AlienUnit o Hero
@export var is_hero: bool = false
@export var speed: float = 100.0
@export var attack_range: float = 50.0
@export var is_ranged: bool = false
@export var projectile_scene: PackedScene = preload("res://scenes/characters/projectile.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

enum State { IDLE, SEEKING, ATTACKING, KITING, DEAD }
var current_state: State = State.IDLE
var current_hp: int = 0
var target: BattleUnit = null

var min_ranged_dist = 150.0

func _ready():
	if data:
		attack_range = data.attack_range
		
		if $HealthComponent:
			$HealthComponent.max_health = data.max_hp
			$HealthComponent.current_health = data.max_hp
			if "knockback_force" in data:
				$HealthComponent.knockback_force = data.knockback_force
			$HealthComponent.sprite = sprite
			$HealthComponent.on_death.connect(die)
			$HealthComponent.on_damaged.connect(_on_health_damaged)
		
		# Aplicar escala visual si existe
		if "visual_scale" in data:
			sprite.scale = Vector2(data.visual_scale, data.visual_scale)
		
		# Aplicar modulación de color si existe
		if "battle_modulate" in data:
			sprite.modulate = data.battle_modulate
		
		if data.battle_sprite:
			sprite.texture = data.battle_sprite
		else:
			# Asignar un placeholder por defecto si no hay textura
			var placeholder_path = "res://assets/sprites/aliens/placeholder_alien.png"
			if is_hero:
				placeholder_path = "res://assets/sprites/heroes/placeholder_hero.png"
			elif data is HumanUnit:
				placeholder_path = "res://assets/sprites/humans/placeholder_human.png"
			
			if FileAccess.file_exists(placeholder_path):
				sprite.texture = load(placeholder_path)
			else:
				push_warning("BattleUnit: Placeholder not found at " + placeholder_path)
		
		# Determinar si es a distancia basado en el rango
		if attack_range > 100:
			is_ranged = true
	
	# Configurar colisiones segun equipo
	if is_hero:
		set_collision_layer_value(2, true) # Layer 2: Heroes
		set_collision_mask_value(1, true)  # Mask 1: Aliens
	else:
		set_collision_layer_value(1, true) # Layer 1: Aliens
		set_collision_mask_value(2, true)  # Mask 2: Heroes
	
	current_state = State.SEEKING

func _physics_process(delta):
	if current_state == State.DEAD:
		return
	
	velocity = Vector2.ZERO
	
	match current_state:
		State.IDLE:
			find_target()
		State.SEEKING:
			if not is_instance_valid(target) or target.current_state == State.DEAD:
				find_target()
				return
				
			var dist = global_position.distance_to(target.global_position)
			
			if is_ranged and dist < min_ranged_dist:
				current_state = State.KITING
				return

			if dist <= attack_range:
				current_state = State.ATTACKING
			else:
				move_towards_target(delta)
		State.KITING:
			if not is_instance_valid(target) or target.current_state == State.DEAD:
				current_state = State.SEEKING
				return
			
			var dist = global_position.distance_to(target.global_position)
			if dist > min_ranged_dist + 50:
				current_state = State.SEEKING
			else:
				move_away_from_target(delta)
		State.ATTACKING:
			if not is_instance_valid(target) or target.current_state == State.DEAD:
				current_state = State.SEEKING
				return
				
			var dist = global_position.distance_to(target.global_position)
			
			if is_ranged and dist < min_ranged_dist:
				current_state = State.KITING
				return

			if dist > attack_range:
				current_state = State.SEEKING
			else:
				perform_attack(delta)

func find_target():
	var potential_targets = get_tree().get_nodes_in_group("units")
	var closest_dist = INF
	var closest_target = null
	
	for t in potential_targets:
		if t == self or t.is_hero == self.is_hero or t.current_state == State.DEAD:
			continue
		
		var dist = global_position.distance_to(t.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_target = t
	
	if closest_target:
		target = closest_target
		current_state = State.SEEKING

func move_towards_target(_delta):
	navigation_agent.target_position = target.global_position
	if navigation_agent.is_navigation_finished():
		return
		
	var next_path_pos = navigation_agent.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_pos) * speed
	velocity += new_velocity
	move_and_slide()

func move_away_from_target(_delta):
	var dir = target.global_position.direction_to(global_position)
	var escape_pos = global_position + dir * 100
	navigation_agent.target_position = escape_pos
	
	var next_path_pos = navigation_agent.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_pos) * speed
	velocity += new_velocity
	move_and_slide()

var attack_cooldown = 1.0
var time_since_last_attack = 0.0

func perform_attack(delta):
	time_since_last_attack += delta
	if time_since_last_attack >= attack_cooldown:
		if is_instance_valid(target):
			var damage = 10 # Default
			if data:
				damage = data.attack
			
			if is_ranged:
				shoot_projectile(damage)
			else:
				print("%s ataca a %s causando %d de daño (Melee)" % [get_unit_name(), target.get_unit_name(), damage])
				var k_force = 50.0
				if data and "knockback_force" in data:
					k_force = data.knockback_force
				target.take_damage(damage, global_position, k_force)
			
			time_since_last_attack = 0.0

func shoot_projectile(damage: int):
	if projectile_scene:
		var proj = projectile_scene.instantiate()
		proj.damage = damage
		proj.target = target
		proj.direction = global_position.direction_to(target.global_position)
		proj.global_position = global_position
		
		# Pasar fuerza de retroceso al proyectil si es necesario
		var k_force = 50.0
		if data and "knockback_force" in data:
			k_force = data.knockback_force
		if "knockback_force" in proj:
			proj.knockback_force = k_force
		if "attacker_pos" in proj:
			proj.attacker_pos = global_position
			
		get_parent().add_child(proj)
		print("%s dispara a %s causando %d de daño (Ranged)" % [get_unit_name(), target.get_unit_name(), damage])

func take_damage(amount: int, attacker_pos: Vector2 = Vector2.ZERO, knockback_power: float = -1.0):
	if $HealthComponent:
		$HealthComponent.take_damage(amount, attacker_pos, knockback_power)
	else:
		# Fallback si no hay componente
		current_hp -= amount
		if current_hp <= 0:
			die()

func _on_health_damaged(amount: int, current_hp_val: int):
	current_hp = current_hp_val
	print("%s recibe %d de daño. HP restante: %d" % [get_unit_name(), amount, current_hp])

func die():
	print("%s ha muerto" % [get_unit_name()])
	current_state = State.DEAD
	queue_free()

func get_unit_name() -> String:
	if not data:
		return "Unknown Unit"
	
	if "hero_name" in data:
		return data.hero_name
	if "unit_name" in data:
		return data.unit_name
		
	return "Unnamed Unit"
