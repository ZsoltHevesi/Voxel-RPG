class_name userPreferences extends Resource

func save() -> void:
	ResourceSaver.save(self, "user://userPrefs.tres")

static func loadOrCreate() -> userPreferences:
	var res : userPreferences = load("user://userPrefs.tres") as userPreferences
	if !res:
		res = userPreferences.new()
	return res
