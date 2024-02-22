extends PanelContainer
class_name Slot

@onready var texture_rect = $TextureRect

# Export different slot types
@export_enum("NONE:0",
			 "HEAD:1",
			 "TORSO:2",
			 "LEFT_SHOULDER:3",
			 "RIGHT_SHOULDER:4",
			 "LEFT_HAND:5",
			 "RIGHT_HAND:6",
			 "LEFT_LEG:7",
			 "RIGHT_LEG:8",
			 "LEFT_FOOT:9",
			 "RIGHT_FOOT:10",
			 "ACTIVE:11") var slot_type : int


# Return drag data
func _get_drag_data(at_position):
	set_drag_preview(get_preview()) #Set drag preview using get_preview()
	
	return texture_rect


# Check if data from _get_drag_data() can be dropped
func _can_drop_data(_pos, data):
	return data is TextureRect


# Swap texture with drag data if droppable
func _drop_data(_pos, data):
	var temp = texture_rect.property
	texture_rect.property = data.property
	data.property = temp

# Get preview of texture while dragging
func get_preview():
	var preview_texture = TextureRect.new() #New instance of TextureRect
	
	# Set properties of new instance
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30, 30)
	
	# New instance of Control and add preview texture
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview
