
require_relative '../constants'

require_relative '../menus/main_menu/root_menu'
require_relative '../gui/button'

require_relative 'base_state'

# The main menu of the game. Presents an interface for the user to create and 
# start new games.
class MainMenu < BaseState

	# The text height of the MainMenu's buttons.
	BT_TEXT_HEIGHT = 20

	# The currently shown submenu in the main menu.
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

	# Return whether the MainMenu needs to be redrawn in the GameWindow.
	#
	# * *Returns* :
	#   - +true+ if the MainMenu needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		true # TODO
	end

	# Draws the MainMenu in teh current GameWindow.
	def draw
		@current_menu.draw
	end

	# Updates the state of the MainMenu.
	def update
		super
		@current_menu.update
	end

end

