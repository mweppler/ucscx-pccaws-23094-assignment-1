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
require 'test/unit'
include Test::Unit::Assertions

aws_config = {}

users_aws_config_path = File.expand_path '~/.aws'
if Dir.exists? users_aws_config_path
  req_file_list = ["config", "credentials"]
  file_list = Dir.glob(users_aws_config_path + '/*').map { |f| File.basename f }
  req_file_list.keep_if { |conf_file| file_list }
  if ["config", "credentials"] == file_list
    aws_config = {}
    file_list.each do |file_name|
      File.open(File.join(users_aws_config_path, file_name), 'r') do |file|
        file_contents = file.readlines
        file_contents.delete_if { |line| line.match(/\[.*\]/) }
        aws_config[file_name] = file_contents.map { |line| line.chomp.split('=') }.inject({}) { |hash, values| hash[values[0].strip] = values[1].strip ; hash }
      end
    end
  end
end

if aws_config.empty?
  local_aws_secrets_file = 'aws_config.json'
  if local_aws_secrets_file
    aws_config = JSON.load(File.read(local_aws_secrets_file))
  end
end

Aws.config.update({
  region: aws_config['config']['region'],
  credentials: Aws::Credentials.new(
    aws_config['credentials']['aws_access_key_id'],
    aws_config['credentials']['aws_secret_access_key']
  ),
})
s3 = Aws::S3::Client.new
puts "Created S3 Instance"

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

# Assert files are identical

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

