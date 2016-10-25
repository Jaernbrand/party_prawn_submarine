
# Represents a player that plays the game. The player name is used to identify 
# the Player.
class Player

	# The name of the Player
	attr_accessor :name
	
	# The colour of the Player
	attr_accessor :colour 
	
	# The Player's Submarine
	attr_accessor :submarine
   
	# The Player's PartyHorn
	attr_accessor :party_horn

	# The controls used for player interaction
	attr_accessor :controls

	# The z value of the Player. Used when drawing the Player's entities.
	attr_accessor :z

	# Creates a new Player instance with the given name. May optionally be 
	# initialised with a Hash containing player controls. See ControlMapper
	# for additional information regarding the controls.
	#
	# * *Args*    :
	#   - +String+ +name+ -> the name of the player
	#   - <tt>Hash<Symbol, Numeric></tt> +controls+ -> the player controls
	def initialize(name, controls={})
		@name = name
		@controls = controls

		@z = 0
	end

	# Checks if the given object equals the current Player object. The other
	# object is considered equal to the current one if the other object is an
	# instance of Player and the names of teh two objects are equal.
	#
	# * *Args*    :
	#   - +object+ +other+ -> The other instance to check for equality
	# * *Returns* :
	#   - Whether the given object equals the current one
	# * *Return* *Type* :
	#   - boolean
	def ==(other)
		if other.instance_of?(Player)
			return other.name == @name
		end
		false
	end

	# Compares the given Player instances with the current one. The comparison
	# is based on the names of the Player objects. A player object is greater
	# than an other if the name is greater than the others name.
	#
	# * *Args*    :
	#   - +Player+ +other+ -> The other object to compare the current one with
	# * *Returns* :
	#   - 0 if the objects are equal, -1 if the current object is less than the other and 1 if the current object is greater than the other
	# * *Return* *Type* :
	#   - Numeric
	def <=>(other)
		@name <=> other.name
	end

	# Returns a hash value based on the name of the Player instance.
	#
	# * *Returns* :
	#   - hash based on the name of the Player instance
	# * *Return* *Type* :
	#   - Fixnum
	def hash
		@name.hash
	end

	# Two Players are considered equal if their names are considered equal,
	# which they do if they have the same length and content.
	#
	# * *Args*    :
	#   - +Player+ +other+ -> The other Player to check for equality
	# * *Returns* :
	#   - Whether the given object equals the current one
	# * *Return* *Type* :
	#   - boolean
	def eql?(other)
		@name.eql?(other.name)
	end

end

