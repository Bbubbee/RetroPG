extends Node2D

var battle_units = preload("res://Assets/Resources/BattleUnits.tres")

signal died 
signal end_turn
signal action_done

@export var attack_damage: int = 4
@export var max_hp: int = 35 
@export var heal_amount: int = 5

@onready var damage_taken_label = preload("res://Scenes/damage_taken_label.tscn")
@onready var hp_label = $HealthLabel
@onready var animation_player = $AnimationPlayer
@onready var hp = max_hp: 
	set(new_hp):
		hp = clamp(new_hp, 0, max_hp)
		hp_label.text = str(hp) + "hp"

var max_ap = 2
var ap = max_ap


func _ready():
	hp_label.text = str(hp)+"hp"
	battle_units.enemy = self

func _exit_tree():
	battle_units.enemy = null
	
func StartTurn(): 
	await get_tree().create_timer(0.4).timeout 
	
	ap = max_ap
	# NOTE: Used to check if is dead here. 
	# Redundant because death check happens when enemy takes damage. 
	# Recode if there is means of enemy dying DURING their turn. 
	if not IsDead():
		while ap > 0: 
			ChooseAnAction()
			await action_done
			ap -= 1
			await get_tree().create_timer(0.4).timeout 
	
	emit_signal("end_turn")

# OVERRIDE for other enemies. May add another base action.
# You have to emit signal "action_done" after each potential action! 
# This function will heal (1/3) and attack (2/3)
func ChooseAnAction():
	randomize()
	var r = randi_range(0, 2)
	if r == 1: 
		Heal()
	else: 
		Attack()

func Heal(): 
	animation_player.play("Shake") 
	await animation_player.animation_finished  
	$HealSound.play()
	animation_player.play("Shake") 
	await animation_player.animation_finished  
	hp += heal_amount
	ShowDamageHealed(heal_amount)
	emit_signal("action_done")
	
		
func Attack() -> void:
	animation_player.play("Attack")  # Calls DealDamage().
	await animation_player.animation_finished  
	emit_signal("action_done")
	
	
func DealDamage(): 
	$DealDamage.play()
	PlayerStats.TakeDamage(attack_damage)


func TakeDamage(amount): 
	animation_player.play("Shake")
	await animation_player.animation_finished
	self.hp -= amount 
	ShowDamageTaken(amount)
	
	if IsDead():
		Dies()
	emit_signal("action_done")
	
func Dies(): 
	battle_units.enemy = null
	
	animation_player.play("Fades")
	await animation_player.animation_finished
	
	emit_signal("end_turn") 
	emit_signal("died") 
	queue_free()
	
func IsDead():
	return hp <= 0  # If dead return true.
	
func ShowDamageHealed(amount):
	var heal_label = damage_taken_label.instantiate()
	hp_label.add_child(heal_label)
	heal_label.ShowStatIncreased("+"+str(amount))
	
func ShowDamageTaken(damage):
	var damage_label = damage_taken_label.instantiate()
	hp_label.add_child(damage_label)
	damage_label.ShowDamageTaken("-"+str(damage))



	


		

		
