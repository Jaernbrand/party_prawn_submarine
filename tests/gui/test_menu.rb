
require 'test/unit'
require 'minitest/mock'

require 'gui/menu'

require_relative 'menu_extension.rb'

class MenuTester < Test::Unit::TestCase

	def setup
		@fake_window = MiniTest::Mock.new
		@menu = Menu.new(@fake_window)
	end

	def test_draw
		comp = MiniTest::Mock.new
		comp.expect(:draw, nil, [])
		@menu.add_component(comp)

		@menu.draw

		comp.verify
	end

	def test_update
		comp = MiniTest::Mock.new
		comp.expect(:update, nil, [])
		@menu.add_component(comp)

		@menu.update

		comp.verify
	end

	def test_add_component_single_component
		oracle = 1
		comp = MiniTest::Mock.new
		@menu.add_component(comp)
		assert_equal(oracle, @menu.components.length)
	end

	def test_add_component_multiple_components
		loops = 3
		oracle = loops

		for i in 0...loops
			@menu.add_component(MiniTest::Mock.new)
		end

		assert_equal(oracle, @menu.components.length)
	end

	def test_remove_sinlge_component
		oracle = 0
		comp = MiniTest::Mock.new
		@menu.add_component(comp)

		@menu.remove_component(comp)

		assert_equal(oracle, @menu.components.length)
	end

	def test_remove_multiple_components
		oracle = 2

		component_num = 3
		comps = []
		for i in 0...component_num
			comps << i.to_s
		end
		comps.each do |comp|
			@menu.add_component(comp)
		end

		idx = comps.length/2
		@menu.remove_component(comps[idx])

		assert_equal(oracle, @menu.components.length)
	end

end

