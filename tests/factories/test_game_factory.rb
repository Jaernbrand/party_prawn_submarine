
require 'test/unit'
require 'minitest/mock'

require 'factories/game_factory'

class GameFactoryTester < Test::Unit::TestCase

	def setup
		@fake_ctrl_fac = MiniTest::Mock.new
		@game_factory = GameFactory.new(@fake_ctrl_fac)
	end

	def test_create_game_one_player
		fake_ctrl = MiniTest::Mock.new
		fake_player = MiniTest::Mock.new
		fake_window = MiniTest::Mock.new

		fake_player.expect(:submarine=, nil, [Submarine])
		fake_player.expect(:party_horn=, nil, [PartyHorn])
		fake_player.expect(:hash, 10, [])

		@fake_ctrl_fac.expect(:create_controller, fake_ctrl, [fake_player])

		play_state = @game_factory.create_game(fake_window, fake_player)

		@fake_ctrl_fac.verify
		assert(play_state.instance_of? PlayState)
		assert(play_state.judge.instance_of? Judge)
	end

end

