
require 'gosu'

# Responsible for creating the dictionary of user messages in english.
module English

	# Returns a Hash with all user messages in english.
	#
	# * *Returns* :
	#   - Hash containing the user messages in english
	# * *Return* *Type* :
	#   - Hash<Symbol, String>
	def self.messages
		{:winner => "The winner is %s!",
   		:no_winner => "No one won.",
		:game_over_prompt => "Press %s to return to menu.",
		:exit => "Exit",
		:new_game => "New game",
		:back => "Back",
		:start => "Start",
		:controls => "Controls",
		:version => "Version"}
	end

	# Returns a Hash with the gosu key constants as keys and the string 
	# representation of the constants as values.
	#
	# * *Returns* :
	#   - Hash containing the keynames of gosu key constants
	# * *Return* *Type* :
	#   - Hash<Fixnum, String>
	def self.keynames
		{Gosu::Kb0 => "0",
   		Gosu::Kb1 => "1",
		Gosu::Kb2 => "2",
		Gosu::Kb3 => "3",
		Gosu::Kb4 => "4",
		Gosu::Kb5 => "5",
		Gosu::Kb6 => "6",
		Gosu::Kb7 => "7",
		Gosu::Kb8 => "8",
		Gosu::Kb9 => "9",
		Gosu::KbA => "A",
		Gosu::KbB => "B",
		Gosu::KbC => "C",
		Gosu::KbD => "D",
		Gosu::KbE => "E",
		Gosu::KbF => "F",
		Gosu::KbG => "G",
		Gosu::KbH => "H",
		Gosu::KbI => "I",
		Gosu::KbJ => "J",
		Gosu::KbK => "K",
		Gosu::KbL => "L",
		Gosu::KbM => "M",
		Gosu::KbN => "N",
		Gosu::KbO => "O",
		Gosu::KbP => "P",
		Gosu::KbQ => "Q",
		Gosu::KbR => "R",
		Gosu::KbS => "S",
		Gosu::KbT => "T",
		Gosu::KbU => "U",
		Gosu::KbV => "V",
		Gosu::KbW => "W",
		Gosu::KbX => "X",
		Gosu::KbY => "Y",
		Gosu::KbZ => "Z",
		Gosu::KbBackspace => "Backspace",
		Gosu::KbDelete => "Delete",
		Gosu::KbDown => "Down",
		Gosu::KbEnd => "End",
		Gosu::KbEnter => "Enter",
		Gosu::KbEscape => "Escape",
		Gosu::KbF1 => "F1",
		Gosu::KbF2 => "F2",
		Gosu::KbF3 => "F3",
		Gosu::KbF4 => "F4",
		Gosu::KbF5 => "F5",
		Gosu::KbF6 => "F6",
		Gosu::KbF7 => "F7",
		Gosu::KbF8 => "F8",
		Gosu::KbF9 => "F9",
		Gosu::KbF10 => "F10",
		Gosu::KbF11 => "F11",
		Gosu::KbF12 => "F12",
		Gosu::KbHome => "Home",
		Gosu::KbInsert => "Insert",
		Gosu::KbLeft => "Left",
		Gosu::KbLeftAlt => "Left Alt",
		Gosu::KbLeftControl => "Left Ctrl",
		Gosu::KbLeftShift => "Left Shift",
		Gosu::KbNumpad0 => "Numpad 0",
		Gosu::KbNumpad1 => "Numpad 1",
		Gosu::KbNumpad2 => "Numpad 2",
		Gosu::KbNumpad3 => "Numpad 3",
		Gosu::KbNumpad4 => "Numpad 4",
		Gosu::KbNumpad5 => "Numpad 5",
		Gosu::KbNumpad6 => "Numpad 6",
		Gosu::KbNumpad7 => "Numpad 7",
		Gosu::KbNumpad8 => "Numpad 8",
		Gosu::KbNumpad9 => "Numpad 9",
		Gosu::KbNumpadAdd => "Numnpad +",
		Gosu::KbNumpadDivide => "Numpad /",
		Gosu::KbNumpadMultiply => "Numpad *",
		Gosu::KbNumpadSubtract => "Numpad -",
		Gosu::KbPageDown => "Page Down",
		Gosu::KbPageUp => "Page Up",
		Gosu::KbReturn => "Return",
		Gosu::KbRight => "Right",
		Gosu::KbRightAlt => "Right Alt",
		Gosu::KbRightControl => "Right Ctrl",
		Gosu::KbRightShift => "Right Shift",
		Gosu::KbSpace => "Space",
		Gosu::KbTab => "Tab",
		Gosu::KbUp => "Up",
		Gosu::KbBacktick => "`",
		Gosu::KbMinus => "-",
		Gosu::KbEqual => "=",
		Gosu::KbBracketLeft => "{",
		Gosu::KbBracketRight => "}",
		Gosu::KbBackslash => "\\",
		Gosu::KbSemicolon => ";",
		Gosu::KbApostrophe => "'",
		Gosu::KbComma => ",",
		Gosu::KbPeriod => ".",
		Gosu::KbSlash => "/",
		Gosu::MsLeft => "Left Mouse Button",
		Gosu::MsMiddle => "Middle Mouse Button",
		Gosu::MsRight => "Right Mouse Button",
		Gosu::MsWheelDown => "Mouse Wheel Down",
		Gosu::MsWheelUp => "Mouse Wheel Up"}
	end

end

