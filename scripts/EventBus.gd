extends Node

signal shoot_cannonball(position, target, player, shooting_dir, charge)
signal rotate_player_cannon(mousepos, player_pos)
signal charge_player_cannon(charge, charging_dir, player_pos)
signal charge_cannon(mouse_pos)
signal cannonball_shot()
signal pass_target_location(target_location)
signal player_hit(name, killer)
