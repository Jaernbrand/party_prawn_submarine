
class TextPane

	attr_writer :in_focus

	attr_accessor :font

	def self.done_keys
		@@done_keys
	end

	def self.done_keys=(value)
		@@done_keys = value
	end

end
