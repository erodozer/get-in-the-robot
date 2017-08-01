extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const freq = 5
var spawner = 0
var enemy_template
func _ready():
	enemy_template = preload("res://prefabs/Enemy.tscn")
	set_process(true)
	
func can_spawn():
	var enemy_count = 0
	for i in get_node("../Actors").get_children():
		if i.is_in_group("enemy"):
			enemy_count += 1
	return spawner > freq and enemy_count < 3

func add_enemy(spawn_point):
	var enemy = enemy_template.instance()
	var end_point = spawn_point.transform.origin
	enemy.translation = end_point
	var x = enemy.rotation.x
	var z = enemy.rotation.z
	enemy.look_at(Vector3(0,0,0), Vector3(0, 1, 0))
	enemy.rotation.x = x
	enemy.rotation.z = z
	enemy.translate(-enemy.get_global_transform().basis[2].normalized() * 10)
	enemy.get_node("sariel/AnimationPlayer").play("jump", .1)
	var tween = enemy.get_node("Tween")
	tween.interpolate_property(enemy, "translate:y", 0, 3, .8, 0, 0)
	tween.interpolate_property(enemy, "translate:y",  0, 3, .8, 0, 0, 1.2)
	tween.interpolate_property(enemy, "translate:z", enemy.translation.z, end_point.z, 2, 0, 0)
	tween.start()
	
	get_node("../Actors").add_child(enemy)

func _process(delta):
	spawner += delta
	if can_spawn():
		var point = get_children()[rand_range(0, get_child_count())]
		add_enemy(point)
		spawner = 0