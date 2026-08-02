extends CharacterBody2D
class_name BattleUnit

@export var data: Resource # AlienUnit o Hero
@export var is_hero: bool = false
@export var speed: float = 100.0
@export var attack_range: float = 50.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

enum State { IDLE, SEEKING, ATTACKING, DEAD }
var current_state: State = State.IDLE
var current_hp: int = 0
var target: BattleUnit = null

func _ready():
	if data:
		current_hp = data.max_hp
		if data.battle_sprite:
			sprite.texture = data.battle_sprite
	
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
		
	match current_state:
		State.IDLE:
			find_target()
		State.SEEKING:
			if not is_instance_valid(target) or target.current_state == State.DEAD:
				find_target()
				return
				
			var dist = global_position.distance_to(target.global_position)
			if dist <= attack_range:
				current_state = State.ATTACKING
			else:
				move_towards_target(delta)
		State.ATTACKING:
			if not is_instance_valid(target) or target.current_state == State.DEAD:
				current_state = State.SEEKING
				return
				
			var dist = global_position.distance_to(target.global_position)
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

func move_towards_target(delta):
	navigation_agent.target_position = target.global_position
	if navigation_agent.is_navigation_finished():
		return
		
	var next_path_pos = navigation_agent.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_pos) * speed
	velocity = new_velocity
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
			print("%s ataca a %s causando %d de daño" % [data.unit_name if not is_hero else data.hero_name, target.data.unit_name if not target.is_hero else target.data.hero_name, damage])
			target.take_damage(damage)
			time_since_last_attack = 0.0

func take_damage(amount: int):
	current_hp -= amount
	print("%s recibe %d de daño. HP restante: %d" % [data.unit_name if not is_hero else data.hero_name, amount, current_hp])
	if current_hp <= 0:
		die()

func die():
	print("%s ha muerto" % [data.unit_name if not is_hero else data.hero_name])
	current_state = State.DEAD
	queue_free()
