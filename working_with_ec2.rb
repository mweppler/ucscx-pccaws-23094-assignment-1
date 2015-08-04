#!/usr/bin/env ruby

=begin
1. Create a security group that allows ssh access
2. Create a key/pair that is used for ssh access
3. Create two Amazon Linux Micro instancs in the us-west-1 region
4. After both instances are launched -- print out information about these two running instances
5. Next, terminate both instances
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


