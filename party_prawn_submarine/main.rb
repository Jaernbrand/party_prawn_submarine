#!/usr/bin/env ruby

require_relative 'game_window'

require_relative 'player'
require_relative 'controls'

require_relative 'factories/game_factory'
require_relative 'factories/game_controller_factory'

require_relative 'game_states/play_state'

require_relative 'entities/submarine' 
require_relative 'entities/prawn'
require_relative 'entities/torpedo'
require_relative 'entities/party_horn'


player = Player.new(Controls::get_std_controls)
player.colour = 0xff_ff0000

# TODO Actual main starts here.

# Only gets executed if the current file is called as main.
if __FILE__ == $0
	window = GameWindow.new

	[PlayState, Torpedo, Submarine, Prawn, PartyHorn].each do |cls| 
		cls::preload(window)
	end

	factory = GameFactory.new(GameControllerFactory.new)
	play_state = factory.create_game(player)

	window.state = play_state
	window.show
end
