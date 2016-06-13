
require 'gosu'

require_relative 'game_states/play_state'

require_relative 'entities/submarine'
require_relative 'entities/prawn'
require_relative 'entities/party_horn'

require_relative 'controller'

class GameFactory

	def create_game(*players)
		play_state = PlayState.new

		play_state.controller = Controller.new

		sub_ctrl_method_names = submarine_callback_methods
		players.each do |curr_player|
			# TODO Needs multiple starting positions
			party_horn = PartyHorn.new
			sub = Submarine.new(150, 150, 0, Prawn.new(curr_player, party_horn))

			sub.player = curr_player
			play_state.add_entity(sub)

			sub_methods = add_method_callbacks({}, sub, sub_ctrl_method_names)
			add_button_callbacks(play_state.controller, 
								 curr_player.controls, 
								 sub_methods)
		end

		# TODO Set these somewhare else!
		play_state.width = 1024
		play_state.height = 768

		play_state
	end

	# TODO Move somewhere else.
	def submarine_callback_methods
		{:left => :move_left,
		:right => :move_right,
		:up => :move_up,
		:down => :move_down,
		:torpedo => :try_fire_torpedo}
	end

	# TODO Move somewhere else.
	def party_horn_callback_methods
		{:blow_party_horn => :blow}
	end

	def add_method_callbacks(all_callbacks, object, methods)
		methods.each do |label, method_name|
			all_callbacks[label] = object.public_method(method_name)
		end
		all_callbacks
	end

	def add_button_callbacks(controller, all_buttons, all_callbacks)
		all_buttons.each do |label, button|
			callback = all_callbacks[label]	
			controller.add_button_held_callback(button, callback)	
		end
	end

end
