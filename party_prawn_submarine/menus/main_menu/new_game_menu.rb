
require_relative '../../constants'

require_relative '../../gui/menu'
require_relative '../../gui/button'
require_relative '../../gui/text_pane'

# Menu that allows the user to create a new game.
class NewGameMenu < Menu

	# Initialises a new NewGameMenu with the given MainMenu.
	#
	# * *Args*    :
	#   - +MainMenu+ +main+ -> The MainMenu which the current object is a submenu of
	def initialize(main)
		super(main.window)

		@main = main

		add_component(create_back_button(100, 650)) # TODO Change coordinates
		add_component(create_start_button(900, 650)) # TODO Change coordinates

		create_player_options
	end


private 

	# Creates the user interface that allows the user to choose the pre-game 
	# options.
	def create_player_options
		names = std_player_names
		for i in 0...Constants::MAX_PLAYERS
			name_pane = TextPane.new(names[i], 
									 Constants::TEXT_HEIGHT, 
									 Constants::FONT_NAME)
			name_pane.x = 100
			name_pane.y = 100 * (i+1)
			add_component(name_pane)
		end
	end

	# Returns an array of the standrad names of the players.
	#
	# * *Returns* :
	#   - the names of the players
	# * *Return* *Type* :
	#   - Array<String>
	def std_player_names
		names = []
		for i in 1..Constants::MAX_PLAYERS
			names << "Player" + i.to_s
		end
		names
	end

	# Creates an exit button that closes the game on release. The top left
	# corner of the button is placed at the given coordinate.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x value of the top left corner
	#   - +Numeric+ +y+ -> The y value of the top left corner
	# * *Returns* :
	#   - an exit button
	# * *Return* *Type* :
	#   - Button
	def create_back_button(x, y)
		button = Button.new(@window, 
							@window.user_messages.message(:back), 
							Constants::BT_TEXT_HEIGHT,
							Constants::FONT_NAME)
		button.add_callback(:release, lambda {@main.current_menu = @parent})
		button.x = x
		button.y = y
		button
	end

	# Creates an button that starts a new game when released. The top left 
	# corner of the button is placed at the given coordinate.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x value of the top left corner
	#   - +Numeric+ +y+ -> The y value of the top left corner
	# * *Returns* :
	#   - a new game button
	# * *Return* *Type* :
	#   - Button
	def create_start_button(x, y)
		button = Button.new(@window, 
							@window.user_messages.message(:start), 
							Constants::BT_TEXT_HEIGHT,
							Constants::FONT_NAME)
		button.add_callback(:release, lambda {@parent.current_menu = new_game})
		button.x = x
		button.y = y
		button
	end

end

