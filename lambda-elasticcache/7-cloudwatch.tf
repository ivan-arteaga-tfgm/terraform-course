#----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "cloudwatch-lambda" {
  name              = "/aws/lambda/lambdaelasticache"
  retention_in_days = 14
  
  tags  = {
    Name =  "${local.default_name}-cloudwatch-lambda-cache"
  }
}
#----------------------------------------------------------------------------------------------