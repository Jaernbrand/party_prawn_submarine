#!/usr/bin/env ruby

require_relative 'game_window'

require_relative 'player'
require_relative 'control_mapper'

require_relative 'factories/game_factory'
require_relative 'factories/game_controller_factory'

require_relative 'game_states/play_state'

require_relative 'entities/submarine' 
require_relative 'entities/prawn'
require_relative 'entities/torpedo'
require_relative 'entities/party_horn'
require_relative 'entities/explosion'

control_mapper = ControlMapper.new
ctrls = control_mapper.controls
player1 = Player.new('Player1', ctrls[0])
player1.colour = 0xff_ff0000
player2 = Player.new('Player2', ctrls[1])
player2.colour = 0xff_00ff00

# TODO Actual main starts here.

# Only gets executed if the current file is called as main.
if __FILE__ == $0
	window = GameWindow.new

	[PlayState, Torpedo, Submarine, Prawn, PartyHorn, Explosion].each do |cls| 
		cls::preload(window)
	end

	factory = GameFactory.new(GameControllerFactory.new)
	play_state = factory.create_game(player1, player2)

	window.state = play_state
	window.show
end
