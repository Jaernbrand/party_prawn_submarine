
require 'test/unit'
require 'minitest/mock'

require 'messages/message_dictionary'
require 'messages/english'

class MessageDictionaryTester < Test::Unit::TestCase

	def setup
		@eng = English::messages
		@msg_dic = MessageDictionary.new(@eng)
	end

	def test_get_no_winner_message
		sym = :no_winner

		oracle = @eng[sym]
		ret = @msg_dic.message(sym)

		assert_equal(oracle, ret)
	end

	def test_get_winner_message_no_args
		sym = :winner

		oracle = @eng[sym]
		assert_raise ArgumentError do
			@msg_dic.message(sym)
		end
	end

	def test_get_winner_message_to_many_args
		sym = :winner

		names = ["Nisse", "Hugo"]

		oracle = sprintf(@eng[sym], names[0])
		ret = @msg_dic.message(sym, *names)

		assert_equal(oracle, ret)
	end

	def test_get_winner_message
		sym = :winner

		name = "Nisse"

		oracle = sprintf(@eng[sym], name)
		ret = @msg_dic.message(sym, name)

		assert_equal(oracle, ret)
	end

end

