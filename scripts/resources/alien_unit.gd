extends Resource
class_name AlienUnit

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC }
enum Element { NONE, FIRE, WATER, EARTH, AIR, ELECTRIC }

@export var unit_name: String = "New Alien"
@export var rarity: Rarity = Rarity.COMMON
@export var element: Element = Element.NONE

@export_group("Stats")
@export var max_hp: int = 100
@export var attack: int = 10
@export var defense: int = 5
@export var speed: int = 10
@export var attack_range: float = 50.0

@export_group("Abilities")
@export var special_abilities: Array[Resource] = []
@export var stolen_powers: Array[Resource] = []

@export_group("AI")
@export var behavior_script: Script

@export_group("Visuals")
@export var icon: Texture2D
@export var battle_sprite: Texture2D
