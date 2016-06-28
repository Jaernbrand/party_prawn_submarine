
require 'gosu'

require_relative 'messages/message_dictionary'
require_relative 'messages/english'

class GameWindow < Gosu::Window

	attr_accessor :state

	# The MessageDictionary responsibled for user messages. Defaults to english
	# messages.
	attr_accessor :user_messages

	def initialize(width=1024, height=768, fullscreen=false)
		super(width, height, fullscreen)
		self.caption = 'Party Prawn Submarine'

		@user_messages = MessageDictionary.new(English.messages)
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
	end

end
