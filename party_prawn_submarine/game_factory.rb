
require 'gosu'

require_relative 'game_states/play_state'

require_relative 'entities/submarine'
require_relative 'entities/prawn'
require_relative 'entities/party_horn'

class GameFactory

	def create_game(*players)
		play_state = PlayState.new

		players.each do |curr_player|
			# TODO Needs multiple starting positions
			party_horn = PartyHorn.new
			sub = Submarine.new(150, 150, 0, Prawn.new(curr_player, party_horn))

			sub.player = curr_player
			play_state.add_entity(sub)
		end

		# TODO Set these somewhare else!
		play_state.width = 1024
		play_state.height = 768

		play_state
	end

end
