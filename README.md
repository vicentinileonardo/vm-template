# vm-template

## Setup

```bash
cat <<EOL > values.yaml
chart:
  # when helm is in a registry
  url: https://leonardovicentini.com/helm-charts/charts
  version: 1.0.0
  repo: vm-template
card:
  icon: fa-cubes
  title: VmTemplate
  color: green
  content: This is a card for VmTemplate
EOL

helm repo add krateo https://charts.krateo.io

helm repo update krateo

helm install vmtemplate krateo/compositiondefinition -n greenops --create-namespace -f values.yaml

kubectl wait compositiondefinition vmtemplate --for condition=Ready=True --namespace greenops --timeout=300s
```

test patch before k8s mutating webhook

