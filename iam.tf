# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Create a combined IAM Role for EC2 with ECR, ECS, S3, EKS, and Lambda permissions
resource "aws_iam_role" "combined_role" {
  name = "combined_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the combined policy to the role with least privilege permissions
resource "aws_iam_role_policy" "combined_policy" {
  name = "combined_policy"
  role = aws_iam_role.combined_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ec2/*"
      }
    ]
  })
}

# Attach the role to an instance profile
resource "aws_iam_instance_profile" "combined_instance_profile" {
  name = "combined_instance_profile"
  role = aws_iam_role.combined_role.name
}