Update the following files:
  - /etc/hosts
  - /etc/resolv.conf

```
POCKET_CORE_REPOS_PATH=/path/to/all/pocket/repos

POCKET_CORE_REPO_PATH=$POCKET_CORE_REPOS_PATH/pocket-core
POCKET_NETWORK_TENDERMINT_PATH=$POCKET_CORE_REPOS_PATH/tendermint

DEBUG=1
```

Run the following command:

```
./bin/pkt-stack pokt-net dev-tm up
```

DEBUG=1