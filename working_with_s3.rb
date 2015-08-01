#!/usr/bin/env ruby

=begin
1. Create at least 2 buckets in S3
2. Get filenames from the user for existing files – store these files on
   objects in the buckets you create
3. List all buckets and objects in the buckets
4. Get (download) the objects you stored in the Buckets
=end

require 'aws-sdk'
require 'json'

secrets = JSON.load(File.read('secrets.json'))
Aws.config.update({
  region: 'us-west-1',
  credentials: Aws::Credentials.new(secrets['AccessKeyId'], secrets['SecretAccessKey']),
})
s3 = Aws::S3::Client.new

# Create 2 buckets in S3
bucket_1 = { acl: 'private', bucket: 'me.weppler.myawsbucket.1' }
s3.create_bucket(bucket_1)
puts "Created bucket: #{bucket_1[:bucket]}"

bucket_2 = { acl: 'private', bucket: 'me.weppler.myawsbucket.2' }
s3.create_bucket(bucket_2)
puts "Created bucket: #{bucket_2[:bucket]}"

# Get filenames and store them on objects in new buckets
file_stream_1 = File.open(ARGV[0] || 'file_1.txt', 'r')
file_1 = { file: file_stream_1, key: File.basename(file_stream_1.path) }
upload_file_1 = {
  acl: 'private',
  body: file_1[:file],
  bucket: bucket_1[:bucket],
  key: file_1[:key]
}
s3.put_object(upload_file_1)
file_stream_1.close
puts "Uploaded file: #{file_1[:key]} to bucket: #{bucket_1[:bucket]}"

file_stream_2 = File.open(ARGV[1] || 'file_2.txt', 'r')
file_2 = { file: file_stream_2, key: File.basename(file_stream_2.path) }
upload_file_2 = {
  acl: 'private',
  body: file_2[:file],
  bucket: bucket_2[:bucket],
  key: file_2[:key]
}
s3.put_object(upload_file_2)
file_stream_2.close
puts "Uploaded file: #{file_2[:key]} to bucket: #{bucket_2[:bucket]}"

puts "Displaying information about S3 Buckets & Objects"
# 3. List all buckets and objects in the buckets
s3.list_buckets.buckets.each do |bucket|
  puts "Bucket: #{bucket.name}, created_at: #{bucket.creation_date}"
  s3.list_objects(bucket: bucket.name, max_keys: 2).contents.each do |object|
    puts "\tObject: #{object.key}, updated_at: #{object.last_modified}"
  end
end

# 4. Get (download) the objects you stored in the Buckets
download_file_1 = { name: 'downloaded_file_1.txt' }
download_file_stream_1 = s3.get_object(bucket: bucket_1[:bucket], key: file_1[:key])
File.open(download_file_1[:name], 'w') do |file|
  file.write download_file_stream_1.body.read
end
puts <<MSG
Downloaded file: #{file_1[:key]}
From bucket: #{bucket_1[:bucket]}
As #{download_file_1[:name]}
MSG

download_file_2 = { name: 'downloaded_file_2.txt' }
download_file_stream_2 = s3.get_object(bucket: bucket_2[:bucket], key: file_2[:key])
File.open(download_file_2[:name], 'w') do |file|
  file.write download_file_stream_2.body.read
end
puts <<MSG
Downloaded file: #{file_2[:key]}
From bucket: #{bucket_2[:bucket]}
As #{download_file_2[:name]}
MSG

# Clean up by deleting objects in buckets then buckets themselves
s3.delete_object({ bucket: bucket_1[:bucket], key: file_1[:key] })
puts "Deleted object: #{file_1[:key]} in bucket: #{bucket_1[:bucket]}"
s3.delete_object({ bucket: bucket_2[:bucket], key: file_2[:key] })
puts "Deleted object: #{file_2[:key]} in bucket: #{bucket_2[:bucket]}"
s3.delete_bucket({ bucket: bucket_1[:bucket] })
puts "Deleted bucket: #{bucket_1[:bucket]}"
s3.delete_bucket({ bucket: bucket_2[:bucket] })
puts "Deleted bucket: #{bucket_2[:bucket]}"

# ---

require 'test/unit'
include Test::Unit::Assertions

uploaded_file_1 = ''
File.open(file_1[:key], 'r') do |file|
  uploaded_file_1 = file.read
end
downloaded_file_1 = ''
File.open(download_file_1[:name], 'r') do |file|
  downloaded_file_1 = file.read
end
assertion_1 = assert_equal uploaded_file_1, downloaded_file_1
if assertion_1.nil?
  puts "Files: #{file_1[:key]} & #{download_file_1[:name]} are identical"
end

uploaded_file_2 = ''
File.open(file_2[:key], 'r') do |file|
  uploaded_file_2 = file.read
end
downloaded_file_2 = ''
File.open(download_file_2[:name], 'r') do |file|
  downloaded_file_2 = file.read
end
assertion_2 =  assert_equal uploaded_file_2, downloaded_file_2
if assertion_2.nil?
  puts "Files: #{file_2[:key]} & #{download_file_2[:name]} are identical"
end

File.delete(download_file_1[:name])
puts "Deleted downloaded file: #{download_file_1[:name]}"
File.delete(download_file_2[:name])
puts "Deleted downloaded file: #{download_file_2[:name]}"

exit 0

