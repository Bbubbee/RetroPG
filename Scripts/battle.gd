extends Node

@onready var player_battle_action_buttons = $UI/BattleActionButtons
@onready var animation_player = $AnimationPlayer
@onready var next_room_button = $UI/CenterContainer/NextRoomButton
@onready var enemy_position = $EnemyPosition

@export var enemies : Array[PackedScene] 

var battle_units = preload("res://Assets/Resources/BattleUnits.tres")

enum {
	LEVEL1,
	LEVEL2,
	LEVEL3
}
var current_level = LEVEL1

func _ready():
	battle_units.battle_scene = self
	CreateNewEnemy()
	StartPlayerTurn()

func _exit_tree():
	PlayerStats.intersection += 1
	battle_units.battle_scene = null
	
		
func StartPlayerTurn(): 
	next_room_button.hide() 
	player_battle_action_buttons.show()
	
	PlayerStats.ap = PlayerStats.max_ap
	await PlayerStats.end_turn
	StartEnemyTurn()

func StartEnemyTurn():
	player_battle_action_buttons.hide()
	
	var enemy = battle_units.enemy
	if enemy and not enemy.is_queued_for_deletion():
		enemy.StartTurn()
		await enemy.end_turn  
	StartPlayerTurn()


func _on_next_room_button_pressed():
	next_room_button.disabled = true 
	
	match PlayerStats.intersection: 
		3:
			SceneTransition.ChangeScene("res://Scenes/Intersections/first_intersection.tscn")
		6: 
			SceneTransition.ChangeScene("res://Scenes/level_2.tscn")
			# Goes to second intersection after. 
		9:
			SceneTransition.ChangeScene("res://Scenes/Intersections/third_intersection.tscn")
		12:
			SceneTransition.ChangeScene("res://Scenes/level_3.tscn")	
			# Goes to fourth intersection after. 
		15:
			SceneTransition.ChangeScene("res://Scenes/Intersections/fifth_intersection.tscn")
		18:
			SceneTransition.ChangeScene("res://Scenes/Intersections/sixth_intersection.tscn")
			# Show boss message after. Heal and restore mana.
		_: 
			SceneTransition.ChangeScene("res://Scenes/battle.tscn")

func _on_enemy_died(): 
	next_room_button.show()
	PlayerStats.ap = PlayerStats.max_ap
	player_battle_action_buttons.hide() 
	
func CreateNewEnemy(): 
	enemies.shuffle()
	var enemy = enemies[0].instantiate()
	battle_units.enemy = enemy
	enemy_position.add_child(enemy)
	enemy.died.connect(_on_enemy_died)


	
	
	

	
