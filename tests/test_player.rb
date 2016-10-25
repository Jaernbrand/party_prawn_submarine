
require 'test/unit'
require 'minitest/mock'

require 'player'

class PlayerTester < Test::Unit::TestCase

	def setup
		@name = 'Player1'
		@player = Player.new(@name)
	end

	def test_z_value_is_initialised
		assert_equal(0, @player.z)
	end

	def test_z_accessors
		new_value = 5
		@player.z = new_value
		assert_equal(@player.z, new_value)
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

	def test_hash_equal
		assert_equal(@name.hash, @player.hash)
	end

	def test_hash_not_equal
		str = 'Player2'
		assert_not_equal(str.hash, @player.hash)
	end

	def test_eql_same_object
		assert(@player.eql?(@player))
	end

	def test_eql_2_players_same_name
		other = Player.new(@name)
		assert(@player.eql?(other))
	end

	def test_eql_different_namesl
		other = Player.new('Player2')
		assert(!@player.eql?(other))
	end

end

