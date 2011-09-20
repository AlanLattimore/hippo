require File.expand_path('test_helper', File.dirname(__FILE__))

class TestParser < MiniTest::Unit::TestCase
  def setup
    @parser = Hippo::Parser.new
  end

  def test_populate_segments_returns_array_of_segments
    @parser.read_file('samples/005010X221A1_business_scenario_1.edi')
    @parser.populate_segments

    assert_instance_of Array, @parser.segments

    @parser.segments.each do |segment|
      assert_kind_of Hippo::Segments::Base, segment
    end
  end

  def test_parse_returns_array_of_transaction_sets
    transaction_sets = @parser.parse('samples/005010X221A1_business_scenario_1.edi')

    assert_instance_of Array, transaction_sets

    transaction_sets.each do |ts|
      assert_kind_of Hippo::TransactionSets::Base, ts
    end
  end

  def test_raises_error_on_extra_segments
    ts = Hippo::TransactionSets::Test::Base.new
    ts.ST
    ts.TSS.Field2 = 'Bar'
    ts.TSS.Field3 = 'Baz'
    ts.TCS.Field1 = 'Blah'
    ts.TCS.CompositeCommonName_02 = 'CNBlah'
    ts.TSS_02.Field2 = 'Boo'

    # test nexted block syntax on non-looping component
    ts.L0001.TSS.Field2 = 'SubBar'

    # test nexted block syntax on non-looping component
    ts.L0002 do |l0002|
      l0002.TCS.Field2 = 'SubBarBlah'
      l0002.TSS.Field2 = 'SubBarRepeater'
    end

    #'TSS*Blah*Bar*Baz~TCS*Blah*:::CNBlah*Preset Field 7~TSS*Last Segment*Boo~TSS*Foo*SubBar~TCS*:SubBarBlah**Foo2~TSS*Last Segment*SubBarRepeater~', ts.to_s

    @parser.raw_data = ts.to_s
    @parser.populate_segments
    ts_result = @parser.populate_transaction_sets.first

    puts ts.inspect
    puts ts_result.inspect

    assert_equal ts.values.inspect, ts_result.values.inspect
  end
end
