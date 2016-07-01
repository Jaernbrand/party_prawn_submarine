
require 'gosu'

require_relative 'text_component'

# Pane containing text. Intended to be used for text that changes a lot.
class TextPane < TextComponent

	# Initialises a new TextPane with the given arguments.
	#
	# * *Args*    :
	#   - +String+ +text+ -> The text of the TextPane
	#   - +Fixnum+ +text_height+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Float+ +z+ -> The z layer to draw the TextPane
	def initialize(text, text_height, font_name, z=0)
		super(text, text_height, font_name, z)

		@font = Gosu::Font.new(@text_height, {:name => @font_name})	
		@bg_width = @font.text_width(text) + 2
	end

	# Draws the TextPane.
	def draw
		draw_background
		@font.draw(@text, 
				  @x + 1, 
				  @y + 1, 
				  @z, 
				  1, # scale_x
				  1, # scale_y 
				  @text_colour)
	end

end
