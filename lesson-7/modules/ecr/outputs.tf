output "ecr_repository_url" {
  description = "The full URL of the ECR repository (for docker push/pull)"
  value       = aws_ecr_repository.repo.repository_url
}