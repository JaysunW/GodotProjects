extends Node

var main_scene_path = "res://Data/MainScenes/main.tscn"
var shop_scene_path = "res://Data/MainScenes/shop.tscn"
var menu_scene_paht = "res://Data/MainScenes/menu.tscn"

var current_scene = null

signal scene_switched

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print_debug(current_scene)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)

func _deferred_switch_scene(res_path):
	scene_switched.emit()
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
func get_scene_switch_signal():
	return scene_switched
