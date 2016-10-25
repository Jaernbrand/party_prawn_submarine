
require 'test/unit'
require 'minitest/mock'

require 'factories/game_factory'

require 'player'

class GameFactoryTester < Test::Unit::TestCase

	def setup
		@fake_ctrl_fac = MiniTest::Mock.new
		@game_factory = GameFactory.new(@fake_ctrl_fac)
	end

	def test_create_game_party_horn_is_assigned_player
		fake_ctrl = MiniTest::Mock.new
		fake_window = MiniTest::Mock.new

		fake_game_over = MiniTest::Mock.new

		player = Player.new("Player1")

		@fake_ctrl_fac.expect(:create_controller, fake_ctrl, [Player])

		play_state = @game_factory.create_game(fake_window, 
											   fake_game_over, 
											   player)

		assert_equal(player, player.party_horn.player)
	end

	def test_create_game_one_player
		fake_ctrl = MiniTest::Mock.new
		fake_player = MiniTest::Mock.new
		fake_window = MiniTest::Mock.new

		fake_game_over = MiniTest::Mock.new

		fake_player.expect(:submarine=, nil, [Submarine])
		fake_player.expect(:party_horn=, nil, [PartyHorn])
		fake_player.expect(:hash, 10, [])
		fake_player.expect(:z=, nil, [Numeric])

		@fake_ctrl_fac.expect(:create_controller, fake_ctrl, [fake_player])

		play_state = @game_factory.create_game(fake_window, 
											   fake_game_over, 
											   fake_player)

		@fake_ctrl_fac.verify
		assert(play_state.instance_of? PlayState)
		assert(play_state.judge.instance_of? Judge)
	end

	def test_create_game_two_players_z_values_are_assigned
		fake_ctrl = MiniTest::Mock.new
		players = [Player.new("p1"), Player.new("p2")]
		fake_window = MiniTest::Mock.new

		fake_game_over = MiniTest::Mock.new

		@fake_ctrl_fac.expect(:create_controller, fake_ctrl, [Player, Player])

		@game_factory.create_game(fake_window, 
											   fake_game_over, 
											   *players)

		oracles = [0, 100]
		oracles.each_index do |idx|
			assert_equal(oracles[idx], players[idx].z)
		end
	end
	
	def test_create_starting_positions
		oracle_length = 4
		positions = @game_factory.send(:create_starting_positions)

		assert_equal(oracle_length, positions.length)
	end

	def test_next_starting_position
		oracle = Point.new(GameFactory::BOARD_WIDTH/4, 
							  GameFactory::BOARD_HEIGHT/4)

		pos = @game_factory.send(:next_starting_position)

		assert_equal(oracle.x, pos.x)
		assert_equal(oracle.y, pos.y)
	end
	
	def test_next_starting_position_four_times
		positions = @game_factory.send(:create_starting_positions)

		for i in 0...(positions.length)
			ret = @game_factory.send(:next_starting_position)
			curr_pos = positions[i]

			assert_equal(curr_pos.x, ret.x)
			assert_equal(curr_pos.y, ret.y)
		end
	end

	def test_assign_z_values
		players = []
		4.times { |i| players << Player.new("p" + i.to_s) }
		
		@game_factory.send(:assign_z_values, players)

		oracles = [0, 100, 200, 300]
		oracles.each_index do |idx|
			assert_equal(oracles[idx], players[idx].z)
		end
	end

end

