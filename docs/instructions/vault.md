## Vault configuration
<br />

The vault is unsealed by a k8s job running `post install`. ( [code here](https://github.com/Open-Olympus-Project/tooling-vault/blob/vault-init-job/vault/files/vault-config.sh) ) 

After the Vault has been unsealed - The vault will be ready to use, but since the vault contains no secrets it will be necessary to populate the vault with some values list below.

The table contains the key of the secret, a small description about the use of that secret, the path that it's expected to be on in the vault, and the expected value that is expected.

| name | key | description | usage | path | expected value |
|------|-----|-------------|-------|------|--------------|
| github-ssh | github | A ssh key the is allowed to access | to pull from repo in workflows | k8s/secrets/github-ssh | an ssh key
| github-ssh | github.pub | The public key that belongs to the ssh key | to pull from repo in workflows | k8s/secrets/github-ssh | the public key
| server-url | url | A secret the contains the servers url | for some workflows to know which server their on | k8s/configs/server-url | service-test.com
| vault-url | url | A secret the contains the vault url | used to configure OIDC for the vault | k8s/configs/vault-url | service-vault-test.com
| harbor-creds | username | a username for Harbor | To create projects in docker build flow | k8s/secrets/harbor | harbor-acc
| harbor-creds | password | the password for the above username | To create projects in docker build flow | k8s/secrets/harbor | password12345
| storage-account-creds | sa_name | the name of the storage account | Used to store metrics and logs | k8s/secrets/storage-account-creds | sa-aks-service-test
| storage-account-creds | sa_key | the key to the storage account | Used to store metrics and logs | k8s/secrets/storage-account-creds | the key that beongs to the sa_name