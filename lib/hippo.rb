libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

module Hippo
  autoload :Exceptions,       'hippo/exceptions'
  autoload :Separator,        'hippo/separator'
  autoload :Segments,         'hippo/segments'
  autoload :TransactionSets,  'hippo/transaction_sets'
  autoload :Field,            'hippo/field'
  autoload :CompositeField,   'hippo/composite_field'
  autoload :Parser,           'hippo/parser'

  DEFAULT_FIELD_SEPARATOR        = '*'
  DEFAULT_COMPOSITE_SEPARATOR    = ':'
  DEFAULT_SEGMENT_SEPARATOR      = '~'
  DEFAULT_REPETITION_SEPARATOR   = '^'
end
