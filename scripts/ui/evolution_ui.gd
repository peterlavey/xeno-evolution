extends Control

@onready var unit_list = $VBoxContainer/Main/UnitList
@onready var power_list = $VBoxContainer/Main/PowerList
@onready var unit_stats = $VBoxContainer/Details/UnitStats
@onready var apply_button = $VBoxContainer/Details/ApplyButton

var selected_unit: AlienUnit = null
var selected_power: StolenPower = null

func _ready():
	apply_button.disabled = true
	refresh_lists()

func refresh_lists():
	# Limpiar
	for child in unit_list.get_children(): child.queue_free()
	for child in power_list.get_children(): child.queue_free()
	
	# Unidades
	for unit in CollectionManager.collection:
		var btn = Button.new()
		btn.text = unit.unit_name
		btn.pressed.connect(_on_unit_selected.bind(unit))
		unit_list.add_child(btn)
		
	# Poderes
	for power in CollectionManager.stolen_powers:
		var btn = Button.new()
		btn.text = power.power_name
		btn.pressed.connect(_on_power_selected.bind(power))
		power_list.add_child(btn)

func _on_unit_selected(unit: AlienUnit):
	selected_unit = unit
	_update_details()

func _on_power_selected(power: StolenPower):
	selected_power = power
	_update_details()

func _update_details():
	if not selected_unit:
		unit_stats.text = "Select a unit"
		apply_button.disabled = true
		return
		
	var text = "Unit: %s\nHP: %d\nATK: %d\nDEF: %d\nSPD: %d\n" % [
		selected_unit.unit_name, selected_unit.max_hp, selected_unit.attack, selected_unit.defense, selected_unit.speed
	]
	
	if selected_power:
		text += "\nPOWER TO APPLY: %s\n" % selected_power.power_name
		text += "Bonuses: HP+%d, ATK+%d, DEF+%d, SPD+%d" % [
			selected_power.hp_bonus, selected_power.attack_bonus, selected_power.defense_bonus, selected_power.speed_bonus
		]
		apply_button.disabled = false
	else:
		text += "\nSelect a power to evolve"
		apply_button.disabled = true
		
	unit_stats.text = text

func _on_apply_pressed():
	if selected_unit and selected_power:
		# Aplicar bonos
		selected_unit.max_hp += selected_power.hp_bonus
		selected_unit.attack += selected_power.attack_bonus
		selected_unit.defense += selected_power.defense_bonus
		selected_unit.speed += selected_power.speed_bonus
		
		# Guardar en la lista de poderes de la unidad
		selected_unit.stolen_powers.append(selected_power)
		
		# Eliminar el poder usado de la colección
		CollectionManager.remove_stolen_power(selected_power)
		
		# Limpiar selección y refrescar
		selected_power = null
		refresh_lists()
		_update_details()
		
		# Guardar persistencia
		CollectionManager.save_collection()

func _on_back_pressed():
	GameManager.back_to_map()
