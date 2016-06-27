
require 'gosu'

require_relative '../game_states/play_state'
require_relative '../judge'

require_relative '../entities/submarine'
require_relative '../entities/prawn'
require_relative '../entities/party_horn'

# Creates games where all players uses the same keyboard to control their
# Submarines.
class GameFactory

	# Initialises a new GameFactory with the given controller factory.
	#
	# * *Args*    :
	#   - +object+ +controller_factory+ -> The factory responsible for the construction of player controls in the PlayStates constructed by the GameFactory
	def initialize(controller_factory)
		@controller_factory = controller_factory
	end

	# Creates a new game to be played by the given players.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The GameWindow in which the game is played
	#   - +Player+ +players+ -> The players of the game to be constructed
	# * *Returns* :
	#   - game to be played by the given players
	# * *Return* *Type* :
	#   - PlayState
	def create_game(window, *players)
		play_state = PlayState.new

		players.each do |curr_player|
			party_horn = PartyHorn.new
			# TODO Needs multiple starting positions
			sub = Submarine.new(150, 150, 0, Prawn.new(curr_player, party_horn))

			sub.player = curr_player
			play_state.add_entity(sub)

			curr_player.submarine = sub
			curr_player.party_horn = party_horn
		end

		# TODO Set these somewhare else!
		play_state.width = 1024
		play_state.height = 768

		play_state.window = window

		play_state.controller = @controller_factory.create_controller(*players)
		play_state.judge = Judge.new(*players)

		play_state
	end

end
