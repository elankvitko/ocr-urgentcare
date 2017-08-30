class HomeController < ApplicationController
  def index

  end

  def ocr_checker
    if params[ :secondary ]
      @secondary = params[ :secondary ]
    end

    uploaded_io = params[ :picture ]

    file = File.open( Rails.root.join( uploaded_io.original_filename ), 'wb' ) do |file|
      file.write( uploaded_io.read )
    end

    result = upload_pic( uploaded_io.original_filename )

    @process = cloud_convert.build_process(input_format: :pdf, output_format: :jpg)
    @process_response = @process.create
    @conversion_response = @process.convert(
          input: "download",
          outputformat: :jpg,
          file: result,
          download: "false"
        )

    result_con = "http:" + @conversion_response[ :output ][ :url ]

    download = open( result_con )
    downloaded_file = IO.copy_stream( download, "image_convert.jpg" )
    file_url = upload_pic( "image_convert.jpg" )


    ocr_result = ocr_helper.convert url: file_url

    ocr_text = ocr_result[ 0 ].to_a[ 2 ].join( " " ).downcase

    session[ :ocr_text ] = ocr_text
    redirect_to controller: 'instructions', action: 'index', secondary: @secondary
  end
end
