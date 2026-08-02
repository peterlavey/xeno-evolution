extends Control

@onready var unit_list = $VBoxContainer/CollectionScroll/UnitList
@onready var squad_list = $VBoxContainer/SquadScroll/SquadList

var card_scene = null

var current_squad: Array[AlienUnit] = []

func _ready():
	print("SquadSelection: _ready called")
	var path = "res://scenes/ui/unit_card_v2.tscn"
	print("SquadSelection: Attempting to load card_scene from ", path)
	card_scene = ResourceLoader.load(path, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
	if card_scene == null:
		push_error("SquadSelection: FAILED TO LOAD card_scene via load(). Trying fallback...")
		card_scene = ResourceLoader.load(path)
		
	if card_scene:
		print("SquadSelection: card_scene loaded successfully")
	else:
		push_error("SquadSelection: CRITICAL - FAILED TO LOAD card_scene from " + path)
		# Intento de cargar OTRA escena para diagnosticar si es un problema general
		var test_path = "res://scenes/ui/world_map.tscn"
		var test_scene = load(test_path)
		if test_scene:
			print("SquadSelection: DIAGNOSTIC - Successfully loaded world_map.tscn")
		else:
			push_error("SquadSelection: DIAGNOSTIC - FAILED to load world_map.tscn too!")
	
	refresh_lists()

func refresh_lists():
	print("SquadSelection: Refreshing lists. Squad size: ", current_squad.size())
	# Limpiar listas
	for child in unit_list.get_children():
		unit_list.remove_child(child)
		child.queue_free()
	for child in squad_list.get_children():
		squad_list.remove_child(child)
		child.queue_free()
	
	# Si la colección está vacía, añadir algunos de prueba
	if CollectionManager.collection.is_empty():
		print("SquadSelection: Collection is empty, setting up mock collection")
		setup_mock_collection()
	
	print("SquadSelection: Collection size: ", CollectionManager.collection.size())

	# Mostrar colección disponible
	for unit in CollectionManager.collection:
		var count_in_squad = current_squad.filter(func(u): return u == unit).size()
		if count_in_squad < 1:
			if card_scene:
				var card = card_scene.instantiate()
				unit_list.add_child(card)
				card.setup(unit)
				card.card_clicked.connect(_add_to_squad)
			else:
				push_error("SquadSelection: card_scene is NULL for " + unit.unit_name)
			
	# Mostrar escuadrón actual
	for unit in current_squad:
		if card_scene:
			var card = card_scene.instantiate()
			squad_list.add_child(card)
			card.setup(unit)
			card.card_clicked.connect(_remove_from_squad)

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
