require 'gosu'

class GameWindow < Gosu::Window

	attr_accessor :state

	def initialize(width=1024, height=768, fullscreen=false)
		super
		self.caption = 'Party Prawn Submarine'
	end

	def button_down(id)
		@state.button_down(id)
	end

	def button_up(id)
		@state.button_up(id)
	end

	def update
		@state.update
	end

	def needs_redraw?
		@state.needs_redraw?
	end

	def draw
		@state.draw
		if @ent
			@ent.draw(100, 100, 50)
		end
	end

end
