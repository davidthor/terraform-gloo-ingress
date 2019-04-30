apiVersion: gloo.solo.io/v1
kind: Settings
metadata:
  name: default
  namespace: ${NAMESPACE}
spec:
  bindAddr: 0.0.0.0:${GLOO_DEPLOYMENT_XDS_PORT}
  discoveryNamespace: ${NAMESPACE}
  kubernetesArtifactSource: {}
  kubernetesConfigSource: {}
  kubernetesSecretSource: {}
  refreshRate: 60s
