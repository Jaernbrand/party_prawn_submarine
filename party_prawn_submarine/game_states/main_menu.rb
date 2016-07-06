
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

	# Initialises a new MainMenu associated to the given GameWindow.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The window which the MainMenu is associated with
	def initialize(window)
		@window = window
		@current_menu = create_root_menu
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
		root.add_component(create_exit_button)
		root
	end

	# Creates an exit button that closes the game on release.
	#
	# * *Returns* :
	#   - an exit button
	# * *Return* *Type* :
	#   - Button
	def create_exit_button
		button = Button.new(@window, 
							@window.user_messages.message(:exit), 
							BT_TEXT_HEIGHT,
							Constants::FONT_NAME)
		button.add_callback(:release, lambda {@window.close})
		button
	end

end
