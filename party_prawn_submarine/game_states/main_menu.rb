
require_relative '../constants'

require_relative '../gui/menu'
require_relative '../gui/button'

# The main menu of the game.
class MainMenu

	# The text height of the MainMenu's buttons.
	BT_TEXT_HEIGHT = 20

	# The width of the MainMenu
	attr_accessor :width
	
	# The height of the MainMenu
	attr_accessor :height

	# The GameWindow that the current MainMenu is associated with
	attr_accessor :window

	# Handles button events in the MainMenu.
	attr_accessor :controller

	# Initialises a new MainMenu associated to the given GameWindow.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The window which the MainMenu is associated with
	def initialize(window)
		@window = window
		@window.show_cursor = true

		@current_menu = create_root_menu
		@controller = nil
	end

	# Tells the #controller that the button with the given id was pressed.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button being pressed
	def button_down(id)
		@controller.button_down(id) if @controller
	end

	# Tells the #controller that the button with the given id was released.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button that was released
	def button_up(id)
		@controller.button_up(id) if @controller
	end

	def needs_redraw?
		true # TODO
	end

	# Draws the MainMenu in teh current GameWindow.
	def draw
		@current_menu.draw
	end

	# Updates the state of the MainMenu.
	def update
		@current_menu.update
	end


private 

	# Creates the root menu of the MainMenu.
	#
	# * *Returns* :
	#   - The root menu
	# * *Return* *Type* :
	#   - Menu
	def create_root_menu
		root = Menu.new(@window, 0, 0)
		root.add_component(create_exit_button(100, 200))

		new_game = Menu.new(@window, 0, 0)
		new_game.parent = root

		root.add_component(create_new_game_button(new_game, 100, 100))
		root
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
	def create_exit_button(x, y)
		button = Button.new(@window, 
							@window.user_messages.message(:exit), 
							BT_TEXT_HEIGHT,
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
	#   - +Numeric+ +x+ -> The x value of the top left corner
	#   - +Numeric+ +y+ -> The y value of the top left corner
	# * *Returns* :
	#   - a new game button
	# * *Return* *Type* :
	#   - Button
	def create_new_game_button(new_game, x, y)
		button = Button.new(@window, 
							@window.user_messages.message(:new_game), 
							BT_TEXT_HEIGHT,
							Constants::FONT_NAME)
		button.add_callback(:release, Proc.new {@current_menu = new_game})
		button.x = x
		button.y = y
		button
	end

end

