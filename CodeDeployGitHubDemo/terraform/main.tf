#-----------------------------------------------------------------------
#resource "aws_instance" "instance" {
#  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
#  instance_type   = "${var.instance_type}"
#  subnet_id       = "${aws_subnet.my_vpc_subnet_public[0].id}"
#  #subnet_id       = "${aws_subnet.my_vpc_subnet_private[0].id}"
#  key_name        = "${aws_key_pair.mykey.key_name}"
#  user_data       = "${data.template_file.script.rendered}"
#  #change the security group to private by using different file
#  vpc_security_group_ids = ["${aws_security_group.my_security_group.id}","${aws_security_group.http_security_group.id}"]
#  iam_instance_profile         = "${aws_iam_role.EC2InstanceRole.name}"
#
#  root_block_device {
#      delete_on_termination = true
#      encrypted             = false
#      iops                  = 100
#      volume_size           = 10 
#      volume_type           = "gp2"
#  }
#
#  tags = {
#        Name             = "CodePipelineDemo"
#        Description      = "Codedeploy_EFS"
#        CodePipelineDemo = "CodePipelineDemo"
#      }
#  volume_tags = {
#          Name      = "Codedeploy_EFS_ROOT"
#          Terraform = "true"
#      }
#}
#
#-----------------------------------------------------------------------
resource "aws_efs_file_system" "efs" {
  creation_token   = "EFS Shared Data"
  #performance_mode = "generalPurpose"
  performance_mode = "maxIO"

  #The throughput, measured in MiB/s, that you want to provision
  #for the file system. Only applicable with throughput_mode set to
  #provisioned
 
  provisioned_throughput_in_mibps = 200 
  throughput_mode = "provisioned"

  tags = {
        Name = "EFS Shared Data"
  }
}

#-----------------------------------------------------------------------
resource "aws_efs_mount_target" "efs" {
    count = 3
    file_system_id  = "${aws_efs_file_system.efs.id}"
    #subnet_id       = "${aws_subnet.my_vpc_subnet_public[0].id}"
    subnet_id       = "${element(aws_subnet.my_vpc_subnet_public.*.id, count.index)}"
    security_groups = ["${aws_security_group.ingress-efs.id}"]


}

#-----------------------------------------------------------------------
data "template_file" "script" {
  template = "${file("script.tpl")}"
    vars = {
        efs_id = "${aws_efs_file_system.efs.id}"
  }
}
#-----------------------------------------------------------------------


