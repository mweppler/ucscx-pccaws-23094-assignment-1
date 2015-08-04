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
require 'pry'
require 'test/unit'
require 'time'
include Test::Unit::Assertions

aws_config = {}
log_entries = []

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

ec2 = Aws::EC2::Client.new
msg = "[#{Time.now}] [INFO] Instantiated EC2 Object"
log_entries << msg
puts msg

ec2_options = {
  'group' => {
    'group_name' => 'AWSClassSecurityGroup',
    'description' => 'AWS Class Security Group',
    'ip_protocol' => 'tcp',
    'from_port' => 22,
    'to_port' => 22,
    'cidr_ip' => '0.0.0.0/0'
  },
  'instance' => {
    'image_id' => 'ami-a540a5e1',
    'min_count' => 2,
    'max_count' => 2,
    'instance_type' => 't2.micro'
  },
  'key' => {
    'key_name' => 'AWSClassKeyPair'
  }
}

ec2_security_group = ec2.create_security_group({
  group_name: ec2_options['group']['group_name'],
  description: ec2_options['group']['description']
})
ec2_group_id = ec2_security_group.group_id
msg = "[#{Time.now}] [INFO] Created EC2 Security Group - Group Name: #{ec2_options['group']['group_name']}, Description: #{ec2_options['group']['description']}, Group ID: #{ec2_group_id}"
log_entries << msg
puts msg

#ec2_security_groups = ec2.describe_security_groups({
  #group_names: [ec2_options['group']['group_name']]
#})
#ec2_group_id = ec2_security_groups.security_groups[0].group_id

ec2.authorize_security_group_ingress({
  group_name: ec2_options['group']['group_name'],
  group_id: ec2_group_id,
  ip_protocol: ec2_options['group']['ip_protocol'],
  from_port: ec2_options['group']['from_port'],
  to_port: ec2_options['group']['to_port'],
  cidr_ip: ec2_options['group']['cidr_ip']
})
msg = "[#{Time.now}] [INFO] Authorized EC2 Security Group Ingress - Group Name: #{ec2_options['group']['group_name']}, Group ID: #{ec2_group_id}, IP Protocol: #{ec2_options['group']['ip_protocol']}, Port: #{ec2_options['group']['from_port']}-#{ec2_options['group']['to_port']}, CIDR IP: #{ec2_options['group']['cidr_ip']}"
log_entries << msg
puts msg

ec2_key_pair = ec2.create_key_pair({
  key_name: ec2_options['key']['key_name']
})
msg = "[#{Time.now}] [INFO] Created EC2 Key Pair - Key Name: #{ec2_options['key']['key_name']}, Key Fingerprint: #{ec2_key_pair.key_fingerprint}, Key Material: #{ec2_key_pair.key_material}"
log_entries << msg
puts msg

#ec2_key_pairs = ec2.describe_key_pairs({
  #key_names: [ec2_options['key']['key_name']]
#})
#ec2_key_pairs.key_pairs[0]
#ec2_key_pairs.key_pairs[0].key_name
#ec2_key_pairs.key_pairs[0].key_fingerprint

ec2_instances = ec2.run_instances({
  image_id: ec2_options['instance']['image_id'], # required
  min_count: ec2_options['instance']['min_count'], # required
  max_count: ec2_options['instance']['max_count'], # required
  key_name: ec2_options['key']['key_name'],
  instance_type: ec2_options['instance']['instance_type'],
  security_groups: [ec2_options['group']['group_name']]
})
ec2_instances.instances.each do |instance|
  msg = "[#{Time.now}] [INFO] Created EC2 Instance - Image ID: #{ec2_options['instance']['image_id']}, Instance Type: #{ec2_options['instance']['instance_type']}, Key Name: #{ec2_options['key']['key_name']}, Group Name: #{ec2_options['group']['group_name']}, Instance ID: #{instance.instance_id}"
  log_entries << msg
  puts msg
  #instance.network_interfaces.each { |inet| inet. }
  #inet.mac_address
  #inet.private_ip_address
  #inet.private_dns_name
end
instance_ids = ec2_instances.instances.map { |instance| instance.instance_id }

loop do
  ec2_instance_updates = ec2.describe_instances({
    instance_ids: instance_ids
  })
  instances = ec2_instance_updates.reservations.map { |reservation| reservation.instances }.flatten(1)
  instances.delete_if { |instance| instance.state.name == 'running' }
  break if instances.empty?
  sleep 3
end

#ec2.start_instances({
  #instance_ids: instance_ids # required
#})
#ec2_instances.instances.each do |instance|
  #msg = "[#{Time.now}] [INFO] Starting EC2 Instance - Instance ID: #{instance.instance_id}"
  #log_entries << msg
  #puts msg
#end

# Clean up

ec2.stop_instances({
  instance_ids: instance_ids, # required
  force: true
})
ec2_instances.instances.each do |instance|
  msg = "[#{Time.now}] [INFO] Stopping EC2 Instance - Instance ID: #{instance.instance_id}"
  log_entries << msg
  puts msg
end

ec2.terminate_instances({
  instance_ids: instance_ids # required
})
ec2_instances.instances.each do |instance|
  msg = "[#{Time.now}] [INFO] Terminating EC2 Instance - Instance ID: #{instance.instance_id}"
  log_entries << msg
  puts msg
end

loop do
  ec2_instance_updates = ec2.describe_instances({
    instance_ids: instance_ids
  })
  instances = ec2_instance_updates.reservations.map { |reservation| reservation.instances }.flatten(1)
  instances.delete_if { |instance| instance.state.name == 'terminated' }
  break if instances.empty?
  sleep 3
end

ec2.delete_key_pair({
  key_name: ec2_options['key']['key_name']
})
msg = "[#{Time.now}] [INFO] Deleted EC2 Key Pair - Key Name: #{ec2_options['key']['key_name']}"
log_entries << msg
puts msg

ec2.revoke_security_group_ingress({
  group_name: ec2_options['group']['group_name'],
  group_id: ec2_group_id,
  ip_protocol: ec2_options['group']['ip_protocol'],
  from_port: ec2_options['group']['from_port'],
  to_port: ec2_options['group']['to_port'],
  cidr_ip: ec2_options['group']['cidr_ip']
})
msg = "[#{Time.now}] [INFO] Revoked EC2 Security Group Ingress - Group Name: #{ec2_options['group']['group_name']}, Group ID: #{ec2_group_id}"
log_entries << msg
puts msg

ec2.delete_security_group({
  group_name: ec2_options['group']['group_name'],
  group_id: ec2_group_id
})
msg = "[#{Time.now}] [INFO] Deleted EC2 Security Group - Group Name: #{ec2_options['group']['group_name']}, Group ID: #{ec2_group_id}"
log_entries << msg
puts msg

File.open(File.join(File.dirname(File.expand_path(__FILE__)), 'ec2-run.log'), 'w') do |file|
  log_entries.each do |entry|
    file.puts entry
  end
end

exit 0

