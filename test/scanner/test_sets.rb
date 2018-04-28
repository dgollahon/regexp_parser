require File.expand_path("../../helpers", __FILE__)

class ScannerSets < Test::Unit::TestCase

  tests = {
    '[a]'                   => [0, :set,    :open,            '[',          0, 1],
    '[b]'                   => [2, :set,    :close,           ']',          2, 3],
    '[^n]'                  => [1, :set,    :negate,          '^',          1, 2],

    '[c]'                   => [1, :literal, :literal,        'c',          1, 2],
    '[\b]'                  => [1, :set,    :backspace,       '\b',         1, 3],
    '[A\bX]'                => [2, :set,    :backspace,       '\b',         2, 4],

    '[.]'                   => [1, :literal, :literal,        '.',          1, 2],
    '[?]'                   => [1, :literal, :literal,        '?',          1, 2],
    '[*]'                   => [1, :literal, :literal,        '*',          1, 2],
    '[+]'                   => [1, :literal, :literal,        '+',          1, 2],
    '[{]'                   => [1, :literal, :literal,        '{',          1, 2],
    '[}]'                   => [1, :literal, :literal,        '}',          1, 2],
    '[<]'                   => [1, :literal, :literal,        '<',          1, 2],
    '[>]'                   => [1, :literal, :literal,        '>',          1, 2],

    '[\x20]'                => [1, :escape, :hex,             '\x20',       1, 5],

    '[\.]'                  => [1, :set,    :escape,          '\.',         1, 3],
    '[\!]'                  => [1, :set,    :escape,          '\!',         1, 3],
    '[\#]'                  => [1, :set,    :escape,          '\#',         1, 3],
    '[\]]'                  => [1, :set,    :escape,          '\]',         1, 3],
    '[\\\]'                 => [1, :set,    :escape,          '\\\\',       1, 3],
    '[a\-c]'                => [2, :set,    :escape,          '\-',         2, 4],

    '[\d]'                  => [1, :type,   :digit,           '\d',         1, 3],
    '[\da-z]'               => [1, :type,   :digit,           '\d',         1, 3],
    '[\D]'                  => [1, :type,   :nondigit,        '\D',         1, 3],

    '[\h]'                  => [1, :type,   :hex,             '\h',         1, 3],
    '[\H]'                  => [1, :type,   :nonhex,          '\H',         1, 3],

    '[\s]'                  => [1, :type,   :space,           '\s',         1, 3],
    '[\S]'                  => [1, :type,   :nonspace,        '\S',         1, 3],

    '[\w]'                  => [1, :type,   :word,            '\w',         1, 3],
    '[\W]'                  => [1, :type,   :nonword,         '\W',         1, 3],

    '[\R]'                  => [1, :type,   :linebreak,       '\R',         1, 3],
    '[\X]'                  => [1, :type,   :xgrapheme,       '\X',         1, 3],

    '[a-c]'                 => [1, :set,    :range,           'a-c',        1, 4],
    '[a-c-]'                => [2, :literal, :literal,        '-',          4, 6],
    '[a-c^]'                => [2, :literal, :literal,        '^',          4, 5],
    '[a-cd-f]'              => [2, :set,    :range,           'd-f',        4, 7],

    '[a[:digit:]c]'         => [2, :set,    :class_digit,     '[:digit:]',  2, 11],
    '[[:digit:][:space:]]'  => [2, :set,    :class_space,     '[:space:]', 10, 19],
    '[[:^digit:]]'          => [1, :set,    :class_nondigit,  '[:^digit:]', 1, 11],

    '[a[.a-b.]c]'           => [2, :set,    :collation,       '[.a-b.]',    2,  9],
    '[a[=e=]c]'             => [2, :set,    :equivalent,      '[=e=]',      2,  7],

    '[a-d&&g-h]'            => [2, :set,    :intersection,    '&&',         4, 6],

    '[\\x20-\\x28]'         => [1, :set,    :range,           '\x20-\x28',  1, 10],

    '[a\p{digit}c]'         => [2, :property,    :digit,      '\p{digit}',  2, 11],
    '[a\P{digit}c]'         => [2, :nonproperty, :digit,      '\P{digit}',  2, 11],
    '[a\p{^digit}c]'        => [2, :nonproperty, :digit,      '\p{^digit}', 2, 12],
    '[a\P{^digit}c]'        => [2, :property,    :digit,      '\P{^digit}', 2, 12],

    '[a\p{ALPHA}c]'         => [2, :property,    :alpha,      '\p{ALPHA}',  2, 11],
    '[a\p{P}c]'             => [2, :property,    :punct_any,  '\p{P}',      2, 7],
    '[a\p{P}\P{P}c]'        => [3, :nonproperty, :punct_any,  '\P{P}',      7, 12],

    '[a-w&&[^c-g]z]'        => [3, :set,    :open,            '[',          6, 7],
    '[a-w&&[^c-h]z]'        => [4, :set,    :negate,          '^',          7, 8],
    '[a-w&&[^c-i]z]'        => [5, :set,    :range,           'c-i',        8, 11],
    '[a-w&&[^c-j]z]'        => [6, :set,    :close,           ']',          11, 12],
  }

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te)), count|
    define_method "test_scanner_#{type}_#{token}_#{count}" do
      tokens = RS.scan(pattern)
      result = tokens.at(index)

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

end
