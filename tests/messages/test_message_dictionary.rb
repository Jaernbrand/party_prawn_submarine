
require 'test/unit'
require 'minitest/mock'

require 'gosu'

require 'stringio'

require 'messages/message_dictionary'
require 'messages/english'

class MessageDictionaryTester < Test::Unit::TestCase

	def setup
		@eng = English::messages
		@keys = English::keynames
		@msg_dic = MessageDictionary.new(@eng, @keys)
	end

	def test_get_no_winner_message
		sym = :no_winner

		oracle = @eng[sym]
		ret = @msg_dic.message(sym)

		assert_equal(oracle, ret)
	end

	def test_get_winner_message_no_args
		sym = :winner

		assert_raise ArgumentError do
			@msg_dic.message(sym)
		end
	end

	def test_get_winner_message_to_many_args
		sym = :winner

		names = ["Nisse", "Hugo"]

		oracle = sprintf(@eng[sym], names[0])

		warning_msg = "warning: too many arguments for format string"

		old_err = $stderr
		begin
			$stderr = StringIO.new
			ret = @msg_dic.message(sym, *names)

			assert_equal(oracle, ret)

			assert($stderr.string.include?(warning_msg))
		ensure
			$stderr = old_err
		end
	end

	def test_get_winner_message
		sym = :winner

		name = "Nisse"

		oracle = sprintf(@eng[sym], name)
		ret = @msg_dic.message(sym, name)

		assert_equal(oracle, ret)
	end

	def test_get_space_key
		key = Gosu::KbSpace

		ret = @msg_dic.keyname(key)
		
		oracle = "Space"
		assert_equal(oracle, ret)
	end

end

