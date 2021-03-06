
require_relative '../constants'
require_relative '../gui/text_pane'

require_relative 'base_state'

# The state in which the game is played. Contains the entities needed to play 
# the game as well as scene information such as board bounds.
class PlayState < BaseState

	# The path to the PlayState's background image.
	BACKGROUND_IMAGE_PATH = Constants::IMAGE_PATH + "water.png"

	# The z layer of messages shown to the user.
	MSG_Z = 1000

	# The text height of messages shown to the user. The height is measured 
	# in pixels.
	MSG_HEIGHT = 50

	# The judge that decides the winner
	attr_accessor :judge

	# Initialises a new PlayState. The given callble have to implement the 
	# method +call+ with arity 0. The game_over_callable will be called when 
	# it's game over and the correct key is pressed.
	#
	# * *Args*    :
	#   - +callable+ +game_over_callable+ -> The callable to be called when the game is over
	#   - <tt>Array<BaseEntity></tt> +entities+ -> The starting entities of the PlayState 
	def initialize(game_over_callable, entities = [])
		@all_entities = entities
		@rm_marked = []
		@has_removed = false

		@game_over_return_key = Gosu::KbSpace
		@game_over_callable = game_over_callable
		@game_over_is_ready = false

		@game_over_prompt = nil

		@win_msg = nil
		@judge = nil
	end

	# Preloads the assets needed by the PlayState.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		@@img = Gosu::Image.new(window, BACKGROUND_IMAGE_PATH, false)
	end

	# Updates the PlayState and all entities it contains.
	def update
		super
		@all_entities.each do |entity|
			entity.update
		end
		detect_collisions
		remove_marked

		if @judge.game_over? && !@game_over_is_ready
			game_over_init
			@game_over_is_ready = true
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
		draw_background(@@img)
		@all_entities.each do |entity|
			entity.draw
		end

		if @judge.game_over?
			show_winner(@judge.winner)
			@game_over_prompt.draw
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
				@judge.died(curr_marked.player)
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
		win_label = Label.new(msg, MSG_HEIGHT, Constants::FONT_NAME, MSG_Z)
		win_label.x = @width/2 - win_label.bg_width/2
		win_label.y = @height/2 - win_label.bg_height/2

		win_label
	end

	# Initialises the game over state.
	def game_over_init
		@controller.add_button_down_callback(@game_over_return_key, 
											 @game_over_callable)
		@game_over_prompt = create_game_over_prompt
	end

	# Creates a messge with a prompt for the user.
	#
	# * *Returns* :
	#   - The prompt as a TextPane
	# * *Return* *Type* :
	#   - TextPane
	def create_game_over_prompt
		keyname = @window.user_messages.keyname(@game_over_return_key)
		msg = @window.user_messages.message(:game_over_prompt, keyname)

		prompt_label = Label.new(msg, MSG_HEIGHT, Constants::FONT_NAME, MSG_Z)
		prompt_label.x = @width/2 - prompt_label.bg_width/2
		prompt_label.y = @height/2 - prompt_label.bg_height/2 + MSG_HEIGHT

		prompt_label
	end

end
