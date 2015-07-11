## Setting up AWS via CLI

    $ aws configure
    AWS Access Key ID [None]: <my-aws-access-key-id>
    AWS Secret Access Key [None]: <my-aws-secret-access-key>
    Default region name [None]: us-west-1
    Default output format [None]: table

## Core Track Assignment 03

* Create a security group that allows ssh access

      $ aws ec2 create-security-group --group-name AWSClassSecurityGroup --description 'AWS Class Security Group'
      $ aws ec2 authorize-security-group-ingress --group-name AWSClassSecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0

* Create a key/pair that is used for ssh access

      $ aws ec2 create-key-pair --key-name AWSClassKeyPair

* Create two Amazon Linux Micro instancs in the us-west-1 region

      $ aws ec2 run-instances --image-id ami-a540a5e1 --count 2 --instance-type t2.micro --key-name AWSClassKeyPair --security-groups AWSClassSecurityGroup

* After both instances are launched -- print out information about these two running instances

      $ aws ec2 describe-instances --instance-ids i-43dfa481 i-46dfa484

* Next, terminate both instances

      # $ aws ec2 stop-instances --instance-ids i-43dfa481 i-46dfa484
      $ aws ec2 terminate-instances --instance-ids i-43dfa481 i-46dfa484

### Output of commands

    $ aws ec2 create-key-pair --key-name AWSClassKeyPair
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          CreateKeyPair                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
    +----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    |  KeyFingerprint|  16:82:1c:a9:97:d9:87:8b:10:a7:01:e8:c1:20:63:52:cd:91:ad:50                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
    |  KeyMaterial   |  -----BEGIN RSA PRIVATE KEY-----
    8E3AfsafIg7K7Bn4Dr7YgbQynQ9AqR0G1KfDpRK7EqF6E9MRMdcKX19QICQQhSAD50W14CQjSRX6
    ODZqMEdQOVlvNEhKczR5ZUw1L0pUc0xjekNWTFNCZkMvc3Z2MWFnVWNGdk5VcWp3SlVVQ2dZRUE0
    ebbONrXHrhpuE46ebc6bUKAHf+Q9BLeDGFDuboS6fuiHsK7JZX/apuVIm6miivImhhA3ty9vNPH0
    eOahUKKKRHvcRiRJRqUE31BhwYrWPyj3gkiD8RS158xAiobVJSj+68aq6j1sHEvYnlRpJRErj/3z
    yuV2RNTwPlMA3yKY/bag4GZ6p/FHCp70kh21sKiKkAJrGBWhqNi3FgxLGjrbprGV/KtEZ6bOK/7h
    NmtGb1VrcXppQmp0MlZyTFVadAYkpQZWlDbkdQM2h1bVdUZHNBTQeEFxanNjTWNrWTNSNjNmcVM4
    RzRkelprVXZ4MXEyZTFkMDZIUGp4NGpZSHYvNXlyQ1RvZG00bVhianRNRjhuOGZ2aEFaWVFUZDFI
    AXTQRKkTz0fwd3OUwS0ApDB6Y7lRnQbRHpL+Tt8pkuSgR/7fiHM4tKcKpjcybMFd70dh92zsXpgL
    o72mYgt51Nc5Wr9zm0kCDnFmel8D170BwricCKr8mIoTD7lJ6sPxOYFGKNkyu2IZ+Gflx6hctpgI
    qkn3/L9pvlkfaPrGBADiuX/Qn6ECgYEA6hjmDIiTBM4rWHPZLOn/owmW2iDv2wSeehKt/sAcg89q
    G4dzZkUvx1q2e1d06HPjx4jYHv/5yrCTodm4mXbjtMF8n8fvhAZYQTd1Hg9G0pfRG48paPgsQnQH
    gzcbLnCCt+yPHT/xTPJ3YVKyoHuGoZVy3j/vHy2PLS2gHCYr7GT4Ohg6mbJPeiCnGP3humWTdsAM
    M6my37RkraCp8HzRBWQJoRiWtOT1nUvx7AYdDQ3xnFmFaLvrtTJri/fTHJZgAm/pFIi9CUDs1/cC
    SVA1cDQxSVBFdGtwSlMvbC9vRlpjanJ4Zmk5S0pnUDRzMFZPVFFYYnNkOXNQdjdNSkhXaVRDeTBi
    Fg8j+PeCldBZWHZFBEIREsGLW6+8G/kl15D2bDZudfbhEI3DSpzokwIDAQABAoIBADf/E4iHrzNT
    UTVFVVhDdzBubGdPMTNnNWpMaDlWNS9XRU9MMXlBVUFQQkJ2V05nZ00yeDhod0tCZ1FETU9ZUzdD
    uokBikR2aEWceJEYStuToDccsuKTf4PXiYFePm929OatoBgEpeBdZVmnF2LJHTd+vZENRCeYFEV1
    G5YhOBzxOUURvgiovthPYSjuA/l3ogvreUXtzP+VdrjYOHTuWgPtkKxUucUzvELGWAzlMPKEdKdp
    Q5EUXCw0nlgO13g5jLh9V5/WEOL1yAUAPBBvWNggM2x8hwKBgQDMOYS7CxAqjscMckY3R63fqS8s
    61BkQ8iJBFE81FYgOZCNHrPXCm7LtU/VpevoZVlakGwz1ilMprMNCqYGtJJKpZsxd4+lI9zXTwGq
    7cPkGvJ6QJR0ItDUzOxEhUrN4OdNlY4MBvFonZ2Jkx0HFpHF94tQlIKq+abof61F6DNcqA==
    -----END RSA PRIVATE KEY-----   |
    |  KeyName       |  AWSClassKeyPair                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
    +----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

---

    $ aws ec2 create-security-group --group-name AWSClassSecurityGroup --description 'AWS Class Security Group'
    ----------------------------
    |    CreateSecurityGroup   |
    +----------+---------------+
    |  GroupId |  sg-71fb7527  |
    +----------+---------------+

---

    $ aws ec2 run-instances --image-id ami-a540a5e1 --count 2 --instance-type t2.micro --key-name AWSClassKeyPair --security-groups AWSClassSecurityGroup        255↵
    ---------------------------------------------------------------------------
    |                              RunInstances                               |
    +-------------------------------------+-----------------------------------+
    |  OwnerId                            |  708963061404                     |
    |  ReservationId                      |  r-000111c2                       |
    +-------------------------------------+-----------------------------------+
    ||                               Instances                               ||
    |+------------------------+----------------------------------------------+|
    ||  AmiLaunchIndex        |  1                                           ||
    ||  Architecture          |  x86_64                                      ||
    ||  ClientToken           |                                              ||
    ||  EbsOptimized          |  False                                       ||
    ||  Hypervisor            |  xen                                         ||
    ||  ImageId               |  ami-a540a5e1                                ||
    ||  InstanceId            |  i-43dfa481                                  ||
    ||  InstanceType          |  t2.micro                                    ||
    ||  KeyName               |  AWSClassKeyPair                             ||
    ||  LaunchTime            |  2015-06-27T23:35:14.000Z                    ||
    ||  PrivateDnsName        |  ip-172-24-16-91.us-west-1.compute.internal  ||
    ||  PrivateIpAddress      |  172.24.16.91                                ||
    ||  PublicDnsName         |                                              ||
    ||  RootDeviceName        |  /dev/sda1                                   ||
    ||  RootDeviceType        |  ebs                                         ||
    ||  SourceDestCheck       |  True                                        ||
    ||  StateTransitionReason |                                              ||
    ||  SubnetId              |  subnet-d4d7301d                             ||
    ||  VirtualizationType    |  hvm                                         ||
    ||  VpcId                 |  vpc-6ff7290a                                ||
    |+------------------------+----------------------------------------------+|
    |||                             Monitoring                              |||
    ||+----------------------------+----------------------------------------+||
    |||  State                     |  disabled                              |||
    ||+----------------------------+----------------------------------------+||
    |||                          NetworkInterfaces                          |||
    ||+---------------------+-----------------------------------------------+||
    |||  Description        |                                               |||
    |||  MacAddress         |  06:c3:1e:24:cd:45                            |||
    |||  NetworkInterfaceId |  eni-a85f1cf5                                 |||
    |||  OwnerId            |  708963061413                                 |||
    |||  PrivateDnsName     |  ip-172-24-16-91.us-west-1.compute.internal   |||
    |||  PrivateIpAddress   |  172.24.16.91                                 |||
    |||  SourceDestCheck    |  True                                         |||
    |||  Status             |  in-use                                       |||
    |||  SubnetId           |  subnet-d9d7298d                              |||
    |||  VpcId              |  vpc-6ff7293a                                 |||
    ||+---------------------+-----------------------------------------------+||
    ||||                            Attachment                             ||||
    |||+-----------------------------+-------------------------------------+|||
    ||||  AttachTime                 |  2015-06-27T23:35:14.000Z           ||||
    ||||  AttachmentId               |  eni-attach-e3873bb0                ||||
    ||||  DeleteOnTermination        |  True                               ||||
    ||||  DeviceIndex                |  0                                  ||||
    ||||  Status                     |  attaching                          ||||
    |||+-----------------------------+-------------------------------------+|||
    ||||                              Groups                               ||||
    |||+----------------------+--------------------------------------------+|||
    ||||  GroupId             |  sg-71fb7535                               ||||
    ||||  GroupName           |  AWSClassSecurityGroup                     ||||
    |||+----------------------+--------------------------------------------+|||
    ||||                        PrivateIpAddresses                         ||||
    |||+-------------------+-----------------------------------------------+|||
    ||||  Primary          |  True                                         ||||
    ||||  PrivateDnsName   |  ip-172-24-16-91.us-west-1.compute.internal   ||||
    ||||  PrivateIpAddress |  172.24.16.91                                 ||||
    |||+-------------------+-----------------------------------------------+|||
    |||                              Placement                              |||
    ||+----------------------------------------+----------------------------+||
    |||  AvailabilityZone                      |  us-west-1a                |||
    |||  GroupName                             |                            |||
    |||  Tenancy                               |  default                   |||
    ||+----------------------------------------+----------------------------+||
    |||                           SecurityGroups                            |||
    ||+----------------------+----------------------------------------------+||
    |||  GroupId             |  sg-71fb7530                                 |||
    |||  GroupName           |  AWSClassSecurityGroup                       |||
    ||+----------------------+----------------------------------------------+||
    |||                                State                                |||
    ||+----------------------------+----------------------------------------+||
    |||  Code                      |  0                                     |||
    |||  Name                      |  pending                               |||
    ||+----------------------------+----------------------------------------+||
    |||                             StateReason                             |||
    ||+---------------------------------+-----------------------------------+||
    |||  Code                           |  pending                          |||
    |||  Message                        |  pending                          |||
    ||+---------------------------------+-----------------------------------+||
    ||                               Instances                               ||
    |+------------------------+----------------------------------------------+|
    ||  AmiLaunchIndex        |  0                                           ||
    ||  Architecture          |  x86_64                                      ||
    ||  ClientToken           |                                              ||
    ||  EbsOptimized          |  False                                       ||
    ||  Hypervisor            |  xen                                         ||
    ||  ImageId               |  ami-a540a5e1                                ||
    ||  InstanceId            |  i-46dfa484                                  ||
    ||  InstanceType          |  t2.micro                                    ||
    ||  KeyName               |  AWSClassKeyPair                             ||
    ||  LaunchTime            |  2015-06-27T23:35:14.000Z                    ||
    ||  PrivateDnsName        |  ip-172-24-16-91.us-west-1.compute.internal  ||
    ||  PrivateIpAddress      |  172.24.16.91                                ||
    ||  PublicDnsName         |                                              ||
    ||  RootDeviceName        |  /dev/sda1                                   ||
    ||  RootDeviceType        |  ebs                                         ||
    ||  SourceDestCheck       |  True                                        ||
    ||  StateTransitionReason |                                              ||
    ||  SubnetId              |  subnet-d4d7306d                             ||
    ||  VirtualizationType    |  hvm                                         ||
    ||  VpcId                 |  vpc-6ff7300a                                ||
    |+------------------------+----------------------------------------------+|
    |||                             Monitoring                              |||
    ||+----------------------------+----------------------------------------+||
    |||  State                     |  disabled                              |||
    ||+----------------------------+----------------------------------------+||
    |||                          NetworkInterfaces                          |||
    ||+---------------------+-----------------------------------------------+||
    |||  Description        |                                               |||
    |||  MacAddress         |  06:be:dc:ac:61:c4                            |||
    |||  NetworkInterfaceId |  eni-a95f1cf1                                 |||
    |||  OwnerId            |  799963011196                                 |||
    |||  PrivateDnsName     |  ip-172-24-16-91.us-west-1.compute.internal   |||
    |||  PrivateIpAddress   |  172.24.16.91                                 |||
    |||  SourceDestCheck    |  True                                         |||
    |||  Status             |  in-use                                       |||
    |||  SubnetId           |  subnet-d13d298d                              |||
    |||  VpcId              |  vpc-6ff7300a                                 |||
    ||+---------------------+-----------------------------------------------+||
    ||||                            Attachment                             ||||
    |||+-----------------------------+-------------------------------------+|||
    ||||  AttachTime                 |  2015-06-27T23:35:14.000Z           ||||
    ||||  AttachmentId               |  eni-attach-e2873bb1                ||||
    ||||  DeleteOnTermination        |  True                               ||||
    ||||  DeviceIndex                |  0                                  ||||
    ||||  Status                     |  attaching                          ||||
    |||+-----------------------------+-------------------------------------+|||
    ||||                              Groups                               ||||
    |||+----------------------+--------------------------------------------+|||
    ||||  GroupId             |  sg-71fb7514                               ||||
    ||||  GroupName           |  AWSClassSecurityGroup                     ||||
    |||+----------------------+--------------------------------------------+|||
    ||||                        PrivateIpAddresses                         ||||
    |||+-------------------+-----------------------------------------------+|||
    ||||  Primary          |  True                                         ||||
    ||||  PrivateDnsName   |  ip-172-24-16-91.us-west-1.compute.internal   ||||
    ||||  PrivateIpAddress |  172.24.16.91                                 ||||
    |||+-------------------+-----------------------------------------------+|||
    |||                              Placement                              |||
    ||+----------------------------------------+----------------------------+||
    |||  AvailabilityZone                      |  us-west-1a                |||
    |||  GroupName                             |                            |||
    |||  Tenancy                               |  default                   |||
    ||+----------------------------------------+----------------------------+||
    |||                           SecurityGroups                            |||
    ||+----------------------+----------------------------------------------+||
    |||  GroupId             |  sg-71fb8534                                 |||
    |||  GroupName           |  AWSClassSecurityGroup                       |||
    ||+----------------------+----------------------------------------------+||
    |||                                State                                |||
    ||+----------------------------+----------------------------------------+||
    |||  Code                      |  0                                     |||
    |||  Name                      |  pending                               |||
    ||+----------------------------+----------------------------------------+||
    |||                             StateReason                             |||
    ||+---------------------------------+-----------------------------------+||
    |||  Code                           |  pending                          |||
    |||  Message                        |  pending                          |||
    ||+---------------------------------+-----------------------------------+||

---

    $ aws ec2 terminate-instances --instance-ids i-43dfa481 i-46dfa484
    -------------------------------
    |     TerminateInstances      |
    +-----------------------------+
    ||   TerminatingInstances    ||
    |+---------------------------+|
    ||        InstanceId         ||
    |+---------------------------+|
    ||  i-46dfa484               ||
    |+---------------------------+|
    |||      CurrentState       |||
    ||+-------+-----------------+||
    ||| Code  |      Name       |||
    ||+-------+-----------------+||
    |||  32   |  shutting-down  |||
    ||+-------+-----------------+||
    |||      PreviousState      |||
    ||+---------+---------------+||
    |||  Code   |     Name      |||
    ||+---------+---------------+||
    |||  16     |  running      |||
    ||+---------+---------------+||
    ||   TerminatingInstances    ||
    |+---------------------------+|
    ||        InstanceId         ||
    |+---------------------------+|
    ||  i-43dfa481               ||
    |+---------------------------+|
    |||      CurrentState       |||
    ||+-------+-----------------+||
    ||| Code  |      Name       |||
    ||+-------+-----------------+||
    |||  32   |  shutting-down  |||
    ||+-------+-----------------+||
    |||      PreviousState      |||
    ||+---------+---------------+||
    |||  Code   |     Name      |||
    ||+---------+---------------+||
    |||  16     |  running      |||
    ||+---------+---------------+||

