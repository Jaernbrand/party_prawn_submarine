
require_relative '../../constants'
require_relative '../../gui/menu'
require_relative '../../gui/label'

# Menu that allows a player to see controls.
class PlayerControlsMenu < Menu

	attr_accessor :player_name, :controls

	# Creates a new PlayerControlsMenu for the player with the given name and
	# with the given control map as the current controls.
	#
	# * *Args*    :
	#   - +MainMenu+ +main+ -> The MainMenu which the current object is a submenu of 
	#   - <tt>Hash<Symbol, Numeric></tt> +controls+ -> The user contol map
	def initialize(main, controls)
		super(main.window)
		@main = main
		@player_name = player_name
		@controls = controls

		create_components
	end


private

	# Creates the menu components and adds them to the PlayerControlMenu.
	def create_components
		init_control_components
		init_back_button
	end

	# Creates the components related to the user controls and adds them to
	# the menu.
	def init_control_components
		messages = @window.user_messages
		keys = @controls.keys
		keys.sort!

		index = 0
		keys.each do |key|

			emplace_action(key, index)
			emplace_keyname(@controls[key], index, messages)

			index += 1
		end
	end

	def emplace_action(key, index)
		action = Label.new(key.to_s, 
						   Constants::TEXT_HEIGHT, 
						   Constants::FONT_NAME)
		action.x = 100
		action.y = 100 + 100 * (index*0.5)

		add_component(action)
	end

	def emplace_keyname(value, index, messages)
		keyname = Label.new(messages.keyname(value),
						   Constants::TEXT_HEIGHT, 
						   Constants::FONT_NAME)
		keyname.x = 300
		keyname.y = 100 + 100 * (index*0.5)

		add_component(keyname)
	end

	# Creates the button for moving back to the previous menu and adds it to 
	# the PlayerControlsMenu instance.
	def init_back_button
		messages = @window.user_messages
		back = Button.new(@window, 
						  messages.message(:back), 
						  Constants::TEXT_HEIGHT, 
						  Constants::FONT_NAME)

		back.x = 100
		back.y = 650
		back.add_callback(:release, create_back_button_callback)

		add_component(back)
	end

	# Creates the callable to be called when the back button is pressed.
	#
	# * *Returns* :
	#   - callable to be called when the back button is pressed
	# * *Return* *Type* :
	#   - Proc
	def create_back_button_callback
		lambda do
			@main.current_menu = @parent
		end
	end

end

