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

# Attach the combined policy to the role
resource "aws_iam_role_policy" "combined_policy" {
  name = "combined_policy"
  role = aws_iam_role.combined_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:*",
          "ecs:*",
          "s3:*",
          "eks:*",
          "lambda:*",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the role to an instance profile
resource "aws_iam_instance_profile" "combined_instance_profile" {
  name = "combined_instance_profile"
  role = aws_iam_role.combined_role.name
}
