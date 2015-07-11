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

# Create at 2 buckets in S3
bucket_1 = { acl: 'private', bucket: 'me.weppler.myawsbucket.1' }
bucket_2 = { acl: 'private', bucket: 'me.weppler.myawsbucket.2' }
s3.create_bucket(bucket_1)
s3.create_bucket(bucket_2)

# Get filenames and store them on objects in new buckets
upload_1 = File.open(ARGV[0] || 'file_1.txt', 'r')
file_1 = { file: upload_1, key: :file_1 }
put_file_1 = { acl: 'private', body: file_1[:file], bucket: bucket_1[:bucket], key: file_1[:key] }
s3.put_object(put_file_1)
upload_1.close

upload_2 = File.open(ARGV[1] || 'file_2.txt', 'r')
file_2 = { file: upload_2, key: :file_2 }
put_file_2 = { acl: 'private', body: file_2[:file], bucket: bucket_2[:bucket], key: file_2[:key] }
s3.put_object(put_file_2)
upload_2.close

# 3. List all buckets and objects in the buckets
s3.list_buckets.buckets.each do |bucket|
  puts "Bucket: #{bucket.name}, created_at: #{bucket.creation_date}"
  s3.list_objects(bucket: bucket.name, max_keys: 2).contents.each do |object|
    puts "\tObject: #{object.key}, updated_at: #{object.last_modified}"
  end
end

# 4. Get (download) the objects you stored in the Buckets
download_1 = s3.get_object(bucket: bucket_1[:bucket], key: file_1[:key])
download_2 = s3.get_object(bucket: bucket_2[:bucket], key: file_2[:key])
File.open('download_1.txt', 'w') { |file| file.write download_1.body.read }
File.open('download_2.txt', 'w') { |file| file.write download_2.body.read }

# Clean up by deleting objects in buckets then buckets themselves
s3.delete_object({ bucket: bucket_1[:bucket], key: file_1[:key] })
s3.delete_object({ bucket: bucket_2[:bucket], key: file_2[:key] })
s3.delete_bucket({ bucket: bucket_1[:bucket] })
s3.delete_bucket({ bucket: bucket_2[:bucket] })
