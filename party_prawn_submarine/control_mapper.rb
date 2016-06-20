
require 'gosu'

# Handles the mappings of player actions to keyboard buttons. See gosu's 
# documentation for button constants. Player actions are represented as symbols.
# Each mapping is stored as a Hash with player actions as keys and keyboard
# constans as values (Hash<Symbol, Numeric>).
#
# Possible player actions are the following:
#   - :up -> moves the player's avatar up
#   - :down -> moves the player's avatar down
#   - :left -> moves the player's avatar left
#   - :right -> moves the player's avatar right
#   - :torpedo -> fires a torpedo
#   - :blow_party_horn -> blows a party horn
class ControlMapper

	# Initialises a new ControlMapper with the standard control mappings.
	def initialize
		@maps = std_controls
	end

	# Returns a copy of the array containing control maps.
	#
	# * *Returns* :
	#   - array containing the standard control mappings.
	# * *Return* *Type* :
	#   - Array<Hash<Symbol, Numeric>>
	def controls
		@maps.dup
	end


private
	
	# Returns an array containing the standard control mappings.
	#
	# * *Returns* :
	#   - array containing the standard control mappings.
	# * *Return* *Type* :
	#   - Array<Hash<Symbol, Numeric>>
	def std_controls
		[{:up => Gosu::KbW,
		:down => Gosu::KbS,
		:left => Gosu::KbA,
		:right => Gosu::KbD,
		:torpedo => Gosu::KbE,
		:blow_party_horn => Gosu::KbQ},

		{:up => Gosu::KbNumpad5,
		:down => Gosu::KbNumpad2,
		:left => Gosu::KbNumpad1,
		:right => Gosu::KbNumpad3,
		:torpedo => Gosu::KbNumpad6,
		:blow_party_horn => Gosu::KbNumpad4},

		{:up => Gosu::KbU,
		:down => Gosu::KbJ,
		:left => Gosu::KbH,
		:right => Gosu::KbK,
		:torpedo => Gosu::KbI,
		:blow_party_horn => Gosu::KbY},

		{:up => Gosu::KbUp,
		:down => Gosu::KbDown,
		:left => Gosu::KbLeft,
		:right => Gosu::KbRight,
		:torpedo => Gosu::KbRightShift,
		:blow_party_horn => Gosu::KbRightControl}]
	end

end
