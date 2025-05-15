# frozen_string_literal: true

require "blurhash"

module ActiveStorageExtensions
  module Blurhash
    ##
    # Most of the credit for this goes to the active_storage-blurhash gem
    # https://github.com/avo-hq/active_storage-blurhash/blob/main/lib/active_storage/blurhash/analyzing.rb
    # - MIT Licenced
    # However, that is only available for rails 7.1 and above, so it has been re-implemented here
    class Analyser < ActiveStorage::Analyzer::ImageAnalyzer::Vips
      def metadata
        read_image do |image|
          build_thumbnail_for(image)
          super.merge(blurhash)
        end
      end

      def blurhash
        {
          blurhash: ::Blurhash.encode(
            @thumbnail.width,
            @thumbnail.height,
            @thumbnail.to_a.flatten,
          ),
        }
      end

      ##
      # https://github.com/avo-hq/active_storage-blurhash/blob/main/lib/active_storage/blurhash/thumbnail/vips.rb
      # MIT Licenced
      def build_thumbnail_for(image)
        @thumbnail = ::Vips::Image.new_from_file(
          ::ImageProcessing::Vips.source(image.filename).resize_to_limit(200, 200).call.path,
        )

        @thumbnail = case @thumbnail.bands
        when 1
          @thumbnail.bandjoin(Array.new(3 - @thumbnail.bands, @thumbnail))
        when 2
          @thumbnail.bandjoin(@thumbnail.extract_band(0))
        when 3
          @thumbnail
        else
          @thumbnail&.extract_band(0, n: 3)
        end
      end
    end
  end
end
