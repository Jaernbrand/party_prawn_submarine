require 'gosu'

class GameWindow < Gosu::Window

	attr_accessor :state

	def initialize(width=1024, height=768, fullscreen=false)
		super
		self.caption = 'Party Prawn Submarine'
	end

	def update
		@state.update
	end

	def needs_redraw?
		@state.needs_redraw?
	end

	def draw
		@state.draw
	end

end
