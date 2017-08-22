class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def upload_pic( image )
    image = Cloudinary::Uploader.upload( Rails.root.join( 'public', 'uploads', image ), api_key: ENV[ "CLOUDINARY_API_KEY" ], api_secret: ENV[ "CLOUDINARY_API_SECRET" ], cloud_name: ENV[ "CLOUDINARY_CLOUD_NAME" ] )
    image[ 'url' ]
  end

  def ocr_helper
    OcrSpace::Resource.new( apikey: ENV[ "OCR_HELPER_API_KEY" ] )
  end
end
