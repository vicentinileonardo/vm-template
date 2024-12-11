# vm-template

## Setup

### Krateo 2.2

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

helm install vmtemplate krateo/compositiondefinition -n greenops --create-namespace -f values_2-2.yaml
kubectl wait compositiondefinition vmtemplate --for condition=Ready=True --namespace greenops --timeout=300s
```


### Krateo 2.3

```bash
cat <<EOL > values_2-3.yaml
composition:
  # when helm is in a registry
  url: https://leonardovicentini.com/helm-charts/charts
  version: 1.0.0
  repo: vm-template

portal:
  card:
    icon: fa-cubes
    title: VmTemplate
    color: green
    content: This is a card for VM template
    tags: "1.0.0"
    status: ""
EOL

helm repo add krateo https://charts.krateo.io
helm repo update krateo

helm install vmtemplate krateo/template --version 0.1.8 -n greenops --create-namespace -f values_2-3.yaml
kubectl wait compositiondefinition vmtemplate --for condition=Ready=True --namespace greenops --timeout=300s
```