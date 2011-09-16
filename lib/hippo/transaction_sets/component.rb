module Hippo::TransactionSets
  class Component
    attr_reader :options, :klass, :sequence, :maximum, :identified_by

    def initialize(options)
      @identified_by  = options.delete(:identified_by)  || {}
      @maximum        = options.delete(:maximum)        || 1
      @klass          = options.delete(:klass)
      @sequence       = options.delete(:sequence)

      @options        = options
    end

    def repeating?
      @maximum > 1
    end

    def loop?
      @klass.ancestors.include? Hippo::TransactionSets::Base
    end

    def identifier
      @klass.identifier
    end

    def populate_component(component, defaults = nil)
      defaults ||= identified_by

      defaults.each do |key, value|
        value = Array(value)

        if key =~ /(\w+)\.(.+)/
          next_component, next_component_value = component.send($1.to_sym), {$2 => value}

          populate_component(next_component, next_component_value)
        else
          next if value.length > 1

          component.send((key + '=').to_sym, value)
        end
      end

      component
    end

    def initialize_component(parent)
      if repeating?
        RepeatingComponent.new(self, parent)
      else
        populate_component(@klass.new(:parent => parent))
      end
    end

    def valid?(segment)
      if klass.ancestors.include? Hippo::Segments::Base
        valid_segment?(segment)
      else
        valid_entry_segment?(segment)
      end
    end

    def valid_segment?(segment)
      segment.identifier == identifier && identified_by.all? {|k, v| Array(v).include?(segment.send(k.to_sym))}
    end

    def valid_entry_segment?(segment)
      if identified_by.empty?
        initial_segment_id = @klass.components.first.identifier

        segment.identifier == initial_segment_id
      else
        path, value = identified_by.first
        # TODO: handle arbitrary depth in loop identified_by parsing
        segment_id, field_name = path.split('.')

        segment.identifier == segment_id && Array(value).include?(segment.send(field_name))
      end
    end
  end
end
