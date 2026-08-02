extends Node

# Persistent data container
var data: CollectionData = CollectionData.new()

# Compatibility proxies for existing code
var collection: Array[AlienUnit]:
	get: return data.collection
var stolen_powers: Array[StolenPower]:
	get: return data.stolen_powers

# Path to save the collection data
const SAVE_PATH = "user://collection.res"

func _ready() -> void:
	load_collection()

func add_unit(unit: AlienUnit) -> void:
	data.collection.append(unit)
	save_collection()

func remove_unit(unit: AlienUnit) -> void:
	data.collection.erase(unit)
	save_collection()

func add_stolen_power(power: StolenPower) -> void:
	data.stolen_powers.append(power)
	save_collection()

func remove_stolen_power(power: StolenPower) -> void:
	data.stolen_powers.erase(power)
	save_collection()

func save_collection() -> void:
	var error = ResourceSaver.save(data, SAVE_PATH)
	if error != OK:
		push_error("Failed to save collection: %d" % error)

func load_collection() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var loaded_data = ResourceLoader.load(SAVE_PATH)
		if loaded_data and loaded_data is CollectionData:
			data = loaded_data
		else:
			push_warning("Failed to load collection data or invalid format. Creating new.")
			data = CollectionData.new()
	else:
		data = CollectionData.new()

# Helper getters to maintain compatibility if needed, 
# although accessing data.collection is also fine.
func get_collection() -> Array[AlienUnit]:
	return data.collection

func get_stolen_powers() -> Array[StolenPower]:
	return data.stolen_powers
