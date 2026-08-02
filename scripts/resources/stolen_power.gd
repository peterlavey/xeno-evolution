extends Resource
class_name StolenPower

enum Category { PASSIVE, ACTIVE, TRIGGER }

@export var power_name: String = "New Power"
@export var description: String = ""
@export var category: Category = Category.PASSIVE
@export var rarity_modifier: float = 1.0 # Affects extraction chance

# Could be stats modifiers or references to scripts for new behaviors
@export_group("Modifiers")
@export var hp_bonus: int = 0
@export var attack_bonus: int = 0
@export var defense_bonus: int = 0
@export var speed_bonus: int = 0

@export_group("Custom Logic")
@export var effect_script: Script
