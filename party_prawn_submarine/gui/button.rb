
require 'gosu'

require_relative 'label'

# A clickable button.
class Button

	# Creates a new Button with the given text.
	#
	# * *Args*    :
	#   - +GameWindow+ +window+ -> The window in which the button is displayed
	#   - +String+ +text+ -> The button text to be displayed
	#   - +Fixnum+ +text+ -> The height of the text
	#   - +String+ +font_name+ -> The name of the font to use for the text
	#   - +Fixnum+ +z+ -> The z layer of the button
	def initialize(window, text, text_height, font_name, z=0)
		@callbacks = {}
		@window = window
		@label = Label.new(text, text_height, font_name, z)

		@listen_key = Gosu::MsLeft
		@pressed_previously = false
	end

	# Draws the button in the current GameWindow.
	def draw
		@label.draw
	end

	# Updates the state of the Button and calls any of the given callbacks if
	# needed.
	def update
		if contains(@window.mouse_x, @window.mouse_y)
			if Gosu::button_down?(@listen_key) && !@pressed_previously
				down
			elsif Gosu::button_down?(@listen_key) && @pressed_previously
				held
			elsif !Gosu::button_down?(@listen_key) && @pressed_previously
				release
			else
				mouse_over
			end
		end
	end

	# Checks if the button contains the x and y coordinates.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x coordinate to check
	#   - +Numeric+ +y+ -> The y coordinate to check
	# * *Returns* :
	#   - Whether the button contains the coordinates
	# * *Return* *Type* :
	#   - boolean
	def contains(x, y)
		@label.contains(x, y)
	end

	# Adds a callback to the button. The callaback will be assocaiated with
	# the given action and called when the specified action is performed. The
	# callable should not take any arguments and the return value will be
	# ignored. Valid actions are:
	#   - :mouse_over -> mouse pointer hovers over the button
	#   - :down -> the button is pressed
	#   - :held -> the button is continuously pressed
	#   - :release -> the button is released
	#
	# * *Args*    :
	#   - +Symbol+ +action+ -> Symbol representing a button action
	#   - +callable+ +callable+ -> The callable to call
	def add_callback(action, callable)
		@callbacks[action] = callable
	end

	# Removes the given action-callback association. Valid symblos are:
	#   - :mouse_over -> mouse pointer hovers over the button
	#   - :down -> the button is pressed
	#   - :held -> the button is continuously pressed
	#   - :release -> the button is released
	#
	# * *Args*    :
	#   - +Symbol+ +action+ -> Symbol representing a button action
	def remove_callback(action)
		@callbacks.delete(action)
	end


private

	# Performs all actions to be done when the mouse pointer hovers over the
	# Button. 
	def mouse_over
		callbacks[:mouse_over].call
	end

	# Does everything to be done when the Button is pressed.
	def down
		callbacks[:down].call
	end

	# Does everything that is to be done when the Button is held down.
	def held
		callbacks[:held].call
	end

	# Performs all actions that needs to be taken when the Button is releasd
	# after being pressed.
	def release
		callbacks[:release].call
	end

end