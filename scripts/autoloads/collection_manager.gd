extends Node

# Persistent collection of alien units
var collection: Array[AlienUnit] = []

# Path to save the collection data
const SAVE_PATH = "user://collection.res"

func add_unit(unit: AlienUnit) -> void:
	collection.append(unit)
	save_collection()

func remove_unit(unit: AlienUnit) -> void:
	collection.erase(unit)
	save_collection()

func save_collection() -> void:
	var error = ResourceSaver.save(self, SAVE_PATH)
	if error != OK:
		push_error("Failed to save collection: %d" % error)

func load_collection() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var saved_collection = ResourceLoader.load(SAVE_PATH)
		if saved_collection and saved_collection is Array:
			collection = saved_collection
