module Hippo::TransactionSets
  module HIPAA_276

    class L2000D < Hippo::TransactionSets::Base
      loop_name 'L2000D'    #Subscriber Level

      #Subscriber Level
      segment Hippo::Segments::HL,
                :name           => 'Subscriber Level',
                :minimum        => 1,
                :maximum        => 1,
                :position       => 100

      #Subscriber Demographic Information
      segment Hippo::Segments::DMG,
                :name           => 'Subscriber Demographic Information',
                :minimum        => 0,
                :maximum        => 1,
                :position       => 400

      #Subscriber Name
      loop    Hippo::TransactionSets::HIPAA_837::L2100D,
                :name           => 'Subscriber Name',
                :identified_by  => {
                  'NM1.NM101' => 'IL'
                },
                :minimum        => 1,
                :maximum        => 1,
                :position       => 500

      #Claim Status Tracking Number
      loop    Hippo::TransactionSets::HIPAA_837::L2200D,
                :name           => 'Claim Status Tracking Number',
                :identified_by  => {
                  'TRN.TRN01' => '1'
                },
                :minimum        => 0,
                :maximum        => nil,
                :position       => 900

    end
  end
end
