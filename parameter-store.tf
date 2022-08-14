# resource "aws_ssm_parameter" "cgw-csr1000v-1a" {
#   name  = "/cgw/csr1000v-1a"
#   type  = "String"
#   value = aws_eip.EipForCiscoGw1a.public_ip
# }

# resource "aws_ssm_parameter" "cgw-csr1000v-1c" {
#   name  = "/cgw/csr1000v-1c"
#   type  = "String"
#   value = aws_eip.EipForCiscoGw1c.public_ip
# }


# #
# ## IAM policy and roles for the parameters
# #
# resource "aws_iam_policy" "onprem-eip" {
#   name        = "onprem-eip-policy"
#   path        = "/"
#   description = "Cisco CGW policy for EIP parameters"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ssm:GetParameterHistory",
#                 "ssm:GetParametersByPath",
#                 "ssm:GetParameters",
#                 "ssm:GetParameter"
#             ],
#             "Resource": "arn:aws:ssm:sa-east-1:566790882439:parameter/cgw/*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": "ssm:DescribeParameters",
#             "Resource": "*"
#         }
#     ]
# })
# }