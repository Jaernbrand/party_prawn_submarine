
require 'test/unit'
require 'minitest/mock'

require 'control_mapper'

class ControlMapperTester < Test::Unit::TestCase

	def setup
		@control_mapper = ControlMapper.new
	end

	def test_std_controls
		actions = [:up, :down, :left, :right, :torpedo, :blow_party_horn]
		ctrls = @control_mapper.send(:std_controls)

		ctrls.each do |map|
			actions.each do |action|
				assert(map.has_key?(action), 
					   "No key for '" << action.to_s << "'.")
				assert_not_nil(map[action], 
					   "No value for '" << action.to_s << "'.")
			end
		end
	end

	def test_controls_only_initialized_with_std_controls
		actions = [:up, :down, :left, :right, :torpedo, :blow_party_horn]
		ctrls = @control_mapper.controls

		ctrls.each do |map|
			actions.each do |action|
				assert(map.has_key?(action), 
					   "No key for '" << action.to_s << "'.")
				assert_not_nil(map[action], 
					   "No value for '" << action.to_s << "'.")
			end
		end
	end

end

