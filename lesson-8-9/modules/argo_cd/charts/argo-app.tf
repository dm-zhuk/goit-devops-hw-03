resource "kubernetes_manifest" "django_app" {
  manifest = yamldecode(<<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: django-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/dm-zhuk/goit-devops-hw-03.git
    targetRevision: lesson-8-9
    path: lesson-8-9/charts/django-app
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
  )

  depends_on = [helm_release.argo_cd]
}