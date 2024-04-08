
# https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-storage/samples/storage_upload_from_memory.rb

def gcs_upload_file_from_memory storage:, bucket_name:, file_name:, file_content:
  # [START storage_file_upload_from_memory]
  # The ID of your GCS bucket
  # bucket_name = "your-unique-bucket-name"

  # The ID of your GCS object
  # file_name = "your-file-name"

  # The contents to upload to your file
  # file_content = "Hello, world!"

  require "google/cloud/storage"

  storage = Google::Cloud::Storage.new if storage.nil?
  bucket  = storage.bucket bucket_name, skip_lookup: true

  file = bucket.create_file StringIO.new(file_content), file_name

  puts "Uploaded file #{file.name} to bucket #{bucket_name} with content: #{file_content}"
  # [END storage_file_upload_from_memory]
end



# copied from samples: https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-storage/samples/storage_gcs_copy_file.rb
def gcs_copy_file source_bucket_name:, source_file_name:, destination_bucket_name:, destination_file_name:
  # The ID of the bucket the original object is in
  # source_bucket_name = "source-bucket-name"

  # The ID of the GCS object to copy
  # source_file_name = "source-file-name"

  # The ID of the bucket to copy the object to
  # destination_bucket_name = "destination-bucket-name"

  # The ID of the new GCS object
  # destination_file_name = "destination-file-name"

  require "google/cloud/storage"

  storage = Google::Cloud::Storage.new
  bucket  = storage.bucket source_bucket_name, skip_lookup: true
  file    = bucket.file source_file_name

  destination_bucket = storage.bucket destination_bucket_name
  destination_file   = file.copy destination_bucket.name, destination_file_name

  puts "#{file.name} in #{bucket.name} copied to " \
       "#{destination_file.name} in #{destination_bucket.name}"
end
