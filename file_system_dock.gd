tool
extends EditorPlugin

const PluginName := "FileSystemBottomPanel"

var _file_system_node_name := "FileSystem"
var _file_system_dock: Control = null

func _enter_tree() -> void:
	_file_system_dock = find_file_system_dock_node()
	if not _file_system_dock:
		printerr("Couldn't find Filesystem Dock")
		return
	
	remove_control_from_docks(_file_system_dock)
	add_control_to_bottom_panel(_file_system_dock, _file_system_dock.name)

func _exit_tree() -> void:
	if not _file_system_dock:
		return
	
	remove_control_from_bottom_panel(_file_system_dock)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, _file_system_dock)


func get_plugin_name() -> String:
	return PluginName

func get_plugin_icon() -> Object: #Texture
	return get_editor_interface().get_base_control().get_icon("File", "EditorIcons")


func find_file_system_dock_node() -> Node:
	var dummy = Control.new()
	
	for dock_slot in range(EditorPlugin.DOCK_SLOT_MAX):
		add_control_to_dock(dock_slot, dummy)
		for node in dummy.get_parent().get_children():
			if node.name == _file_system_node_name:
				remove_control_from_docks(dummy)
				dummy.free()
				return node
		remove_control_from_docks(dummy)
	
	dummy.free()
	return null
