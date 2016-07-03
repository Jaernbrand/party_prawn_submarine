
require 'gosu'

require_relative 'label'

# A clickable button.
class Button

	# Creates a new Button with the given text.
	#
	# * *Args*    :
	#   - +String+ +text+ -> The button text to be displayed
	#   - +Fixnum+ +text+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Fixnum+ +z+ -> The z layer of the button
	def initialize(text, text_height, font_name, z=0)
		@label = Label.new(text, text_height, font_name, z)
	end

	# Checks if the button contains the x and y coordinates.
	#
	#   - +Numeric+ +x+ -> The x coordinate to check
	#   - +Numeric+ +y+ -> The y coordinate to check
	# * *Returns* :
	#   - Whether the button contains the coordinates
	# * *Return* *Type* :
	#   - boolean
	def contains(x, y)
		@label.contains(x, y)
	end

end
