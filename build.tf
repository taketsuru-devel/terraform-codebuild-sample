resource "aws_s3_bucket" "output" {
    bucket = var.output_s3_bucket_name
}

resource "aws_codebuild_project" "this" {
  name = format("%s-build-project", var.project_name)
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "S3"
    location = aws_s3_bucket.output.bucket
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:3.0-20.08.14"
    type = "LINUX_CONTAINER"
  }
  source {
    location = var.github_repository_name
    type = "GITHUB"
    git_clone_depth = "1"
    git_submodules_config {
      fetch_submodules = "false"
    }
  }
}
