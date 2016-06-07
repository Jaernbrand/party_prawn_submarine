
require 'test/unit'
require 'minitest/mock'

require 'controller'

class ControllerTester < Test::Unit::TestCase

	def test_add_button_down
		bt_down = MiniTest::Mock.new
		controller = Controller.new(bt_down, MiniTest::Mock.new)

		id = 40
		fake_value = MiniTest::Mock.new

		bt_down.expect(:[]=, id, [id, fake_value])
		controller.add_button_down_callback(id, fake_value)

		bt_down.verify
	end

	def test_remove_button_down
		bt_down = MiniTest::Mock.new
		controller = Controller.new(bt_down, MiniTest::Mock.new)

		id = 40

		bt_down.expect(:delete, id, [id])
		controller.remove_button_down_callback(id)

		bt_down.verify
	end


	def test_add_button_up
		bt_up = MiniTest::Mock.new
		controller = Controller.new(MiniTest::Mock.new, bt_up)

		id = 40
		fake_value = MiniTest::Mock.new

		bt_up.expect(:[]=, id, [id, fake_value])
		controller.add_button_up_callback(id, fake_value)

		bt_up.verify
	end

	def test_remove_button_up
		bt_up = MiniTest::Mock.new
		controller = Controller.new(MiniTest::Mock.new, bt_up)

		id = 40

		bt_up.expect(:delete, id, [id])
		controller.remove_button_up_callback(id)

		bt_up.verify
	end

	def test_button_down_with_existing_key
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		bt_down = {id => fake_callback}
		controller = Controller.new(bt_down, MiniTest::Mock.new)

		controller.button_down(id)

		fake_callback.verify
	end

	def test_button_down_with_non_existing_key
		id = 40
		bt_down = MiniTest::Mock.new
		bt_down.expect(:[], nil, [id])
		controller = Controller.new(bt_down, MiniTest::Mock.new)

		controller.button_down(id)

		bt_down.verify
	end
	
	def test_button_up_with_existing_key
		id = 40
		fake_callback = MiniTest::Mock.new
		bt_up = {id => fake_callback}

		fake_callback.expect(:call, nil, [])

		controller = Controller.new(MiniTest::Mock.new, bt_up)

		controller.button_up(id)

		fake_callback.verify
	end

	def test_button_up_with_non_existing_key
		id = 40
		bt_up = MiniTest::Mock.new
		bt_up.expect(:[], nil, [id])
		controller = Controller.new(MiniTest::Mock.new, bt_up)

		controller.button_up(id)

		bt_up.verify
	end

end

