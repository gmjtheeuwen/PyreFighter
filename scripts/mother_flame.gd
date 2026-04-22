extends Flame

var spawn_delay := 5.0
var time_since_spawn := 2.5
var enemy_scene = preload("res://scenes/enemy.tscn")
var enemy_stats: EnemyStats
@export var max_enemy_count := 5
var enemy_count = 0

func _ready() -> void:
	var anim_name = str(FuelType.keys()[fuel_type]).to_lower()
	sprite.play(anim_name)
	enemy_stats = load("res://resources/enemies/%s_enemy_stats.tres" % Flame.FuelType.keys()[fuel_type].to_lower())

func _process(delta: float) -> void:
	time_since_spawn += delta
	if time_since_spawn > spawn_delay:
		time_since_spawn = 0.0
		
		if enemy_count < max_enemy_count:
			spawn()
	

func spawn():
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.stats = enemy_stats
	var direction = Vector2.from_angle(randf()* 2 * PI)
	enemy.global_position = global_position + direction * Vector2(64, 64)
	enemy.defeated.connect(on_enemy_death)
	get_parent().get_node("EnemyManager").add_child(enemy)
	enemy_count += 1

func on_enemy_death():
	enemy_count -= 1
