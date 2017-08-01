extends Node

const SPAWN_RATE = 15
var spawn_timer = 0

func _ready():
	set_process(true)
	
func _building_exists():
	return has_node("./Anchor/Building")
	
func _spawn_building():
	$"./Anchor/Building".rotate = Vector3()
	
func _process(delta):
	if spawn_timer < SPAWN_RATE:
		spawn_timer += delta
	
	if spawn_timer > SPAWN_RATE and not _building_exists():
		