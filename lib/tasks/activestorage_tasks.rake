# frozen_string_literal: true

namespace :activestorage do
  task reanalyse: :environment do
    desc "Re-analyses all attachments"
    batch_size = ENV["BATCH_SIZE"]&.to_i || 1000

    ActiveStorage::Attachment
      .joins(:blob)
      .where("content_type LIKE ?", "image/%")
      .find_each(batch_size: batch_size, &:analyze)
  end
end
