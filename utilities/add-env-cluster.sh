env=test
authMethodName=kubernetes-$env
secretPath=k8s

kubectl config use-context env-aks-ps-$env

echo "Fetching es sa secret name"
VAULT_SA_SECRET_NAME=$(kubectl -n tooling get sa vault-$env -o json | jq -re '.secrets[] | select(.name | test("vault")) | .name');

echo $VAULT_SA_SECRET_NAME

echo "Getting token and crt"
SA_JWT_TOKEN=$(kubectl -n tooling get secrets $VAULT_SA_SECRET_NAME -o json | jq -r -e '.data.token' | base64 -d; echo);
SA_CA_CRT=$(kubectl -n tooling get secrets $VAULT_SA_SECRET_NAME -o json | jq -r -e '.data."ca.crt"' | base64 -d; echo);

host=$(kubectl config view -o json | jq -re '.clusters[] | select(.name | test("ps-test")) | .cluster.server')

kubectl config use-context service-aks-ps

kubectl exec -it -n tooling vault-0 -- vault login $(cat cluster-keys.json | jq -re '.root_token')

echo "Creating role for $secretPath"
kubectl exec -it -n tooling vault-0 -- vault write auth/$authMethodName/role/$secretPath-secrets bound_service_account_names=external-secrets-$env bound_service_account_namespaces=tooling policies=$secretPath-secrets ttl=24h;

echo "Configuring auth path"
kubectl exec -it -n tooling vault-0 -- vault write auth/$authMethodName/config token_reviewer_jwt="$SA_JWT_TOKEN" kubernetes_host="$host" kubernetes_ca_cert="$SA_CA_CRT"
