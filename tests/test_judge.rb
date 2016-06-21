
require 'test/unit'
require 'minitest/mock'

require 'judge'
require 'player'

class JudgeTester < Test::Unit::TestCase

	def test_game_over_more_than_1_alive
		players = [Player.new('Player1'), 
			 		Player.new('Player2'), 
					Player.new('Player3'), 
					Player.new('Player4')]

		judge = Judge.new(*players)

		assert(!judge.game_over?)
	end

	def test_game_over_1_alive
		players = [Player.new('Player1')]

		judge = Judge.new(*players)

		assert(judge.game_over?)
	end

	def test_game_over_0_alive
		judge = Judge.new

		assert(judge.game_over?)
	end

	def test_winner_1_alive
		player = Player.new('Player1')

		judge = Judge.new(player)

		assert_equal(player, judge.winner)
	end

	def test_winner_0_alive
		judge = Judge.new
		assert_equal(nil, judge.winner)
	end

	def test_winner_more_than_1_alive
		players = [Player.new('Player1'), 
			 		Player.new('Player2'), 
					Player.new('Player3'), 
					Player.new('Player4')]

		judge = Judge.new(*players)

		assert_equal(nil, judge.winner)
	end

	def test_died_player_was_alive
		players = [Player.new('Player1'), 
			 		Player.new('Player2'), 
					Player.new('Player3'), 
					Player.new('Player4')]

		judge = Judge.new(*players)

		dead = players[0]

		judge.died(dead)

		assert !judge.alive.include?(dead)
		assert judge.dead.include?(dead)
	end

	def test_died_player_was_not_alive
		players = [Player.new('Player1'), 
			 		Player.new('Player2'), 
					Player.new('Player3'), 
					Player.new('Player4')]

		judge = Judge.new(*players)

		dead = Player.new('Player5')

		judge.died(dead)

		assert !judge.alive.include?(dead)
		assert !judge.dead.include?(dead)
	end

end

