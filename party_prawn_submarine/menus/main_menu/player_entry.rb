
require_relative '../../constants'

require_relative '../../gui/button'
require_relative '../../gui/text_pane'
require_relative '../../gui/checkbox'

require_relative '../../player'

require_relative 'player_controls_menu'

# Contains the GUI representation of the options for one player. This class
# allows the user to change some options regarding the player.
class PlayerEntry

	# Creates a entry with the player options for one player.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The window in which the contents are drawn
	#   - +MainMenu+ +main+ -> The MainMenu for which the current object is a submenu
	#   - +TextInput+ +text_input+ -> The TextInput to use for text editing by the user
	#   - +String+ +player_name+ -> The name of the player
	#   - +Gosu::Color+ +colour+ -> The colour of the player
	#   - <tt>Hash<Symbol, Numeric></tt> +controls+ -> The player controls
	#   - +boolean+ +enabled+ -> Whether the PlayerEntry is enabled
	def initialize(window, 
				   main,
				   text_input, 
				   player_name, 
				   colour, 
				   controls, 
				   enabled=true)

		@x = @y = 0

		@window = window
		@main = main

		@enable = create_enable_player(enabled)
		@name = create_player_name(player_name, text_input)
		@colour = create_player_colour(colour)
		@controls = create_player_controls(controls)
	end

	# Returns whether the current PlayerEntry is enabled or not. An enabled 
	# PlayerEntry accepts user input and is intended to result in a Player
	# object.
	#
	# * *Returns* :
	#   - Whether the PlayerEntry is enabled or not
	# * *Return* *Type* :
	#   - boolean
	def enabled
		@enable.checked
	end

	# Sets the enabled attribute to the given value.
	#
	# * *Args*    :
	#   - +boolean+ +value+ -> The new enabled value
	def enabled=(value)
		@enable.checked = value
	end

	# Returns a Player representation of the PlayerEntry.
	#
	# * *Returns* :
	#   - The Player representation of the current PlayerEntry object
	# * *Return* *Type* :
	#   - Player
	def player
		controls_menu = @controls.controls_menu
		player = Player.new(@name.text, controls_menu.controls)
		player.colour = @colour.background_colour
		player
	end

	# Draws the PlayerEntry in the GameWindow.
	def draw
		@enable.draw
		@name.draw
		@colour.draw
		@controls.draw
	end

	# Updates the state child components of the PlayerEntry.
	def update
		@enable.update
		if @enable.checked
			@name.update
			@colour.update
			@controls.update 
		end
	end

	# The x value of the top left corner. Defaults to 0.
	attr_reader :x

	# Sets the x value of the top left corner.
	def x=(value)
		old_x = @x
		@x = value
		@enable.x = (@enable.x - old_x) + value
		@name.x = (@name.x - old_x) + value
		@colour.x = (@colour.x - old_x) + value 
		@controls.x = (@controls.x - old_x) + value 
	end
	
	# The y value of the top left corner. Defaults to 0.
	attr_reader :y

	# Sets the y value of the top left corner.
	def y=(value)
		old_y = @y
		@y = value
		@enable.y = (@enable.y - old_y) + value
		@name.y = (@name.y - old_y) + value
		@colour.y = (@colour.y - old_y) + value 
		@controls.y = (@controls.y - old_y) + value 
	end


private

	# Create a GUI component with the name of the Player.
	#
	# * *Returns* :
	#   - component with the name of the Player
	# * *Return* *Type* :
	#   - TextPane
	def create_player_name(name, text_input)
		name_pane = TextPane.new(@window,
								 text_input,
								 name, 
								 Constants::TEXT_HEIGHT, 
								 Constants::FONT_NAME)
		name_pane.x = 200 + @x
		name_pane.y = 100 + @y
		name_pane
	end

	# Create a GUI component with the colour of the Player.
	#
	# * *Returns* :
	#   - component with the colour of the Player
	# * *Return* *Type* :
	#   - 
	def create_player_colour(colour)
		colour_label = Label.new("  ", 
								 Constants::TEXT_HEIGHT, 
								 Constants::FONT_NAME)
		colour_label.background_colour = colour

		colour_label.x = 150 + @x
		colour_label.y = 100 + @y

		colour_label
	end

	# Create a GUI component with the controls of the Player.
	#
	# * *Returns* :
	#   - component with the controls of the Player
	# * *Return* *Type* :
	#   - PlayerControlsMenu
	def create_player_controls(controls)
		messages_dictionary = @window.user_messages
		controls_button = Button.new(@window, 
									   messages_dictionary.message(:controls), 
									   Constants::TEXT_HEIGHT,
									   Constants::FONT_NAME)
		controls_button.x = 400 + @x
		controls_button.y = 100 + @y

		controls_button.singleton_class.class_eval do 
			attr_accessor :controls_menu
		end
		controls_button.controls_menu = PlayerControlsMenu.new(controls)
		controls_button.add_callback(:release, 
							create_controls_button_callback(controls_button))

		controls_button
	end

	# Creates and returns the callable to be called when the controls button
	# is pressed.
	#
	# * *Args*    :
	#   - +Button+ +controls_button+ -> The button to which the callback will be added later
	# * *Returns* :
	#   - The controls button's callable
	# * *Return* *Type* :
	#   - Proc
	def create_controls_button_callback(controls_button)
		lambda do
			controls_button.controls_menu.player_name = @name.text
			@main.current_menu = controls_button.controls_menu
		end
	end

	# Create a GUI component to enable or disable the current PlayerEntry.
	#
	# * *Returns* :
	#   - component to enable or disable the current PlayerEntry
	# * *Return* *Type* :
	#   - Checkbox
	def create_enable_player(enable)
		enable_player = Checkbox.new(@window, 
							  Constants::TEXT_HEIGHT, 
							  Constants::FONT_NAME,
							  enable)
		enable_player.x = 100 + @x
		enable_player.y = 100 + @y
		enable_player
	end

end

