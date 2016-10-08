
require 'gosu'

require_relative 'messages/message_dictionary'
require_relative 'messages/english'

# Window containing the game state. Also initialises Gosu.
class GameWindow < Gosu::Window

	# The maximum amount of time to skip redrawing In milliseconds.
	MAX_SKIP_TIME = 2000

	# The current game state of the window
	attr_accessor :state

	# The MessageDictionary responsibled for user messages. Defaults to english
	# messages.
	attr_accessor :user_messages

	# Boolean value whether to show the mouse cursor or not.
	attr_accessor :show_cursor

	# Initialises a new window with the given parameters.
	def initialize(width=1024, 
				   height=768, 
				   fullscreen=false, 
				   user_messages = MessageDictionary.new(English.messages, 
														 English.keynames))

		super(width, height, fullscreen)
		self.caption = 'Party Prawn Submarine'

		@user_messages = user_messages

		@last_redraw = Gosu::milliseconds
		@show_cursor = false

		@last_assigned_ti = nil
	end

	# Assigns the given value to the text_input attribute. Set to nil for
	# Gosu's default handling of keyboard events 
	# ({see Gosu's documentation}[https://www.libgosu.org/rdoc/_index.html]).
	# However, the given value (including nil) will not be assigned to 
	# text_input if it previously was assigned a non-nil value. The assignment 
	# history is reset once every update tick.
	#
	# * *Args*    :
	#   - +TextInput+ +value+ -> The value to assign to text_input
	def text_input=(value)
		if @last_assigned_ti == nil
			super(value)
			@last_assigned_ti = value
		end
	end

	# Returns whether the GameWindow needs the cursor to be shown.
	#
	# * *Returns* :
	#   - if the mouse cursor needs to be shown
	# * *Return* *Type* :
	#   - boolean
	def needs_cursor?
		@show_cursor
	end

	# Tells the current game state that the button with the given id was 
	# pressed.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button that was released
	def button_down(id)
		@state.button_down(id)
	end

	# Tells the current game state that the button with the given id was 
	# released.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button that was released
	def button_up(id)
		@state.button_up(id)
	end

	# Updates the state of the window.
	def update
		@state.update
		clear_text_input_assign
	end

	# Checks if the window needs to be redrawn.
	#
	# * *Returns* :
	#   - Whether the window needs to be redrawn or not
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		@state.needs_redraw? || max_skip_time_exceeded?
	end

	# Draws the window contents.
	def draw
		@state.draw
		@last_redraw = Gosu::milliseconds
	end


private

	# Clears the attribute holding the last value to be assigned to #text_input.
	def clear_text_input_assign
		@last_assigned_ti = nil if @last_assigned_ti != nil
	end

	# Checks if the maximum time to skip drawing has been exeeded. 
	#
	# * *Returns* :
	#   - Whether the maximum time without redrawing has been exeeded or not
	# * *Return* *Type* :
	#   - boolean
	def max_skip_time_exceeded?
		(Gosu::milliseconds - @last_redraw).abs > MAX_SKIP_TIME
	end

end
