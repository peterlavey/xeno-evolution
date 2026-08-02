extends Node2D
class_name HealthComponent

signal on_damaged(amount: int, current_health: int)
signal on_death

@export_group("Stats")
@export var max_health: int = 100
@export var current_health: int = 100

@export_group("Knockback")
@export var knockback_force: float = 200.0
@export var knockback_decay: float = 10.0

@export_group("Visuals")
@export var flash_duration: float = 0.1
@export var sprite: Sprite2D

var _current_knockback: Vector2 = Vector2.ZERO
var _parent_body: CharacterBody2D

func _ready():
	current_health = max_health
	_parent_body = get_parent() as CharacterBody2D
	
	if sprite and not sprite.material:
		# Nota: En producción, es mejor asignar el shader pre-creado desde el editor
		# para evitar duplicación de recursos en tiempo de ejecución.
		pass

func _physics_process(delta):
	if _current_knockback.length() > 0.1:
		if _parent_body:
			_parent_body.velocity += _current_knockback
		_current_knockback = lerp(_current_knockback, Vector2.ZERO, knockback_decay * delta)

func take_damage(amount: int, attacker_pos: Vector2, external_knockback_force: float = -1.0):
	current_health -= amount
	
	# Emitir señal
	on_damaged.emit(amount, current_health)
	
	# Efecto visual Flash
	_apply_flash()
	
	# Aplicar Knockback
	var force = external_knockback_force if external_knockback_force >= 0 else knockback_force
	if attacker_pos != Vector2.ZERO:
		var dir = attacker_pos.direction_to(global_position)
		_current_knockback = dir * force
	
	if current_health <= 0:
		on_death.emit()

func _apply_flash():
	if sprite and sprite.material is ShaderMaterial:
		sprite.material.set_shader_parameter("active", true)
		await get_tree().create_timer(flash_duration).timeout
		sprite.material.set_shader_parameter("active", false)
	elif sprite:
		# Fallback si no hay shader: pestañeo de modulación
		var tween = create_tween()
		var original_modulate = sprite.modulate
		sprite.modulate = Color.WHITE * 10.0
		tween.tween_property(sprite, "modulate", original_modulate, flash_duration)
