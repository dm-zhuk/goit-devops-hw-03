output "jenkins_url" {
  value = "http://${helm_release.jenkins.status.load_balancer[0].ingress[0].hostname}"
}

output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  value = helm_release.jenkins.namespace
}