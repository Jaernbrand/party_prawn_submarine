

require_relative '../../constants'

require_relative '../../gui/menu'
require_relative '../../gui/button'

require_relative 'new_game_menu'

# The root menu in the MainMenu.
class RootMenu < Menu

	# Initialises a new RootMenu with the given MainMenu.
	#
	# * *Args*    :
	#   - +MainMenu+ +main+ -> The MainMenu which the current object is a submenu of
	def initialize(main)
		super(main.window)

		@main = main
		add_component(create_exit_button(100, 200))

		new_game = NewGameMenu.new(@main)
		new_game.parent = self

		add_component(create_new_game_button(new_game, 100, 100))
		
		add_component(create_version_label(50, 700))
	end


private 

	# Creates an exit button that closes the game on release. The top left
	# corner of the button is placed at the given coordinate.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x value of the button's top left corner
	#   - +Numeric+ +y+ -> The y value of the button's top left corner
	# * *Returns* :
	#   - an exit button
	# * *Return* *Type* :
	#   - Button
	def create_exit_button(x, y)
		button = Button.new(@window, 
							@window.user_messages.message(:exit), 
							Constants::BT_TEXT_HEIGHT,
							Constants::FONT_NAME)
		button.add_callback(:release, lambda {@window.close})
		button.x = x
		button.y = y
		button
	end

	# Creates an button that shows the new game menu when released. The top 
	# left corner of the button is placed at the given coordinate.
	#
	# * *Args*    :
	#   - +Menu+ +new_game+ -> the menu to show
	#   - +Numeric+ +x+ -> The x value of the button's top left corner
	#   - +Numeric+ +y+ -> The y value of the button's top left corner
	# * *Returns* :
	#   - a new game button
	# * *Return* *Type* :
	#   - Button
	def create_new_game_button(new_game, x, y)
		button = Button.new(@window, 
							@window.user_messages.message(:new_game), 
							Constants::BT_TEXT_HEIGHT,
							Constants::FONT_NAME)
		button.add_callback(:release, lambda {@main.current_menu = new_game})
		button.x = x
		button.y = y
		button
	end

	# Creates a label that shows the current version of the game.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x value of the label's top left corner
	#   - +Numeric+ +y+ -> The y value of the label's top left corner
	# * *Returns* :
	#   - label showing the version of the game
	# * *Return* *Type* :
	#   - Label
	def create_version_label(x, y)
		msg = @window.user_messages.message(:version) +
											" " +
											Constants::VERSION.to_s
		version = Label.new(msg, Constants::TEXT_HEIGHT, Constants::FONT_NAME)
		version.x = x
		version.y = y
		version
	end

end

