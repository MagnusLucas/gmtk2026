extends Node


func _on_countdown_timeout() -> void:
	get_tree().paused = true
	$LosePopup.visible = true
	
	
func win():
	get_tree().paused = true
	$WinPopup.visible = true
	
	
