extends Resource
class_name Hero

@export var hero_name: String = "New Hero"
@export var country_origin: String = ""
@export var power_level: int = 1

@export_group("Stats")
@export var max_hp: int = 200
@export var attack: int = 20
@export var defense: int = 10
@export var speed: int = 15
@export var attack_range: float = 50.0
@export var visual_scale: float = 0.8
@export var knockback_force: float = 80.0
@export var element: AlienUnit.Element = AlienUnit.Element.NONE

@export_group("Lootable Powers")
@export var available_powers: Array[StolenPower] = []
@export var extraction_chances: Dictionary = {} # Power Resource -> float (0.0 to 1.0)

@export_group("Visuals")
@export var icon: Texture2D
@export var battle_sprite: Texture2D
@export var battle_modulate: Color = Color.WHITE
