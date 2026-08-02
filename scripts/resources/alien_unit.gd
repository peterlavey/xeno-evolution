extends Resource
class_name AlienUnit

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC }
enum Element { NONE, FIRE, WATER, EARTH, AIR, ELECTRIC }

@export var unit_name: String = "New Alien"
@export var rarity: Rarity = Rarity.COMMON
@export var element: Element = Element.NONE

@export_group("Stats")
@export var max_hp: int = 150
@export var attack: int = 15
@export var defense: int = 6
@export var speed: int = 12
@export var attack_range: float = 60.0
@export var visual_scale: float = 0.7
@export var knockback_force: float = 60.0

@export_group("Abilities")
@export var special_abilities: Array[Resource] = []
@export var stolen_powers: Array[Resource] = []

@export_group("AI")
@export var behavior_script: Script

@export_group("Visuals")
@export var icon: Texture2D
@export var battle_sprite: Texture2D
@export var battle_modulate: Color = Color.WHITE
