
require 'test/unit'
require 'minitest/mock'

require 'menus/main_menu/root_menu'

class RootMenuTester < Test::Unit::TestCase

	def setup
		@fake_window = MiniTest::Mock.new
		@root = RootMenu.new(@fake_window)
	end

	def test
		assert false, "Not implemented"
	end

end

