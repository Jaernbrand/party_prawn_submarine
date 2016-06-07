
require_relative '../constants'

# The state in which the game is played. Contains the entities needed to play 
# the game as well as scene information such as board bounds.
class PlayState

	BACKGROUND_IMAGE_PATH = Constants::IMAGE_PATH + "water.png"

	BACKGROUND_Z = 0

	# Handles button events in the PlayState.
	attr_accessor :controller

	attr_accessor :width, :height

	# Initialises a new PlayState.
	def initialize(entities = [])
		@all_entities = entities
		@rm_marked = []
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
		@all_entities.each do |entity|
			entity.update
		end
		remove_marked
	end

	# Removes all entities that are marked for death.
	def remove_marked
		i = @rm_marked.length-1
		while i >= 0 
			curr_marked = @rm_marked.delete_at(i)
			remove_entity(curr_marked)
			i -= 1
		end
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

private

	def outside_x_bounds?(x, w)
		x + w < 0 || x > @width
	end

	def outside_y_bounds?(y, h)
		y + h < 0 || y > @height
	end

end
