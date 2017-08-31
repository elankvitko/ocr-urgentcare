class HomeController < ApplicationController
  def index
  end

  def ocr_checker
    if params[ :secondary ]
      @secondary = params[ :secondary ]
    end

    link = get_link( params[ :picture ] )
    image_url = convert_pdf_to_jpg( link )
    ocr_completed = convert_jpg_to_ocr( image_url )

    File.delete( Rails.root.join( params[ :picture ].original_filename ) )
    session[ :ocr_text ] = ocr_completed
    redirect_to controller: 'instructions', action: 'index', secondary: @secondary
  end

  def get_link( file )
    uploaded_io = file

    file = File.open( Rails.root.join( uploaded_io.original_filename ), 'wb' ) do | file |
      file.write( uploaded_io.read )
    end

    begin_pdf( uploaded_io )

    result = upload_pic( "complete.pdf" )
  end

  def begin_pdf( file )
    pdf = CombinePDF.new

    each_pdf = CombinePDF.load( file.original_filename ).pages

    each_pdf.each_with_index do | page, idx |
      if idx == each_pdf.length - 1
        pdf << page
      end
    end

    pdf.save "complete.pdf"
  end

  def convert_pdf_to_jpg( link )
    @process = cloud_convert.build_process(input_format: :pdf, output_format: :jpg)
    @process_response = @process.create
    @conversion_response = @process.convert(
          input: "download",
          outputformat: :jpg,
          file: link,
          download: "false"
        )

    result = "http:" + @conversion_response[ :output ][ :url ]
  end

  def convert_jpg_to_ocr( link )
    download = open( link )
    downloaded_file = IO.copy_stream( download, "image_convert.jpg" )
    file_url = upload_pic( "image_convert.jpg" )
    ocr_result = ocr_helper.convert url: file_url
    ocr_result[ 0 ].to_a[ 2 ].join( " " ).downcase
  end
end
