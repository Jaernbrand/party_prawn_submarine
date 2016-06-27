
require_relative '../constants'
require_relative '../gui/text_pane'

# The state in which the game is played. Contains the entities needed to play 
# the game as well as scene information such as board bounds.
class PlayState

	BACKGROUND_IMAGE_PATH = Constants::IMAGE_PATH + "water.png"

	# The z layer of teh background. Used by the #draw method.
	BACKGROUND_Z = 0
	
	# The z layer of messages shown to the user.
	MSG_Z = 1000

	# The text height of messages shown to the user. The height is measured 
	# in pixels.
	MSG_HEIGHT = 50

	# Handles button events in the PlayState.
	attr_accessor :controller

	# The width of the PlayState
	attr_accessor :width
	
	# The height of the PlayState
	attr_accessor :height

	# The judge that decides the winner
	attr_accessor :judge

	# The GameWindow that the current PlayState is associated with
	attr_accessor :window

	# Initialises a new PlayState.
	def initialize(entities = [])
		@all_entities = entities
		@rm_marked = []
		@has_removed = false

		@win_msg = nil
	end

	# Preloads the assets needed by the PlayState.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		@@img = Gosu::Image.new(window, BACKGROUND_IMAGE_PATH, false)
	end

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

	# Updates the PlayState and all entities it contains.
	def update
		@controller.buttons_pressed_down
		@all_entities.each do |entity|
			entity.update
		end
		detect_collisions
		remove_marked
	end

	# Markes the given entity to be removed from the PlayState.
	#
	# * *Args*    :
	#   - +object+ +entity+ -> The entity to mark for removal
	def death_mark(entity)
		@rm_marked.push(entity)
	end

	# Return whether the PlayState needs to be redrawn in the GameWindow.
	#
	# * *Returns* :
	#   - +true+ if the PlayState needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		if @has_removed
			@has_removed = false
			return true
		end
		@all_entities.each do |entity|
			if entity.needs_redraw?
				return true
			end
		end
		false
	end

	# Draws the background of the PlayState and all of the PlayState's
	# entities.
	def draw
		draw_background
		@all_entities.each do |entity|
			entity.draw
		end

		if judge.game_over?
			show_winner(judge.winner)
		end
	end

	# Adds the given entity to the PlayState and sets the +game_state+ 
	# attribute of the entity to the PlayState instance.
	#
	# * *Args*    :
	#   - +object+ +entity+ -> The entity to add
	def add_entity(entity)
		entity.game_state = self
		@all_entities.push(entity)
		nil
	end

	# Removes the given entity from the PlayState.
	#
	# * *Args*    :
	#   - +object+ +entity+ -> The entity to remove.
	# * *Returns* :
	#   - The removed entity or nil
	def remove_entity(entity)
		idx = nil
		@all_entities.each_index do |i|
			if @all_entities[i].equal?(entity)
				idx = i
				break
			end
		end
		if idx
			@all_entities.delete_at(idx)
		else
			nil
		end
	end

	# Checks if the point or rectangle corresponding to the supplied parameters
	# are outside the bounds of the PlayState.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x value to check
	#   - +Numeric+ +y+ -> The y value to check
	#   - +Numeric+ +w+ -> Default is 0.
	#   - +Numeric+ +h+ -> Default is 0.
	# * *Returns* :
	#   - +true+ if the parameters are outside the PlayState's bounds
	# * *Return* *Type* :
	#   - boolean
	def outside_bounds?(x, y, w = 0, h = 0)
		outside_x_bounds?(x, w) || outside_y_bounds?(y, h)
	end


protected

	# Detects collisions between the entities and resolves any found collisions.
	def detect_collisions
		@all_entities.each do |entity|
			@all_entities.each do |other|
				if entity.overlaps?(other)
					entity.collision(other)
				end
			end
		end	
	end

	# Removes all entities that are marked for death.
	def remove_marked
		i = @rm_marked.length-1
		@has_removed = true if i >= 0
		while i >= 0 
			curr_marked = @rm_marked.delete_at(i)
			remove_entity(curr_marked)

			if (curr_marked.is_a? Submarine)
				judge.died(curr_marked.player)
			end

			i -= 1
		end
	end


private

	# Checks if the x coordinates are outside the bounds of the PlayState.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x value to check
	#   - +Numeric+ +w+ -> The width of the accompanying the x value
	# * *Returns* :
	#   - +true+ if the parameters are outside the PlayState's bounds
	# * *Return* *Type* :
	#   - boolean
	def outside_x_bounds?(x, w)
		x + w < 0 || x > @width
	end

	# Checks if the y coordinates are outside the bounds of the PlayState.
	#
	# * *Args*    :
	#   - +Numeric+ +y+ -> The y value to check
	#   - +Numeric+ +h+ -> The height of the accompanying the y value
	# * *Returns* :
	#   - +true+ if the parameters are outside the PlayState's bounds
	# * *Return* *Type* :
	#   - boolean
	def outside_y_bounds?(y, h)
		y + h < 0 || y > @height
	end

	# Draws the background of the PlayState.
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

	# Draws the name of the winner on screen.
	#
	# * *Args*    :
	#   - +Player+ +winner+ -> The winning player
	def show_winner(winner)
		if !@win_msg
			@win_msg = create_win_message(winner)
		end

		@win_msg.draw
	end

	# Creates the message that presents the winner.
	#
	# * *Args*    :
	#   - +Player+ +winner+ -> The winning player
	# * *Returns* :
	#   - The win message as a TextPane
	# * *Return* *Type* :
	#   - TextPane
	def create_win_message(winner)
		if winner
			msg = @window.user_messages.message(:winner, winner.name)
		else
			msg = @window.user_messages.message(:no_winner)
		end
		text_pane = TextPane.new(msg, MSG_HEIGHT, Constants::FONT_NAME, MSG_Z)
		text_pane.x = @width/2 - text_pane.bg_width/2
		text_pane.y = @height/2 - text_pane.bg_height/2

		text_pane
	end

end
