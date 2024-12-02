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

helm install vmtemplate krateo/compositiondefinition -n vmtemplate-system --create-namespace -f values.yaml
```
