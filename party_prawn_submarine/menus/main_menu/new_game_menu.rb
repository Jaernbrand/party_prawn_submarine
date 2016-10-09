
require_relative '../../constants'

require_relative '../../gui/menu'
require_relative '../../gui/button'
require_relative '../../gui/text_pane'

require_relative 'player_entry'

# Menu that allows the user to create a new game.
class NewGameMenu < Menu

	# Initialises a new NewGameMenu with the given MainMenu.
	#
	# * *Args*    :
	#   - +MainMenu+ +main+ -> The MainMenu which the current object is a submenu of
	#   - +Gosu::TextInput+ +text_input+ -> The TextInput object to use for text editing by the user
	def initialize(main, text_input=Gosu::TextInput.new)
		super(main.window)

		@main = main
		@text_input = text_input

		@entries = []

		add_component(create_back_button(100, 650)) 
		add_component(create_start_button(900, 650))

		create_player_options
	end


private 

	# Creates the user interface that allows the user to choose the pre-game 
	# options. The interface components are added to the menu's component 
	# array.
	def create_player_options
		names = std_player_names
		colours = std_player_colours
		controls = ControlMapper.new.controls()

		for i in 0...Constants::MAX_PLAYERS
			entry = PlayerEntry.new(@window,
									@main,
									@text_input,
									names[i], 
									colours[i],
									controls[i],
								   	self)
									 
			entry.x = 100
			entry.y = 100 * (i+1)
			add_component(entry)
			@entries << entry
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

	# Returns an array of the standrad player colours.
	#
	# * *Returns* :
	#   - The standard player colours
	# * *Return* *Type* :
	#   - Array<Gosu::Colour>
	def std_player_colours
		[Gosu::Color::RED,
		Gosu::Color::YELLOW,
		Gosu::Color::GREEN,
		Gosu::Color::FUCHSIA]
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

		button.add_callback(:release, lambda do
			players = entries_to_players
			factory = GameFactory.new(GameControllerFactory.new)
			game_over = create_game_over_callable
			@window.state = factory.create_game(@window, game_over, *players)
		end)

		button.x = x
		button.y = y
		button
	end

	# Returns the player entries as Player objects.
	#
	# * *Returns* :
	#   - Player objects corresponding to the PlayerEntry objects
	# * *Return* *Type* :
	#   - Array<Player>
	def entries_to_players
		players = []
		@entries.each do |entry|
			if entry.enabled
				players << entry.player
			end
		end
		players
	end

	# Creates a callable to be called when the game is over.
	#
	# * *Returns* :
	#   - callable to be called when the game is over
	# * *Return* *Type* :
	#   - callable
	def create_game_over_callable
		lambda do
			@window.state = @main
		end
	end

end

