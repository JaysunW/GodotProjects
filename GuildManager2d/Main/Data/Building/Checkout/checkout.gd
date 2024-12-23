extends StaticBody2D

@onready var work_timer = $WorkTimer
@onready var flash_timer = $FlashTimer
@onready var show_progress_timer = $ShowProgressTimer
@onready var checkout_marker = $CheckoutMarker

@export var work_progress_bar : TextureProgressBar

var opened_menu = false

var is_working : bool = false

var shopper_queue : Array = []
var current_shopping_list : Array = []
var whole_shopping_amount : int = 0

var in_work_cooldown : bool = false

var checkout_queue_max : int= 7
signal next_shopper

func _ready():
	work_progress_bar.visible = false
	pass

func is_full():
	return len(shopper_queue) >= checkout_queue_max

func get_queue_size():
	return len(shopper_queue)
	
func get_marker():
	return checkout_marker

func get_shopper_at(number):
	if number < 0:
		return null
	return shopper_queue[number]

func reserve_spot(shopper):
	shopper_queue.append(shopper)
	return len(shopper_queue) - 1

func interact():
	if UI.get_set_ui_free():
		change_work_mode()
		opened_menu = true
	elif opened_menu:
		change_work_mode()
		opened_menu = false
		UI.is_free(true)
	
func change_work_mode():
	if is_working:
		SignalService.restrict_player_movement.emit(false)
		SignalService.camera_offset.emit(Vector2.ZERO)
		UI.change_checkout_UI.emit(false, "close")
		is_working = false
	else:
		
		print("Shopper_queue: " , len(shopper_queue))
		SignalService.restrict_player_movement.emit(true)
		SignalService.camera_offset.emit(Vector2(-32*10,-32))
		UI.change_checkout_UI.emit(true, "Open")
		is_working = true
		
		##debug
		shopper_queue[0].bought_basket()
		shopper_queue.remove_at(0)
		next_shopper.emit()

func work_on_queue():
	if shopper_queue.is_empty() or in_work_cooldown:
		return
	if not shopper_queue.front().is_waiting_in_queue:
		return 
		
	if current_shopping_list.is_empty():
		current_shopping_list = shopper_queue[0].get_basket_list()
		set_progress_bar(current_shopping_list)
	
	Gold.add_gold(current_shopping_list[0]["value"])
	work_timer.start()
	in_work_cooldown = true
	current_shopping_list.remove_at(0)
	update_progress_bar(current_shopping_list)
	if current_shopping_list.is_empty():
		shopper_queue[0].bought_basket()
		shopper_queue.remove_at(0)
		next_shopper.emit()

func set_progress_bar(shopping_list):
	var shopping_size = len(shopping_list)
	work_progress_bar.min_value = 0
	work_progress_bar.max_value = shopping_size
	work_progress_bar.value = shopping_size
	work_progress_bar.visible = true
	show_progress_timer.start()

func update_progress_bar(list):
	work_progress_bar.value = len(list)
	work_progress_bar.visible = true
	show_progress_timer.start()
	
func _on_work_timer_timeout():
	in_work_cooldown = false

func _on_show_progress_timer_timeout():
	work_progress_bar.visible = false
