
require 'gosu'

require_relative '../game_states/play_state'
require_relative '../judge'

require_relative '../entities/submarine'
require_relative '../entities/prawn'
require_relative '../entities/party_horn'

require_relative '../point'

# Creates games where all players uses the same keyboard to control their
# Submarines.
class GameFactory

	# The width of the game board
	BOARD_WIDTH = 1024

	# The height of the game board
	BOARD_HEIGHT = 768


	# Initialises a new GameFactory with the given controller factory.
	#
	# * *Args*    :
	#   - +object+ +controller_factory+ -> The factory responsible for the construction of player controls in the PlayStates constructed by the GameFactory
	def initialize(controller_factory)
		@controller_factory = controller_factory

		@starting_positions = create_starting_positions
		@pos_idx = 0
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

		@pos_idx = 0

		create_player_entities(play_state, players)

		play_state.width = BOARD_WIDTH
		play_state.height = BOARD_HEIGHT 

		play_state.window = window

		play_state.controller = @controller_factory.create_controller(*players)
		play_state.judge = Judge.new(*players)

		play_state
	end


private

	# Returns an Array with all possible starting positions on the game board.
	#
	# * *Returns* :
	#   - Array with starting positions
	# * *Return* *Type* :
	#   - Array<Point>
	def create_starting_positions
		[Point.new(BOARD_WIDTH/4, BOARD_HEIGHT/4),
   		Point.new(3 * BOARD_WIDTH/4, 3 * BOARD_HEIGHT/4),
		Point.new(3 * BOARD_WIDTH/4, BOARD_HEIGHT/4),
		Point.new(BOARD_WIDTH/4, 3 * BOARD_HEIGHT/4)]
	end

	# Returns the next starting position.
	#
	# * *Returns* :
	#   - the next starting position
	# * *Return* *Type* :
	#   - Point
	def next_starting_position
		pos = @starting_positions[@pos_idx]
		@pos_idx = (@pos_idx + 1) % @starting_positions.length
		pos
	end

	# Creates the player controlled entities and adds them to the given 
	# PlayState.
	#
	# * *Args*    :
	#   - +PlayState+ +play_state+ -> The PlayState to add entities to
	#   - +Array<Player>+ +players+ -> The players for which to create entities
	def create_player_entities(play_state, players)
		players.each do |curr_player|
			party_horn = PartyHorn.new

			pos = next_starting_position
			sub = Submarine.new(pos.x, 
								pos.y, 
								0, 
								Prawn.new(curr_player, party_horn))

			sub.player = curr_player
			play_state.add_entity(sub)

			curr_player.submarine = sub
			curr_player.party_horn = party_horn
		end
	end

end
