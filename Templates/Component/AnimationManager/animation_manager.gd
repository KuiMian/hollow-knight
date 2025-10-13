#extends AnimatedSprite2D
#class_name AnimatedManager
#
#
#
#var state_machine: StateMachine
#
#
#func _ready() -> void:
	#animation_finished.connect(
		#func(): 
			#if animation =="attack":
				#state_machine.player.isAttacking = false
			#
			#if animation == "resist":
				#state_machine.player.isResisting = false
	#)
#
#
#func _enter_tree() -> void:
	#state_machine = get_node("%StateMachine")
	#state_machine.state_enter.connect(StateEnter)
	#state_machine.state_exit.connect(StateExit)
	#state_machine.state_update.connect(StateUpdate)
	#
	#
#func StateEnter(state: String):
	##match state:
		##"Walk":
			##stream = WalkAudio
		##"Attack":
			##stream = AttackAudio
		##"Resist":
			##stream = ResistAudio
	##
	##play()
	#pass
#
#
#func StateExit(state: String):
	##if state == "Walk":
		##stop()
	#pass
#
#
#func StateUpdate(state: String):
	#play(state.to_lower())
	#
	#if state == "Walk":
		#flip_h = state_machine.player.axis > 0
