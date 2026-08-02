extends Resource
class_name HumanUnit

@export var unit_name: String = "Human Soldier"
@export var cost: int = 5
@export var max_hp: int = 50
@export var attack: int = 5
@export var defense: int = 2
@export var speed: int = 8
@export var attack_range: float = 40.0
@export var visual_scale: float = 0.5
@export var knockback_force: float = 20.0
@export var battle_sprite: Texture2D
@export var battle_modulate: Color = Color.WHITE

# Nuevas propiedades para tipos de ataque
@export var is_explosive: bool = false
@export var explosion_radius: float = 100.0
