extends Resource
class_name Country

@export var country_name: String = "Unknown Country"
@export var difficulty: int = 1
@export var description: String = ""
@export var enemy_types: Array[Resource] = [] # Array de Hero o similar
@export var hero_rewards: Array[Resource] = [] # Array de Hero o StolenPower

@export var is_conquered: bool = false
@export var resistance_level: float = 1.0 # Multiplicador de dificultad
