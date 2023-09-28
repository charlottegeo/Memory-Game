extends Node
var score = 0
var sequence = []
var player_sequence = []
var currentindex = 0
var col_index = -1
var roundnum = 0 #keeps track of how many values have been added to the player input in a round
@onready var lightnodes = [$RedLight, $BlueLight, $GreenLight, $WhiteLight]
@onready var score_lbl = $Control/ScoreLbl
var keypressed = false
var canPress = false #sequence is done showing, player can try sequence now
var lightHex = {
	0: {"off": "#4d0000", "on" : "#ffb8ac"},
	1: {"off": "#08004d", "on": "#b9cbff"},
	2: {"off": "#0f4d00", "on": "#73ff57"},
	3: {"off": "#4d4d4d", "on": "#d4d4d4"}
}
var colorKeys = {
	0: JOY_BUTTON_X,
	1: JOY_BUTTON_Y,
	2: JOY_BUTTON_RIGHT_SHOULDER,
	3: JOY_BUTTON_LEFT_SHOULDER
}
# Called when the node enters the scene tree for the first time.
func _ready():
	currentindex = 0
	player_sequence.clear()
	makeSequence(1)
	showSequence()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("Player Seq. Size: " + str(player_sequence.size()) + " | Sequence Size: " + str(sequence.size()))	
func makeSequence(length):
	sequence.clear()
	for i in range(length):
		sequence.append(randi() % 4)
func addToSequence():
	sequence.append(randi() % 4)
func showSequence():
	for col_index in sequence:
		var light_node = lightnodes[col_index]
		light_node.modulate = lightHex[col_index]["on"]
		await get_tree().create_timer(0.2).timeout
		light_node.modulate = lightHex[col_index]["off"]
		await get_tree().create_timer(0.2).timeout
	canPress = true
func _input(event):
	if event is InputEventJoypadButton:
		if event.keycode == JOY_BUTTON_BACK:
			get_tree().quit()
	if event is InputEventJoypadButton and !keypressed and canPress:
		keypressed = true
		var key = event.keycode
		col_index = -1
		for color in colorKeys:
			var code = colorKeys[color]
			if code == key:
				col_index = color
				break
		if col_index >= 0:
			if roundnum <= sequence.size():
				player_sequence.append(col_index)
				roundnum += 1
				var light_node = lightnodes[col_index]
				light_node.modulate = lightHex[col_index]["on"]
				await get_tree().create_timer(0.25).timeout
				light_node.modulate = lightHex[col_index]["off"]
				if !player_sequence.is_empty():
					if player_sequence[currentindex] != sequence[currentindex]:
						get_tree().change_scene_to_file("res://scenes/gameover.tscn")
					else:
						currentindex += 1
					if currentindex >= sequence.size():
						score += 1
						score_lbl.text = "Score: " + str(score)
						currentindex = 0
						roundnum = 0
						addToSequence()
						await get_tree().create_timer(0.75).timeout
						canPress = false
						currentindex = 0
						col_index = -1
						player_sequence.clear()
						showSequence()
	else:
		keypressed = false
