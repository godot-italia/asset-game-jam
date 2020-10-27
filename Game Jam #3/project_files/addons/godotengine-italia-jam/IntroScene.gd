extends CanvasLayer

signal intro_finished()

export (Array, Texture) var clouds = []
export var cloud_spawn_timer = 2.0
export var cloud_random_timer = 1.0
export var initial_clouds = 3
export var cloud_speed = 100.0

var _spawned_clouds = []
var _timer = null

func _ready():
	randomize()
#	for i in range(initial_clouds):
#		_spawn_cloud()
	_spawn_cloud()
	_timer = Timer.new()
	_timer.wait_time = cloud_spawn_timer
	_timer.connect("timeout", self, "_timer_timeout")
	add_child(_timer)
	_timer.start()
	$AnimationPlayer.connect("animation_finished", self, "_anim_finished")

func _anim_finished(_name):
	emit_signal("intro_finished")

func _timer_timeout():
	_timer.wait_time = cloud_spawn_timer + randf() * cloud_random_timer
	_timer.start()
	_spawn_cloud()

func _spawn_cloud():
	var cloud = TextureRect.new()
	cloud.texture = clouds[randi()%clouds.size()]
	cloud.modulate.a = 0.5 + randf() * 0.6
	_spawned_clouds.append(cloud)
	$Sky.add_child(cloud)
	cloud.rect_position = Vector2(-cloud.texture.get_width(), randf() * get_viewport().size.y / 4.0)

func _process(delta):
	var clouds_to_delete = []
	for c in _spawned_clouds:
		c.rect_position.x += delta * cloud_speed
		if c.rect_position.x > get_viewport().size.x:
			clouds_to_delete.append(c)
	for c in clouds_to_delete:
		_spawned_clouds.erase(c)
