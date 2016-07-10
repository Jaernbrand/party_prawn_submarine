
require 'gosu'

# Base class for GUI components containing text.
class TextComponent

	# The text contained in the TextComponent.
	attr_accessor :text

	# The height of the text.
	attr_reader :text_height

	# The name of the font to use for the text.
	attr_reader :font_name


	# The colour of the text. Default is white.
	attr_accessor :text_colour

	# The colour of the background. Default is black.
	attr_accessor :background_colour


	# The x coordinate of the TextComponent. Default is 0.
	attr_accessor :x

	# The y coordinate of the TextComponent. Default is 0.
	attr_accessor :y

	# The z layer of the TextComponent. Default is 0.
	attr_accessor :z


	# The width of the TextComponent's background. Subclasses are responsible 
	# for setting this attribute.
	attr_reader :bg_width

	# The height of the TextComponent's background
	attr_reader :bg_height

	# Creates a new TextComponent with the given text.
	#
	# * *Args*    :
	#   - +String+ +text+ -> The text to be displayed
	#   - +Fixnum+ +text+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Fixnum+ +z+ -> The z layer of the TextComponent
	def initialize(text, text_height, font_name, z=0)
		@text = text
		@text_height = text_height
		@font_name = font_name

		@z = z

		@x = 0
		@y = 0

		@text_colour = Gosu::Color::WHITE
		@background_colour = Gosu::Color::BLACK

		@bg_height = text_height + 2
	end

	# Update the state of the TextComponent.
	def update
		# Left empty intentionally.
	end

protected

	# Draws the background of the TextComponent, i.e. a rectangle in the colour
	# of #background_colour.
	def draw_background
		Gosu::draw_rect(@x,
						@y, 
						@bg_width,
						@bg_height, 
						@background_colour,
						@z)
	end

end

