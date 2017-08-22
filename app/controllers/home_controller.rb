class HomeController < ApplicationController
  def index

  end

  def ocr_checker
    if params[ :secondary ]
      @secondary = params[ :secondary ]
    end

    uploaded_io = params[ :picture ]

    file = File.open( Rails.root.join('public', 'uploads', uploaded_io.original_filename ), 'wb' ) do |file|
      file.write( uploaded_io.read )
    end

    result = upload_pic( uploaded_io.original_filename )

    ocr_result = ocr_helper.convert url: result

    ocr_text = ocr_result[ 0 ].to_a[ 2 ].join( " " ).downcase

    session[ :ocr_text ] = ocr_text
    redirect_to controller: 'instructions', action: 'index', secondary: @secondary
  end
end
