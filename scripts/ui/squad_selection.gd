extends Control

@onready var unit_list = $VBoxContainer/UnitList
@onready var squad_list = $VBoxContainer/SquadList

var current_squad: Array[AlienUnit] = []

func _ready():
	refresh_lists()

func refresh_lists():
	print("SquadSelection: Refreshing lists. Squad size: ", current_squad.size())
	# Limpiar listas
	for child in unit_list.get_children():
		child.queue_free()
	for child in squad_list.get_children():
		child.queue_free()
	
	# Si la colección está vacía, añadir algunos de prueba
	if CollectionManager.collection.is_empty():
		setup_mock_collection()

	# Mostrar colección disponible
	for unit in CollectionManager.collection:
		var count_in_squad = current_squad.filter(func(u): return u == unit).size()
		print("Checking unit: ", unit.unit_name, " - In squad: ", count_in_squad)
		if count_in_squad < 1: # Si quisiéramos permitir múltiples, cambiaríamos esto
			var btn = Button.new()
			btn.text = unit.unit_name
			btn.pressed.connect(_add_to_squad.bind(unit))
			unit_list.add_child(btn)
			print("Added button for: ", unit.unit_name)
			
	# Mostrar escuadrón actual
	for unit in current_squad:
		var btn = Button.new()
		btn.text = unit.unit_name + " (En Escuadrón)"
		btn.pressed.connect(_remove_from_squad.bind(unit))
		squad_list.add_child(btn)

func setup_mock_collection():
	var u1 = AlienUnit.new()
	u1.unit_name = "Xeno Grunt"
	u1.max_hp = 150
	u1.attack = 15
	u1.knockback_force = 60.0
	
	var u2 = AlienUnit.new()
	u2.unit_name = "Xeno Spitter"
	u2.max_hp = 120
	u2.attack = 12
	u2.attack_range = 350
	u2.knockback_force = 40.0
	
	CollectionManager.add_unit(u1)
	CollectionManager.add_unit(u2)

func _add_to_squad(unit: AlienUnit):
	print("Adding to squad: ", unit.unit_name)
	if current_squad.size() < 5:
		current_squad.append(unit)
		print("Squad now has ", current_squad.size(), " units")
		refresh_lists()
	else:
		print("Squad is full!")

func _remove_from_squad(unit: AlienUnit):
	print("Removing from squad: ", unit.unit_name)
	current_squad.erase(unit)
	refresh_lists()

func _on_confirm_pressed():
	print("Confirm button clicked!")
	print("Current squad size: ", current_squad.size())
	print("Is current_squad empty? ", current_squad.is_empty())
	if not current_squad.is_empty():
		print("Attempting to call GameManager.confirm_squad...")
		GameManager.confirm_squad(current_squad)
	else:
		print("CANNOT START: Squad is empty.")
