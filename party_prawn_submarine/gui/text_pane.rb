
require 'gosu'

# Pane containing text.
class TextPane

	# The colour of the text. Default is white.
	attr_accessor :text_colour

	# The colour of the background. Default is black.
	attr_accessor :background_colour

	# The x coordinate of the TextPane. Default is 0.
	attr_accessor :x

	# The y coordinate of the TextPane. Default is 0.
	attr_accessor :y

	# The z layer of the TextPane.
	attr_accessor :z


	# Initialises a new TextPane with the given arguments.
	#
	# * *Args*    :
	#   - +String+ +text+ -> The text of the TextPane
	#   - +Fixnum+ +text_height+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Float+ +z+ -> The z layer to draw the TextPane
	def initialize(text, text_height, font_name, z)
		@text = text
		@z = z

		@x = 0
		@y = 0

		@font = Gosu::Font.new(text_height, {:name => font_name})

		@text_colour = Gosu::Color::WHITE
		@background_colour = Gosu::Color::BLACK

		@bg_width = @font.text_width(text) + 2
		@bg_height = text_height + 2
	end

	# Draws the TextPane.
	def draw
		@font.draw(@text, 
				  @x + 1, 
				  @y + 1, 
				  @z + 1, 
				  1, # scale_x
				  1, # scale_y 
				  @text_colour)

		Gosu::draw_rect(@x,
						@y, 
						@bg_width, 
						@bg_height, 
						@background_colour,
						@z)
	end

end
