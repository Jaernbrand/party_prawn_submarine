
require 'gosu'

require_relative 'text_component'

# Label containing static text.
class Label < TextComponent

	# Creates a new Label with the given text.
	#
	# * *Args*    :
	#   - +String+ +text+ -> The text to be displayed
	#   - +Fixnum+ +text+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Fixnum+ +z+ -> The z layer of the label
	def initialize(text, text_height, font_name, z=0)
		super(text, text_height, font_name, z)
		@img = create_text_content(text, text_height, font_name)
		@bg_width = @img.width + 2
	end

	# Draws the Label to the current GameWindow.
	def draw
		draw_background
		@img.draw(@x+1, 
				  @y+1, 
				  @z, 
				  1, # Default scale_x 
				  1, # Default scale_y 
				  @text_colour)
	end

	# Checks if the label contains the given coordinates.
	#
	#   - +Numeric+ +x+ -> The x coordinate to check
	#   - +Numeric+ +y+ -> The y coordinate to check
	# * *Returns* :
	#   - Whether the label contains the coordinates
	# * *Return* *Type* :
	#   - boolean
	def contains(x, y)
		contains_x(x) && contains_y(y)
	end


private

	# Checks if the label contains the given x coordinate.
	#
	#   - +Numeric+ +x+ -> The x coordinate to check
	# * *Returns* :
	#   - Whether the label contains the x coordinate
	# * *Return* *Type* :
	#   - boolean
	def contains_x(x)
		@x <= x && x <= (@x + @bg_width)
	end

	# Checks if the label contains the given y coordinate.
	#
	#   - +Numeric+ +y+ -> The y coordinate to check
	# * *Returns* :
	#   - Whether the label contains the y coordinate
	# * *Return* *Type* :
	#   - boolean
	def contains_y(y)
		@y <= y && y <= (@y + @bg_height)
	end

	# Creates an Image with the supplied text.
	#
	# * *Args*    :
	#   - +String+ +text+ -> The text to be displayed
	#   - +Fixnum+ +text+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	# * *Returns* :
	#   -  Image containing the given text
	# * *Return* *Type* :
	#   - Gosu::Image
	def create_text_content(text, text_height, font_name)
		Gosu::Image::from_text(text, text_height, {:font => font_name})
	end

end
