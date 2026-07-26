extends Resource
class_name BossAttackResource


func attack(targets, board_size = 5, board_tile_size = 64):
	for target in targets:
		var expected_x = randi_range(0,(board_size*board_tile_size))
		var expected_y = randi_range(0,(board_size*board_tile_size))
		target.get_attacked(expected_x, expected_y)
		
