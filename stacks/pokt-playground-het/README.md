# LocalNet Playground

This is a "hardcoded" pre-scaffolded version of `playground/dev-tm` that was created in order to easily run a heterogenous LocalNet composed of different branches.

This branch in the pocket-e2e-stack is intentionally far from perfect and is only meant to be submitted to mainline as a stop gap solution to enable the protocol team to effectively debug v0 while building a good foundation for v1.

### Resources

- Driven by [this crisis](https://www.notion.so/2022-04-15-a57d7f3cf9404757834a40261464b77c).
- Based off [this presentation](https://docs.google.com/presentation/d/1mk0XogopENCI_4WXXvSYm1_DG8EhRLIpwpZQNIA5vqM/edit#slide=id.g1067626419f_0_48).

## One Time Setup

**Clean Docker:**

```bash
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker volume rm $(docker volume ls -q)
```

**Create a new directory for your LocalNet:**

```bash
mkdir red-crisis-localnet && cd red-crisis-localnet
```

**Clone the necessary repos:**

```bash
git clone git@github.com:pokt-network/pocket-core.git
git clone git@github.com:pokt-network/tendermint.git
git clone git@github.com:pokt-network/tx-bot.git
git clone git@github.com:pokt-foundation/pocket-e2e-stack.git

### Temp until merged to main###
git checkout -b crisis/red/holy/hack remotes/origin/crisis/red/holy/hack

# Update
cd pocket-e2e-stack && git submodule update --init --recursive
```

**Update env variables**

```bash
d=$(dirname $(pwd))

cp .env.template .env
sed -i -e "s#POCKET_CORE_REPOS_PATH=.\/#POCKET_CORE_REPOS_PATH=${d}#g" .env
sed -i -e "s/# PNF_USERNAME=/PNF_USERNAME=pnfblockchains/g" .env
sed -i -e "s/# PNF_PASSWORD=/PNF_PASSWORD=UEnJdyW23ch92rf/g" .env

cp stacks/pokt-playground-het/.env.template stacks/pokt-playground-het/.env
sed -i -e "s#POCKET_CORE_REPOS_PATH=#POCKET_CORE_REPOS_PATH=${d}#g" stacks/pokt-playground-het/.env
```

**Update the branches**

Inside of `stacks/pokt-playground-het/docker-compose.yaml`, update the `POCKET_BRANCH` for each node.

Make sure it is available in your local `pocket-core` repo.

**Start it up**

```bash
./bin/pokt-net/playground.sh up-het
```

**Check Docker**

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}\t{{.Command}}\t{{.Status}}’
```

Check the branches

```bash
# Node 1
docker exec -it node1.dev.pokt bash -c "git config --global --add safe.directory /go/src/github.com/pokt-network/pocket-core && git --git-dir /go/src/github.com/pokt-network/pocket-core/.git branch"

# Node 2
docker exec -it node2.dev.pokt bash -c "git config --global --add safe.directory /go/src/github.com/pokt-network/pocket-core && git --git-dir /go/src/github.com/pokt-network/pocket-core/.git branch"

# Node 3
docker exec -it node3.dev.pokt bash -c "git config --global --add safe.directory /go/src/github.com/pokt-network/pocket-core && git --git-dir /go/src/github.com/pokt-network/pocket-core/.git branch"

# Node 4
docker exec -it node4.dev.pokt bash -c "git config --global --add safe.directory /go/src/github.com/pokt-network/pocket-core && git --git-dir /go/src/github.com/pokt-network/pocket-core/.git branch"
```

## Hitting Errors

**Try running the two following commands**

```bash
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker volume rm $(docker volume ls -q)
./bin/pokt-net/playground.sh up-het
```

## Updating Code

@Andrew Nguyen TODO