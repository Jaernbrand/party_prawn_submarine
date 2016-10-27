#!/usr/bin/env ruby

require_relative 'game_window'

require_relative 'player'
require_relative 'control_mapper'

require_relative 'factories/game_factory'
require_relative 'factories/game_controller_factory'

require_relative 'game_states/play_state'
require_relative 'game_states/main_menu'

require_relative 'entities/submarine' 
require_relative 'entities/prawn'
require_relative 'entities/torpedo'
require_relative 'entities/party_horn'
require_relative 'entities/explosion'


# Only gets executed if the current file is called as main.
if __FILE__ == $0
	window = GameWindow.new

	[PlayState, Torpedo, Submarine, Prawn, PartyHorn, Explosion].each do |cls| 
		cls::preload(window)
	end

	factory = GameFactory.new(GameControllerFactory.new)

	window.state = MainMenu.new(window)
	window.show
end
