module Hippo::TransactionSets
  module HIPAA_835
    class Base < Hippo::TransactionSets::Base
      
      #Transaction Set Header 
      segment Hippo::Segments::ST, 
                 'TransactionSetIdentifierCode' => '835',
                 :position => 010

      #Financial Information
      segment Hippo::Segments::BPR,  
                  :position => 020
      
      #Reassociation Trace Number
      segment Hippo::Segments::TRN, 
                 'TraceTypeCode' => '1',
                  :position => 040

      #Foreign Currency Information
      segment Hippo::Segments::CUR,  
                  :position => 050

      #Receiver Identification
      segment Hippo::Segments::REF,  
                  :position => 060
                
      #Version Identification
      segment Hippo::Segments::REF, 
                  :position => 060

      #Production Date
      segment Hippo::Segments::DTM, 
                  'DateTimeQualifier' => '405',
                  :position => 070
                    
      loop    L1000A,  
              :identified_by => {'N1.EntityIdentifierCode' => 'PR'},
              :minimum => 1,
              :maximum => 1

      loop    L1000B, 
              :identified_by => {'N1.EntityIdentifierCode' => 'PE'},
              :minimum => 1,
              :maximum => 1

      loop    L2000,
              :minimum => 1,
              :maximum => nil
     
      #Transaction Set Trailer
      segment Hippo::Segments::SE, 
              :minimum => 1,
              :maximum => 1,
              :position => 020
    end

    class L1000A < Hippo::TransactionSets::Base
      #Payer Identification
      segment Hippo::Segments::N1,  
                  'EntityIdentifierCode' => 'PR',
              :minimum => 1,
              :maximum => 1,
              :position => 080
      
      #Payer Address 
      segment Hippo::Segments::N3,  
              :minimum => 1,
              :maximum => 1,
              :position => 100

      #Payer Cit, State, Zip Code
      segment Hippo::Segments::N4, 
              :minimum => 1,
              :maximum => 1,
              :position => 110

      #Additional Payer Identification
      segment Hippo::Segments::REF,  
              :minimum => 0,
              :maximum => 4,
              :position => 120
     
       #Payer Contact Information 
       segment Hippo::Segments::PER, 
               :minimum => 0,
               :maximum => 1,
               :position => 130
    end

    class L1000B < Hippo::TransactionSets::Base
      #Payee Identification
      segment Hippo::Segments::N1,  
              'EntityIdentifierCode' => 'PE',
              :minimum => 1,
              :maximum => 1,
              :position => 080

      
      #Payee Address
      segment Hippo::Segments::N3,  
              :minimum => 0,
              :maximum => 1,
              :position => 100

      #Payee City, State, Zip Code
      segment Hippo::Segments::N4,  
              :minimum => 0,
              :maximum => 1,
              :position => 110
     
      #Payee Additional Identification
      segment Hippo::Segments::REF,  
              :minimum => 1,
              :maximum => nil,
              :position => 120
    end

    class L2000 < Hippo::TransactionSets::Base
      
      #Header Number
      segment Hippo::Segments::LX, 
              :minimum => 1,
              :maximum => nil,
              :position => 003
     
      #Provider Summary Information
      segment Hippo::Segments::TS3,  
              :minimum => 0,
              :maximum => 1,
              :position => 005
     
      #Provider Supplemental Summary Information
      segment Hippo::Segments::TS2,  
              :minimum => 0,
              :maximum => 1,
              :position => 007

      loop    L2100, 
              :idenitied_by => {'CLP.ClaimSubmittersIdentifier' => '!=nil'},
              :minimum => 1,
              :maximum => nil,
    end

    
    class L2100 < Hippo::TransactionSets::Base
      
      #Claim Payment Information
      segment Hippo::Segments::CLP, 
              :minimum => 1,
              :maximum => 1,
              :position => 010
     
      #Claim Adjustment
      segment Hippo::Segments::CAS, 
              :minimum => 0,
              :maximum => 99,
              :position => 020
     
      segment Hippo::Segments::NM1,
              'EntityIdentifierCode' => 'QC',  #Patient
              :minimum => 1,
              :maximum => 1,
              :position => 030

      segment Hippo::Segments::NM1,
              'EntityIdentifierCode' => 'IL',  #Insured or Subscriber
              :minimum => 0,
              :maximum => 1, 
              :position => 030

      segment Hippo::Segments::NM1,
              'EntityIdentifierCode' => '74',  #Corrected Insured
              :minimum => 0,
              :maximum => 1,
              :position => 030

      segment Hippo::Segments::NM1,
              'EntityIdentifierCode' => '82',  #Rendering Provider
              :minimum => 0,
              :maximum => 1,
              :position => 030

      segment Hippo::Segments::NM1,
              'EntityIdentifierCode' => 'TT',  #Transfer To
              :minimum => 0,
              :maximum => 1,
              :position => 030

      segment Hippo::Segments::NM1, 
              'EntityIdentifierCode' => 'PR',  #Payer
              :minimum => 0,
              :maximum => 1,
              :position => 030
      
      #Inpatient Adjudication Information
      segment Hippo::Segments::MIA,             
              :minimum => 0, 
              :maximum => 1,
              :position => 033
     
      #Outpatient Adjudication Information 
      segment Hippo::Segments::MOA, 
              :minimum => 0,
              :maximum => 1,
              :position => 035
     
      #Other Claim Related Identification
      segment Hippo::Segments::REF, 
              :minimum => 0,
              :maximum => 99,
              :position => 040
      
      #Rendering Provider Identification
      segment Hippo::Segments::REF,  
              :minimum => 0,
              :maximum => 10,
              :position => 040
       
      #Claim Date
      segment Hippo::Segments::DTM,               
              :minimum => 0,
              :maximum => 4,
              :position => 050

      #Claim Contact Information
      segment Hippo::Segments::PER,  
              :minimum => 0,
              :maximum => 3,
              :position => 060
     
      #Claim Supplemental Information
      segment Hippo::Segments::AMT,  
              :minimum => 0, 
              :maximum => 14,
              :position => 062
     
      #Claim Supplemental Information Quantity
      segment Hippo::Segments::QTY, 
              :minimum => 0,
              :maximum => 15,
              :position => 064

      loop    L2110, 
              :idenitied_by => {'SVC.CompositeMedicalProcedureIdentifier1' => '!=nil'},
              :minimum => 0,
              :maximum => 999
              
    end

    class L2110 < Hippo::TransactionSets::Base
    
      #Service Payment Information
      segment Hippo::Segments::SVC,
              :minimum => 0,
              :maximum => 1,
              :position => 070
      
      #Service Date
      segment Hippo::Segments::DTM, 
              :minimum => 0,
              :maximum => 3,
              :position => 080
       
      #Service Adjustment
      segment Hippo::Segments::CAS, 
              :minimum => 0,
              :maximum => 99,
              :position => 090
   
      #Service Identification
      segment Hippo::Segments::REF,  
              :minimum => 0,
              :maximum => 7,
              :position => 100
      
      #Rendering Provider Information
      segment Hippo::Segments::REF, 
              :minimum => 0,
              :maximum => 10,
              :position => 100
      
      #Service Supplemental Amount
      segment Hippo::Segments::AMT, 
              :minimum => 0,
              :maximum => 12,
              :position => 110
  
      #Service Supplemental Quantity
      segment Hippo::Segments::QTY,  
              :minimum => 0,
              :maximum => 6,
              :position => 120
     
      #Health Care Remark Codes 
      segment Hippo::Segments::LQ, 
              :minimum => 0,
              :maximum => 99,
              :position => 130
     
      #Provider Adjustment
      segment Hippo::Segments::PLB,  
              :minimum => 1,
              :maximum => nil,
              :position => 010
    end
  end
end
