module Regexp::Syntax

  module Ruby
    class V18 < Regexp::Syntax::Base

      include Regexp::Syntax::Token

      def initialize
        super

        implements :meta, Meta::Extended

        implements :anchor,
          Anchor::Extended + Anchor::String

        implements :escape, 
          Escape::Backreference + Escape::ASCII +
          Escape::Meta

        implements :group,
          Group::Extended + Group::Assertion

        implements :set, 
          CharacterSet::Extended + CharacterSet::Types

        implements :type,
          CharacterType::Extended

        implements :quantifier, 
          Quantifier::Greedy + Quantifier::Interval
      end
    end
  end

end