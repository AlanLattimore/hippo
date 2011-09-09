module Hippo::TransactionSets
  class Base
    class << self
      attr_accessor :components, :identifier

      def components
        @components ||= []
      end

      def loop_name(id)
        @identifier = id
      end

      def add_component(klass, options={})
        options[:maximum] ||= 1

        components << options.merge(:class => klass, :sequence => components.length)
      end
      alias segment add_component
      alias loop add_component
    end

    attr_accessor :values, :parent

    def initialize(options = {})
      @parent = options.delete(:parent)
    end

    def values
      @values ||= {}
    end

    def segment_count
      values.map(&:segment_count).inject(&:+)
    end

    def to_s
      output = ''

      values.sort.each do |sequence, component|
        output += component.to_s
      end

      output
    end

    def get_component(identifier, sequence = nil)
      if sequence.nil?
        sequence = 0
      else
        sequence = sequence.to_i - 1
      end

      self.class.components.select do |c|
        c[:class].identifier == identifier
      end[sequence]
    end

    def populate_component(component, defaults)
      defaults ||= {}

      defaults.each do |key, value|
        if key =~ /(\w+)\.(.+)/
          next_component, next_component_value = component.send($1.to_sym), {$2 => value}

          populate_component(next_component, next_component_value)
        else
          component.send((key + '=').to_sym, value)
        end
      end
    end

    def method_missing(method_name, *args)
      component_name, component_sequence = method_name.to_s.split('_')
      component_entry = get_component(component_name, component_sequence)

      if component_entry.nil?
        raise Hippo::Exceptions::InvalidSegment.new "Invalid segment specified: '#{method_name.to_s}'."
      end

      if values[component_entry[:sequence]].nil?
        component = component_entry[:class].new :parent => self

        # iterate through the hash of defaults
        # and assign them to the component before
        # adding to @values
        populate_component(component, component_entry[:defaults])
        populate_component(component, component_entry[:identified_by])

        values[component_entry[:sequence]] = if component_entry[:maximum] > 1
                                               RepeatingComponent.new(component_entry[:class],self, component)
                                             else
                                               component
                                             end
      end

      yield values[component_entry[:sequence]] if block_given?
      return values[component_entry[:sequence]]
    end

    class RepeatingComponent < Array
      def initialize(klass, parent, *args)
        @klass = klass
        @parent = parent

        self.push(*args)
      end

      def build
        self.push(@klass.new :parent => @parent)

        yield self[-1] if block_given?
        self[-1]
      end

      def to_s
        self.map(&:to_s).join
      end

      def segment_count
        self.map(&:segment_count).inject(&:+)
      end

      def method_missing(method_name, *args, &block)
        self.first.send(method_name, *args, &block)
      end
    end
  end
end
