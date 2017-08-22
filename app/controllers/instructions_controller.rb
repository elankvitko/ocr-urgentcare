class InstructionsController < ApplicationController
  def index
    ocr_text = session[ :ocr_text ]

    session[ :ocr_text ] = nil

    key_words = [ "allied", "oxford", "medicare", "healthfirst", "emblemhealth", "emblemhealth" ]

    key_hash = {
                "allied" => "mail: allied benefit svstems, inc. \r\n",
                "oxford" => "for members: \r\n" + "www.oxfordhealth.com",
                "medicare" => "health care financing administration",
                "healthfirst" => "healthfirst",
                "emblemhealth" => {
                                    "13551" => "ghi",
                                    "2845" => "hip",
                                  }
              }

    text_found = []

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
    @render = text_found[ 0 ]
  end
end
