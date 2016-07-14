
require 'gosu'

require_relative 'text_component'

# Pane containing text. Intended to be used for text that changes a lot. The
# text contents can be edited by the user.
class TextPane < TextComponent

	# The margin to add to the text width to create the background width.
	@@bg_margin = 2

	# The key to listen for.
	@@listen_key = Gosu::MsLeft

	# The keys that signal that the user is done editing the text in the 
	# TextPane.
	@@done_keys = [Gosu::KbEnter, Gosu::KbReturn]

	# Boolean representing whether the TextPane is in focus or not. It's only
	# possible for a user to edit the text of the TextPane if it's in focus.
	attr_reader :in_focus

	# The maximum length of the text, i.e. the maximum number of characters.
	# A value of nil means that there isn't a maximum length. The default 
	# value is nil.
	attr_accessor :max_length

	# Initialises a new TextPane with the given arguments. The new object
	# can be edited by a user.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The associated game window
	#   - +Gosu::TextInput+ +text_input+ -> Input object for text editing
	#   - +String+ +text+ -> The text of the TextPane
	#   - +Fixnum+ +text_height+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Float+ +z+ -> The z layer to draw the TextPane
	def initialize(window, text_input, text, text_height, font_name, z=0)
		super(text, text_height, font_name, z)

		@window = window
		@text_input = text_input

		@font = Gosu::Font.new(@text_height, {:name => @font_name})	
		@bg_width = @font.text_width(@text) + @@bg_margin

		@in_focus = false

		@max_length = nil
	end

	# Sets the text attribute to the given value.
	#
	# * *Args*    :
	#   - +String+ +value+ -> The new value of the text attribute
	def text=(value)
		@text = value
		@bg_width = @font.text_width(@text) + @@bg_margin
	end

	# Updates the state of the TextPane.
	def update
		if @in_focus
			if done_editing?
				unfocus
			else
				update_text
			end
		elsif Gosu::button_down?(@@listen_key) && 
			contains(@window.mouse_x, @window.mouse_y)

			focus
		end
	end

	# Checks if the TextPane contains the given point.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x coordinate to check
	#   - +Numeric+ +y+ -> The y coordinate to check
	# * *Returns* :
	#   - Whether the TextPane contains the point or not
	# * *Return* *Type* :
	#   - boolean
	def contains(x, y)
		contains_x(x) && contains_y(y)
	end

	# Sets focus to the current object. Note that this does NOT unfocus any 
	# other object. A TextPane needs to be in focus for the user to be able to
   	# edit the text contents.
	def focus
		@in_focus = true
		@window.text_input = @text_input
		@text_input.text = @text
	end

	# Removes focus from the current object and resets the GameWindow's 
	# TextInput object.
	def unfocus
		@in_focus = false
		@window.text_input = nil
	end

	# Draws the TextPane.
	def draw
		draw_background
		@font.draw(@text, 
				  @x + @@bg_margin/2, 
				  @y + @@bg_margin/2, 
				  @z, 
				  1, # scale_x
				  1, # scale_y 
				  @text_colour)
	end


private

	# Checks if the current TextPane contains the given x value.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x coordinate to check
	# * *Returns* :
	#   - Whether the TextPane contains the x value
	# * *Return* *Type* :
	#   - boolean
	def contains_x(x)
		@x <= x && x <= (@x + @bg_width)
	end
	
	# Checks if the current TextPane contains the given y value.
	#
	# * *Args*    :
	#   - +Numeric+ +y+ -> The y coordinate to check
	# * *Returns* :
	#   - Whether the TextPane contains the y value
	# * *Return* *Type* :
	#   - boolean
	def contains_y(y)
		@y <= y && y <= (@y + @bg_height)
	end

	# Returns whether the user is done editing the text.
	#
	# * *Returns* :
	#   - Whether the user is done editing
	# * *Return* *Type* :
	#   - boolean
	def done_editing?
		@@done_keys.each do |key| 
			if Gosu::button_down?(key)
				return true
			end
		end

		Gosu::button_down?(@@listen_key) && 
		!contains(@window.mouse_x, @window.mouse_y)
	end

	# Updates the text of the TextPane base on the edits done by the user.
	def update_text
		if @max_length != nil && @max_length < @text_input.text.length
			@text_input.text = @text
		else
			@text = @text_input.text
		end
	end

end
