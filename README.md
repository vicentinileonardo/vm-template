# vm-template

## How to install

```sh
kubectl create ns greenops
kubectl apply -f https://raw.githubusercontent.com/vicentinileonardo/vm-template/refs/heads/main/compositiondefinition.yaml
```

### With *Krateo Composable Portal*

#### With custom form

```sh
DATE=$(date +"%Y-%m-%dT%H:%M:%SZ")
curl -sL "https://raw.githubusercontent.com/vicentinileonardo/vm-template/main/customform.yaml" | sed "s/{{DATE}}/$DATE/" | kubectl apply -f -
```

#### Bonus: leverage patch-provider to reflect compositiondefinitionstatus in card

```sh
kubectl apply -f https://raw.githubusercontent.com/vicentinileonardo/vm-template/refs/heads/main/patch.yaml
```