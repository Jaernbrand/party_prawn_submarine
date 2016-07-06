
require 'gosu'

# Menu for user interaction.
class Menu

	# The parent Menu of the current Menu instance.
	attr_accessor :parent

	# The GameWindow which the Menu is associated with.
	attr_accessor :window

	# Creates a new Menu associated with the given GameWindow and with the
	# top left corner at the given coordinate.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The associated window
	#   - +Numeric+ +x+ -> The x value of the top left corner
	#   - +Numeric+ +y+ -> The y value of the top right corner
	def initialize(window, x, y)
		@x = x
		@y = y

		@window = window

		@components = []
	end

	# Removes the given component to the Menu.
	#
	# * *Args*    :
	#   - +object+ +component+ -> The component to add
	def add_component(component)
		@components << component
	end

	# Removes the given component from the Menu.
	#
	# * *Args*    :
	#   - +object+ +component+ -> The component to remove
	def remove_component(component)
		@components.delete(component)
	end

	# Draws the Menu in the current GameWindow,
	def draw
		@components.each do |comp|
			comp.draw
		end
	end

	# Updates the state of the Menu.
	def update
		@components.each do |comp|
			comp.update
		end
	end

end

