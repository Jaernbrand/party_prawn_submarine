
require 'gosu'

require_relative '../entities/submarine'
require_relative '../entities/prawn'
require_relative '../entities/party_horn'

require_relative '../controller'

# Factory that creates Controller's for playing the game. This factory assumes
# that all the given players uses the same keyboard.
class GameControllerFactory

	# Creates a Controller for the given list of players. Note that the 
	# GameControllerFactory assumes that all the given players uses the same
	# keyboard.
	#
	# * *Args*    :
	#   - +Player+ +players+ -> The players separeted by commas
	# * *Returns* :
	#   - Controller for the given players.
	# * *Return* *Type* :
	#   - Controller
	def create_controller(*players)
		controller = Controller.new
		players.each do |player|
			create_player_controls(controller, player)
		end
		controller
	end


private

	# Creates the controls of the given player and adds them to the supplied 
	# controller.
	#
	# * *Args*    :
	#   - +Player+ +player+ -> The player to add controls for
	def create_player_controls(controller, player)
		sub_methods = submarine_callbacks(player.submarine)
		horn_methods = party_horn_callbacks(player.party_horn)

		controller_add_held_callbacks(controller, player.controls, sub_methods)
		controller_add_down_callbacks(controller, player.controls, horn_methods)
	end

	# Returns a Hash containing player actions associated with a method. The
	# player action is represented by a symbol and the method is associated 
	# with submarine.
	#
	# * *Args*    :
	#   - +Submarine+ +submarine+ -> Submarine associated with the methods in the returned Hash
	# * *Returns* :
	#   - Hash containing player actions as keys and methods associated with submarine as values
	# * *Return* *Type* :
	#   - Hash<Symbol, Method>
	def submarine_callbacks(submarine)
		{:left => submarine.public_method(:move_left),
		:right => submarine.public_method(:move_right),
		:up => submarine.public_method(:move_up),
		:down => submarine.public_method(:move_down),
		:torpedo => submarine.public_method(:try_fire_torpedo)}
	end

	# Returns a Hash containing player actions associated with a method. The
	# player action is represented by a symbol and the method is associated 
	# with horn.
	#
	# * *Args*    :
	#   - +PartyHorn+ +horn+ -> PartyHorn associated with the methods in the returned Hash
	# * *Returns* :
	#   - Hash containing player actions as keys and methods associated with horn as values
	# * *Return* *Type* :
	#   - Hash<Symbol, Method>
	def party_horn_callbacks(horn)
		{:blow_party_horn => horn.public_method(:blow)}
	end

	# Adds button held callbacks to the given controller. The keys in both 
	# Hashes are symbols representing a player controlled action. The 
	# all_buttons Hash contains the button constants as values, see Guso's 
	# documentation for more information regarding the constants. The 
	# all_callbacks Hash contains the callables to be called when the 
	# associated button event fires.
	#
	# * *Args*    :
	#   - +Controller+ +controller+ -> Controller to add the callbacks to
	#   - <tt>Hash<Symbol, Fixnum></tt> +all_buttons+ -> Button's to use as keys for the callbacks
	#   - <tt>Hash<Symbol, callable></tt> +all_callbacks+ -> Callbacks to add
	def controller_add_held_callbacks(controller, all_buttons, all_callbacks)
		all_buttons.each do |label, button|
			callback = all_callbacks[label]	
			if callback != nil
				controller.add_button_held_callback(button, callback)	
			end
		end
	end

	# Adds button down callbacks to the given controller. The keys in both 
	# Hashes are symbols representing a player controlled action. The 
	# all_buttons Hash contains the button constants as values, see Guso's 
	# documentation for more information regarding the constants. The 
	# all_callbacks Hash contains the callables to be called when the 
	# associated button event fires.
	#
	# * *Args*    :
	#   - +Controller+ +controller+ -> Controller to add the callbacks to
	#   - <tt>Hash<Symbol, Fixnum></tt> +all_buttons+ -> Button's to use as keys for the callbacks
	#   - <tt>Hash<Symbol, callable></tt> +all_callbacks+ -> Callbacks to add
	def controller_add_down_callbacks(controller, all_buttons, all_callbacks)
		all_buttons.each do |label, button|
			callback = all_callbacks[label]	
			if callback != nil
				controller.add_button_down_callback(button, callback)	
			end
		end
	end

	# Adds button up callbacks to the given controller. The keys in both 
	# Hashes are symbols representing a player controlled action. The 
	# all_buttons Hash contains the button constants as values, see Guso's 
	# documentation for more information regarding the constants. The 
	# all_callbacks Hash contains the callables to be called when the 
	# associated button event fires.
	#
	# * *Args*    :
	#   - +Controller+ +controller+ -> Controller to add the callbacks to
	#   - <tt>Hash<Symbol, Fixnum></tt> +all_buttons+ -> Button's to use as keys for the callbacks
	#   - <tt>Hash<Symbol, callable></tt> +all_callbacks+ -> Callbacks to add
	def controller_add_up_callbacks(controller, all_buttons, all_callbacks)
		all_buttons.each do |label, button|
			callback = all_callbacks[label]	
			if callback != nil
				controller.add_button_up_callback(button, callback)	
			end
		end
	end

end
