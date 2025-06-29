# frozen_string_literal: true

##
# Helper module to allow use of blurhash for nicer image loading.
# Taken from the below, as that gem does not support versions of rails prior to 7.1
# https://github.com/avo-hq/active_storage-blurhash/blob/main/app/helpers/blurhash_image_helper.rb (MIT Licensed)
module BlurhashHelper
  ##
  # Creates an image tag with automatic blurhash load preview
  # @param image [String, ActiveStorage::Blob, ActiveStorage::Attached::One, ActiveStorage::VariantWithRecord]
  # @param options [Hash] any attributes to add to the image tag
  def blurhash_image_tag(image, options = {})
    blob = blob_from_image(image)
    blurhash = blob&.metadata&.fetch("blurhash", nil)

    ## !! converts to boolean
    if !!blurhash
      wrapper_class = options.fetch(:class, "w-100 h-100")
      canvas_class = options.fetch(:class, nil)
      tag.div(
        class: wrapper_class,
        data: { blurhash: blurhash, controller: "blurhash" },
      ) do
        image_tag(
          image,
          options,
        ) + tag.canvas(
          style: "position: absolute; inset: 0; transition-property: opacity; " \
            "transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1); " \
            "transition-duration: 150ms;",
          class: canvas_class,
        )
      end
    else
      image_tag(image, options)
    end
  rescue ActionController::RoutingError
    # If image passed is a URL that is not in this application, use regular image tag instead
    image_tag(image, options)
  end

  private

  ##
  # Gets a blob object from an image, so that we can check the metadata for blurhash presence
  def blob_from_image(image)
    case image
    when String
      # if a URL is passed, we have to manually re-hydrate the blob from it
      path_parameters = Rails.application.routes.recognize_path(image)
      ActiveStorage::Blob.find_signed!(path_parameters[:signed_blob_id] || path_parameters[:signed_id])
    when ActiveStorage::Blob
      image
    when ActiveStorage::Attached::One, ActiveStorage::VariantWithRecord
      image.blob
    end
  end
end
