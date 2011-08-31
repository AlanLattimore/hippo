module Hippo::TransactionSets
  module HIPAA_837

    class L2330A < Hippo::TransactionSets::Base
      loop_name 'L2330A'    #Other Subscriber Name

      segment Hippo::Segments::NM1,
                :minimum        => 1,
                :maximum        => 1,
                :position       => 79

      segment Hippo::Segments::N3,
                :minimum        => 0,
                :maximum        => 1,
                :position       => 80

      segment Hippo::Segments::N4,
                :minimum        => 1,
                :maximum        => 1,
                :position       => 81

      segment Hippo::Segments::REF,
                :minimum        => 0,
                :maximum        => 1,
                :position       => 82

    end
  end
end
