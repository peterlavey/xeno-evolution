extends PanelContainer

@onready var unit_name_label = %UnitName
@onready var cost_label = %CostLabel
@onready var unit_icon = %UnitIcon
@onready var hp_label = %HPValue
@onready var atk_label = %ATKValue
@onready var def_label = %DEFValue
@onready var spd_label = %SPDValue
@onready var rng_label = %RNGValue
@onready var abilities_label = %AbilitiesText

signal card_clicked(unit_data: Resource)
var current_unit_data: Resource

func setup(unit_data: Resource):
	current_unit_data = unit_data
	
	if unit_data is AlienUnit:
		unit_name_label.text = unit_data.unit_name
		cost_label.text = "$" + str(unit_data.cost)
		unit_icon.texture = unit_data.icon if unit_data.icon else load("res://assets/sprites/aliens/placeholder_alien.png")
		hp_label.text = str(unit_data.max_hp)
		atk_label.text = str(unit_data.attack)
		def_label.text = str(unit_data.defense)
		spd_label.text = str(unit_data.speed)
		rng_label.text = str(unit_data.attack_range)
		
		var abilities = []
		for ability in unit_data.special_abilities:
			abilities.append(ability.name if "name" in ability else "Ability")
		for power in unit_data.stolen_powers:
			abilities.append(power.power_name if "power_name" in power else "Power")
		abilities_label.text = ", ".join(abilities) if abilities.size() > 0 else "None"
		
	elif unit_data is Hero:
		unit_name_label.text = unit_data.hero_name
		cost_label.text = "$" + str(unit_data.cost)
		unit_icon.texture = unit_data.icon if unit_data.icon else load("res://assets/sprites/heroes/placeholder_hero.png")
		hp_label.text = str(unit_data.max_hp)
		atk_label.text = str(unit_data.attack)
		def_label.text = str(unit_data.defense)
		spd_label.text = str(unit_data.speed)
		rng_label.text = str(unit_data.attack_range)
		abilities_label.text = "Hero Skills"
		
	elif unit_data is HumanUnit:
		unit_name_label.text = unit_data.unit_name
		cost_label.text = "$" + str(unit_data.cost)
		unit_icon.texture = unit_data.battle_sprite if unit_data.battle_sprite else load("res://assets/sprites/humans/placeholder_human.png")
		hp_label.text = str(unit_data.max_hp)
		atk_label.text = str(unit_data.attack)
		def_label.text = str(unit_data.defense)
		spd_label.text = str(unit_data.speed)
		rng_label.text = str(unit_data.attack_range)
		abilities_label.text = "Military Training"
	
	print("Card setup for: ", unit_data.unit_name if "unit_name" in unit_data else "Hero")

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		card_clicked.emit(current_unit_data)
