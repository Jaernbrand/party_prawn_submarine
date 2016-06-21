
require 'test/unit'
require 'minitest/mock'

require 'player'

class PlayerTester < Test::Unit::TestCase

	def setup
		@name = 'Player1'
		@player = Player.new(@name)
	end

	def test_equal_same_name
		other = Player.new(@name)
		assert(@player == other)
	end

	def test_equal_not_same_name
		other = Player.new('AnOtherName')
		assert(!(@player == other))
	end

	def test_equal_not_same_class
		other = 'StringInstance'
		assert(!(@player == other))
	end

	def test_compare_same_name
		other = Player.new(@name)
		assert_equal(0, @player <=> other)
	end

	def test_compare_less_than
		other = Player.new('Zebra')
		assert_equal(-1, @player <=> other)
	end

	def test_compare_greater_than
		other = Player.new('AnOtherName')
		assert_equal(1, @player <=> other)
	end

end

