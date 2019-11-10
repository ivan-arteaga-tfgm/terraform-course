#------------------------------------------------------
#shows the instance ip address
#ssh -i mykey ubuntu@aws_instance.example.public_ip
#install sudo apt-get install mysql-client
#mysql -u root -h  postgresdb.cfc8w0uxq929.eu-west-1.rds.amazonaws.com -p'myrandompassword44558'
#------------------------------------------------------
output "instance" {
  value = aws_instance.example.public_ip
}

#------------------------------------------------------
#show the rds endpoint 
#------------------------------------------------------
output "rds-master" {
  value = module.master.this_db_instance_endpoint
}
output "rds-replica" {
  value = module.replica.this_db_instance_endpoint
}
#output "rds" {
#  value = aws_db_instance.postgresdb.endpoint
#}

#------------------------------------------------------
