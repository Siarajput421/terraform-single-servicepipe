

# CODEBUILD
resource "aws_codebuild_project" "repo-project" {
  name         = "${var.build_project}"
  service_role = "${aws_iam_role.codebuild-role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/Siarajput421/Dockerpipe1.git"

    git_clone_depth = 1
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
}
# S3 BUCKET FOR ARTIFACTORY_STORE
resource "aws_s3_bucket" "bucket-artifacttt1" {
  bucket = "nhnbgvfdds6333"
  force_destroy = true
}

# CODEPIPELINE
resource "aws_codepipeline" "pipeline-1" {
  name     = "pipeline1"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "${aws_s3_bucket.bucket-artifacttt1.bucket}"
    type     = "S3"
  }
  # SOURCE
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "Siarajput421"
        Repo       = var.repo_name
        Branch     = var.branch_name
        OAuthToken = "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"
      }
    }
  }
  # BUILD
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "${var.build_project}"
      }
    }
  }
  # DEPLOY
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName = "clusterDev"
        ServiceName = "golang-Service-1"
        FileName    = "imagedefinitions-1.json"
      }
    }
  }
}