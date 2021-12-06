# Scaffolding a fully fledged pocket network stack

_Useful for creating a localnet, a testnet, and even a production set of nodes for mainnet_

## **General Requirements**

1. [Docker](https://docker.io)
2. [Docker-compose](https://docs.docker.com/compose/)
3. [Loki's docker plugin](https://grafana.com/docs/loki/latest/clients/docker-driver/)

## The playground stack

The playground is highly configurable, fully fledged pocket network stack.
You can configure your own playground to be however you desire to be. Although the playground comes with deployment capabilities that can allow you to spawn playgrounds in remote environments, this will not be covered as part of pocket-e2e-stack for the moment.

To learn more about the playground, visit the [github repository](https://github.com/pokt-network/playground).

#### 1. Configuration

1. To configure you playground, start by:

```
$ git submodule update --init --recursive
$ cp .playground.env.example .playground.env
```

_Yes, naming is important and not naming the .env like this will produce unexpected behavior_

2. Open your `.playground.env` and start putting in your desired configuration:

```
DOMAIN=mainnet.pokt.network
NODE_PREFIX=node # Pocket nodes will take this prefix
PEERSISTENT_PEERS=""
SEEDS="03b74fa3c68356bb40d58ecc10129479b159a145@seed1.mainnet.pokt.network:20656,64c91701ea98440bc3674fdb9a99311461cdfd6f@seed2.mainnet.pokt.network:21061,0057ee693f3ce332c4ffcb499ede024c586ae37b@seed3.mainnet.pokt.network:22856"
NODE_PORT=8081
PEER_PORT=21056
NODE_N=0-10 # How many nodes you would like to spin (in a range format)
SNAPSHOT_URL=https://link.us1.storjshare.io/raw/jxswez33rp3jebf5sakbycrkksya/pocket-public-blockchains/pocket-network-data-1229-rc-0.6.4.6.tar # Link to a valid up to date snapshot
USE_UPLINK=True
UPLINK_KEY=147A7s3UVY6g4DhxdatsM7QMofNBJJfvcq5w9XuYjU2HrmEbr4JSbRy3NQu3mijqk7T8in1PYEAdcf11dd5yhJ4eDAn4UMppBgqcN49f2tHVcGhRV2McpvyTm4U22uXH35h14JA1YXiGdUFDss7ThTnFnPYY8uRTxmtG2UrdW9LZkmuJysNF1sU8anEGcZnGQuYWViAzVx2VwtYTrYQE5CXPQotB2rnGwFaUY9vVeTCKFC8yiwZLHxhPJdZaexrZPbBTaf1xvmuyarMchkxvbn8K7pLXfw7n2xGArJavvRK86Nj1SrRr5ws9ku9i24WbGddKWz4SNaZgUH63Wm65yK8m91kgeHLDhhhR
CHAIN_LIST=''
KEYS=
CREATE_SNAPSHOT=False
RUN_DOCKER_COMPOSE=False # Keep it at false, always, and don't worry, you will be able to run your stack
POCKET_IMAGE=poktnetwork/pocket:RC-0.6.4 # The docker image to use for your nodes
USE_CACHE=True
ONLY_MONITORING=False # If you desire to only generate the monitoring stack, set to true
SINGLE_MODE=False
MONITORING_DOMAIN=monitoring.lab.mainnet.pokt.network
```

3. Scaffold your configuration

If you interested in knowing how to trigger scaffolding seperately, keep on reading. For the most part, it will be managed for you, so you can skip to 4.

To scaffold your playground, run:

```bash
$ ./bin/pokt-net/playground scaffold
```

4. Run your configured/scaffolded playground

First, run:

```bash
SCAFFOLD=1 ./bin/pokt-net/playground.sh up
```

SCAFFOLD=1 will scaffold your playground, setting it to 0 will skip scaffolding.

This will generate your pokt-net fullstack according to the configuration specified in `.playground.env` and spin them up.

5. If you've had scaffolded your playground before and want to just launch it again, run:

```
$ ./bin/pokt-net/playground.sh up
```

6. To bring down your playground stack, run:

```bash
$ ./bin/pokt-net/playground.sh down
```
