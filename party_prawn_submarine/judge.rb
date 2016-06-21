
require 'set'

# Judges when a game is over and who's the winner. The Judge identifies Players
# based on their names. The result of this is that player names can't be 
# changed during a game with the current Judge. All names also have to be
# unique.
class Judge

	# Creates a new Judge object that judges a game between the supplied 
	# players.
	#
	# * *Args*    :
	#   - +Player+ +players+ -> all the players to be judged
	def initialize(*players)
		@alive = Set.new
		@dead = Set.new

		@alive.merge(players)
	end

	# Returns a duplicate of the alive Set. The alive Set contains all 
	# currently alive players.
	#
	# * *Returns* :
	#   - duplicate of the alive Set
	# * *Return* *Type* :
	#   - Set<Player>
	def alive
		@alive.dup
	end

	# Returns a duplicate of the dead Set. The dead Set contains all 
	# currently dead players.
	#
	# * *Returns* :
	#   - duplicate of the dead Set
	# * *Return* *Type* :
	#   - Set<Player>
	def dead
		@dead.dup
	end

	# Checks if the game is over. A game is considered over if one or none
	# players are alive.
	#
	# * *Returns* :
	#   - Whether the game is over
	# * *Return* *Type* :
	#   - boolean
	def game_over?
		return @alive.length <= 1
	end

	# Returns the winner if one exists.
	#
	# * *Returns* :
	#   -The winning player or nil if one doesn't exist
	# * *Return* *Type* :
	#   - Player or nil
	def winner
		winner = nil

		# Note! @alive should be of length 1 or 0 at this point.
		if @alive.length == 1
			@alive.each { |player| winner = player }
		end

		winner
	end

	# Moves the given player from the living to the dead.
	#
	# * *Args*    :
	#   - +Player+ +player+ -> The player that died
	def died(player)
		if @alive.include?(player)
			@alive.delete(player)
			@dead << player
		end
		nil
	end

end

