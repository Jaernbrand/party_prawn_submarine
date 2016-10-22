
require 'gosu'

require_relative 'label'

# A clickable checkbox.
class Checkbox

	# The check mark to show when the Checkbox is checked.
	CHECK_MARK = "\u2713"

	# Boolean indicating whether the Checkbox is checked.
	attr_accessor :checked

	# Creates a new Checkbox.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The window in which the Checkbox is displayed
	#   - +Numeric+ +size+ -> The size of the Checkbox
	#   - +String+ +font_name+ -> The name of the font to use for the checkmark
	#   - +boolean+ +checked+ -> Whether the Checkbox is checked
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Fixnum+ +z+ -> The z layer of the button
	def initialize(window, size, font_name, checked=false, z=0)
		@window = window
		@checked = checked

		@button = Button.new(window, CHECK_MARK, size, font_name, z)
		@button.add_callback(:release, Proc.new {@checked = !@checked})
	end

	# Gets the x value of the top left corner.
	def x
		@button.x
	end

	# Sets the x value of the top left corner.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The new x value of the top left corner
	def x=(value)
		@button.x = value
	end

	# Gets the y value of the top left corner.
	def y
		@button.y
	end

	# Sets the y value of the top left corner.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The new y value of the top left corner
	def y=(value)
		@button.y = value
	end

	# Draws the Checkbox in the current GameWindow.
	def draw
		if @checked
			@button.draw
		else
			@button.draw_background
		end
	end

	# Updates the state of the Checkbox.
	def update
		@button.update
	end

	# Checks if the Checkbox contains the x and y coordinates.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x coordinate to check
	#   - +Numeric+ +y+ -> The y coordinate to check
	# * *Returns* :
	#   - Whether the Checkbox contains the coordinates
	# * *Return* *Type* :
	#   - boolean
	def contains(x, y)
		@button.contains(x, y)
	end

end
