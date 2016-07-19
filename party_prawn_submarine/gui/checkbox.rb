
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

		@label = Label.new(CHECK_MARK, size - Label::bg_margin, font_name, z)

		@listen_key = Gosu::MsLeft
	end

	# Gets the x value of the top left corner.
	def x
		@label.x
	end

	# Sets the x value of the top left corner.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The new x value of the top left corner
	def x=(value)
		@label.x = value
	end

	# Gets the y value of the top left corner.
	def y
		@label.y
	end

	# Sets the y value of the top left corner.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The new y value of the top left corner
	def y=(value)
		@label.y = value
	end

	# Draws the Checkbox in the current GameWindow.
	def draw
		if @checked
			@label.draw
		else
			@label.draw_background
		end
	end

	# Updates the state of the Checkbox.
	def update
		if contains(@window.mouse_x, @window.mouse_y) && 
			Gosu::button_down?(@listen_key)

			@checked = !@checked
		end
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
		@label.contains(x, y)
	end

end
