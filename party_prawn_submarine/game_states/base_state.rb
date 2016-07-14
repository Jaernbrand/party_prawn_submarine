
require_relative '../constants'

# Base class for game states that contains all common logic.
class BaseState

	# The z layer of the background. Used by the #draw method.
	BACKGROUND_Z = 0

	# Handles button events in the BaseState.
	attr_accessor :controller

	# The width of the BaseState in pixels.
	attr_accessor :width
	
	# The height of the BaseState in pixels.
	attr_accessor :height

	# The GameWindow that the current BaseState is associated with.
	attr_accessor :window

	# Tells the #controller that the button with the given id was pressed.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button being pressed
	def button_down(id)
		@controller.button_down(id) if @controller
	end

	# Tells the #controller that the button with the given id was released.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button that was released
	def button_up(id)
		@controller.button_up(id) if @controller
	end

	# Updates the state of the BaseState. Any subclass that overrides this 
	# method should call BaseState#update from the overridden subclasse's 
	# #update method. Some Controller functionallity might be lost otherwise..
	def update
		@controller.buttons_pressed_down if @controller
	end

protected

	# Draws the background of the BaseState. The background image will be drawn
	# multiple times side by side if the image is smaller than the BaseState.
	def draw_background
		x = y = 0
		begin
			@@img.draw(x, y, BACKGROUND_Z)

			x += @@img.width
			if x > @width
				x = 0
				y += @@img.height
			end
		end until y > @height
	end

end
