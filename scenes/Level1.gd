extends Node2D

export var MAX_BIRBS = (10 * Settings.difficulty_mult) + 1
export var MAX_TREATERS = 8
export (PackedScene) var TREATER_NODE
export (PackedScene) var BIRB_NODE

var BIRB_AMOUNT = 0
var rng = RandomNumberGenerator.new()

func _ready():
	Audio.play("mainloop")
	rng.randomize()

func _on_Spawner_timeout():
	var current_treaters = self.get_tree().get_nodes_in_group("treater").size()
	var current_birbs = self.get_tree().get_nodes_in_group("birb").size()

	if current_treaters < MAX_TREATERS:
		var child = TREATER_NODE.instance()
		var dir = 1

		if randi() % 2 == 1:
			dir = -1

		child.position = Vector2($Player.position.x + (dir * 1200), $Spawner/SpawnPos.position.y)
		child.dir = dir * -1

		add_child(child)

		print("Spawning treater...")

	if current_birbs < BIRB_AMOUNT:
		var chick = BIRB_NODE.instance()
		var dir = 1

		if rng.randi() % 2 == 1:
			dir = -1

		$Birb/Pos.unit_offset = rng.randf()

		chick.position = Vector2($Player.position.x + (dir * 1200), $Birb/Pos.position.y)
		chick.dir = dir * -1

		add_child(chick)

		print("Spawning birb...")

	$Spawner.start()

func moar_birbs():
	BIRB_AMOUNT = clamp(BIRB_AMOUNT + Settings.difficulty_mult, 0, MAX_BIRBS)
	$BirbTimer.start()
