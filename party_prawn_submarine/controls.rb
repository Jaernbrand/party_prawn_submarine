
require 'gosu'

module Controls

	def self.get_std_controls
		controls = Hash.new
		controls[:up] = Gosu::KbUp
		controls[:down] = Gosu::KbDown
		controls[:left] = Gosu::KbLeft
		controls[:right] = Gosu::KbRight
		controls[:torpedo] = Gosu::KbSpace
		controls
	end

end
