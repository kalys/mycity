require 'import'

module MyCity
  module Repositories
    class ImageRepository
      include WebApp::Import[
        'relations.images.relation'
      ]

      def save(image)
        image.save
      end
    end
  end
end
