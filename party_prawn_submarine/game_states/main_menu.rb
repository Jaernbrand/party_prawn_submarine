
require_relative '../constants'

require_relative '../menus/main_menu/root_menu'
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

	# The currently shown submenu in the main menu
	attr_accessor :current_menu

	# Initialises a new MainMenu associated to the given GameWindow.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The window which the MainMenu is associated with
	def initialize(window)
		@window = window
		@window.show_cursor = true

		@current_menu = RootMenu.new(self)

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

end

