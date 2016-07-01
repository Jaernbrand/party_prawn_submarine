
require 'gosu'

# Mocks Gosu to enable testing without initializing Gosu. Intended to be used
# as a mixin.
module GosuMocker

	def mock_gosu
		@old_gosu = Gosu
		Object.send(:remove_const, :Gosu)
		Object.const_set(:Gosu, MiniTest::Mock.new)
	end

	def restore_gosu
		Object.send(:remove_const, :Gosu)
		Object.const_set(:Gosu, @old_gosu)
	end

end
