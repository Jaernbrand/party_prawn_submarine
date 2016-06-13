
class Player

	attr_accessor :name, :colour, :submarine, :party_horn

	attr_accessor :controls

	def initialize(controls={})
		@controls = controls
	end

	def ==(other)
		if other.instance_of?(Player)
			return other.name == @name
		end
		false
	end

	def bind_button(action, button)
		@controls[action] = button
	end

	def get_button(action)
		@controls[action]
	end

end
