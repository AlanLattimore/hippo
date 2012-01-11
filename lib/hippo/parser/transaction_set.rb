module Hippo
  class Parser
    module TransactionSet
      attr_accessor :unparsed_data

      def initialize(options={})
        super
      end

      def find_first_segment(segments, identifier, reverse = false)
        segments.reverse! if reverse

        if index = segments.index{|o| o.identifier == identifier}
          segments[index]
        else
          nil
        end
      end

      def segments
        @segments ||= @unparsed_data.split(@segment_separator).collect do |segment_string|
          segment = Hippo::Segments.const_get(segment_string.split(@field_separator).first).new(:parent => self)

          segment.parse(segment_string)
        end
      end

      def read(input)
        @unparsed_data = input.gsub(/[\a\e\f\n\r\t\v]/,'')
        parse_separators(@unparsed_data)
      end

      def parse(input)
        read(input)
        populate(segments)
        self
      end
    end
  end
end