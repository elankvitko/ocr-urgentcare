class InstructionsController < ApplicationController
  def index
    ocr_text = session[ :ocr_text ]
    clean_session
    @render = keyword_search( ocr_text )[ 0 ]
  end

  def clean_session
    session[ :ocr_text ] = nil
  end

  def keyword_search( ocr_text )
    text_found = []

    key_words = [
                  "allied",
                  "oxford",
                  "medicare",
                  "healthfirst",
                  "emblemhealth",
                  "emblemhealth",
                  "metroplus",
                  "1199",
                  "affinity",
                  "blue",
                  "unitedhealthcare"
                ]

    key_hash = {
                "allied" => "mail: allied benefit svstems, inc. \r\n",
                "oxford" => "for members: \r\n" + "www.oxfordhealth.com",
                "medicare" => "health care financing administration",
                "healthfirst" => "healthfirst",
                "emblemhealth" => { "13551" => "ghi", "2845" => "hip" },
                "metroplus" => "metroplus",
                "1199" => "1199seiu",
                "affinity" => "affinity",
                "blue" => { "blue cross" => "blue", "bluecross" => "blue" },
                "unitedhealthcare" => { "student" => "unitedhealthcarestudent" }
               }


     key_words.each do | key |
       if ocr_text.include?( key )
         if key_hash[ key ].is_a? Hash
           key_hash[ key ].each do | identifier, payor |
             text_found << payor if ocr_text.include? identifier
           end
         elsif ocr_text.include?( key_hash[ key ] )
           text_found << key
         end
       end
     end
    text_found
  end
end
