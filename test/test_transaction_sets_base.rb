require_relative './test_helper'

class TestTransactionSetBase < MiniTest::Unit::TestCase
  def test_preset_values_are_set
    ts = Hippo::TransactionSets::Test::Base.new
    ts.TCS {|tcs| }
    ts.TSS {|tss| }

    assert_equal 'TSS*Blah~TCS***Preset Field 7~', ts.to_s
  end

  def test_segment_ordering_is_correct
    ts = Hippo::TransactionSets::Test::Base.new
    ts.TCS.Field1 = 'Foo'
    ts.TSS.Field2 = 'Bar'

    assert_equal 'TSS*Blah*Bar~TCS*Foo**Preset Field 7~', ts.to_s
  end

  def test_raises_error_on_invalid_segment
    ts = Hippo::TransactionSets::Test::Base.new
    assert_raises Hippo::Exceptions::InvalidSegment do
      ts.BLAH {|blah| }
    end
  end

  def test_identified_by_values_are_set
    ts = Hippo::TransactionSets::Test::Base.new
    ts.L0001 {|l0001| }

    assert_equal 'TSS*Foo~', ts.to_s

  end

  def test_accessing_repeated_segments
    ts = Hippo::TransactionSets::Test::Base.new
    ts.TSS.Field2 = 'Bar'
    ts.TCS.Field1 = 'Foo'
    ts.TSS_02.Field2 = 'Baz'

    assert_equal 'TSS*Blah*Bar~TCS*Foo**Preset Field 7~TSS*Last Segment*Baz~', ts.to_s
  end
end
