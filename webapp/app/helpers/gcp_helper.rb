# frozen_string_literal: true

module GcpHelper
  require 'google/cloud/storage'

  # @gcs_storage ||= Google::Cloud::Storage.new

  def gcp_bucket_listing(bucket_name, _sub_path = '', _limit = 10)
    # link_to "#{Category.emoji}#{category.cleaned_up}", category
    @gcs_storage ||= Google::Cloud::Storage.new
    bucket = @gcs_storage.bucket bucket_name, skip_lookup: true
    files = bucket.files
    ret = [] #   "🪣 bucket_name: #{bucket_name}"
    # ix=0
    files.all do |file|
      ret << file.name
    end
    ret
  end
end
