extends Node


var current_room = 0   # Start = 0. Boss = 18
var current_level = 1  # Start = 1. Boss = 3


func GoToNextIntersection(): 
	current_room += 1
	ShowNextScene()
	
func GoToStartOfLevel():
	if current_level == 1: 
		current_room = 0
		ShowNextScene()
	if current_level == 2: 
		current_room = 0
		ShowNextScene()
	if current_level == 3: 
		current_room = 0
		ShowNextScene()
	else: 
		current_room = 0
		ShowNextScene()

func ShowNextScene(): 
	match current_room: 
		# These are all the intersections. They occur when you reach a certain room. 
		3:  # Intersection 1
			SceneTransition.ChangeScene("res://Scenes/Intersections/first_intersection.tscn")
		6:  # Level 2
			SceneTransition.ChangeScene("res://Scenes/level_2.tscn")
			LevelManager.current_level = 2
			# Intersection 2 - goes here after level_2.tscn.
		9:  # Intersection 3
			SceneTransition.ChangeScene("res://Scenes/Intersections/third_intersection.tscn")
		12: # Level 3
			SceneTransition.ChangeScene("res://Scenes/level_3.tscn")	
			LevelManager.current_level = 3
			# Intersection 4 - goes here after level_3.tscn.
		15: # Intersection 5 
			SceneTransition.ChangeScene("res://Scenes/Intersections/fifth_intersection.tscn")
		18: # Intersection 6 - Final Intersection. Boss message. Restore Player. 
			SceneTransition.ChangeScene("res://Scenes/Intersections/sixth_intersection.tscn")
		_: 
			# Basic room. Fight an enemy!
			SceneTransition.ChangeScene("res://Scenes/battle.tscn") 
			
func RestartLevel():
	PlayerStats.RestoreStats()
	if current_level == 1: 
		current_room = 0 
		SceneTransition.ChangeScene("res://Scenes/battle.tscn") 
		PlayerStats.action_dictionary.erase("fireball")
		PlayerStats.action_dictionary.erase("drain")
		
	elif current_level == 2: 
		current_room = 6 
		SceneTransition.ChangeScene("res://Scenes/battle.tscn") 
		PlayerStats.has_upgraded_sword = false 
		PlayerStats.has_shield = false
	elif current_level == 3:
		current_room = 12 
		PlayerStats.action_dictionary.erase("crux")
		PlayerStats.action_dictionary.erase("rend")
		PlayerStats.action_dictionary.erase("blight")
		SceneTransition.ChangeScene("res://Scenes/battle.tscn") 

func RestartGame(): 
	PlayerStats.RestoreStats()
	current_level = 1
	current_room = 0 
	SceneTransition.ChangeScene("res://Scenes/battle.tscn") 

func GoToBoss(): 
	SceneTransition.ChangeScene("res://Scenes/boss_battle.tscn") 
	
func GoToVictoryScreen(): 
	SceneTransition.ChangeScene("res://Scenes/victory_screen.tscn")
