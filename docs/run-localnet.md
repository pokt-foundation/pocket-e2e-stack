# Spinning up a local pocket blockchain

# **General Requirements**

- Docker
- Git
- Make (please upgrade your pre-installed Make version to `GNU Make 3.81`)

# **Pocket Blockchain Step**

The first thing we are going to do is clone the following repositories inside a Folder;

```
Pocket/
-- [portal-api](https://github.com/pokt-foundation/portal-api)
-- [pocket-core](https://github.com/pokt-network/pocket-core)
-- [pocket-js](https://github.com/pokt-network/pocket-js)
-- [pocket-e2e-stack](https://github.com/pokt-foundation/pocket-e2e-stack)
```

Note: please create a docker bridge network called `pocket`, this one is going to be used for everything.

1. Let's navigate to `pocket-e2e-stack` first. This repository was created to make it easy to start a development environment on a local machine for all of the Pocket products. For now, we are only focusing on getting a pocket blockchain running.
2. Checkout to `jail-fast` branch. This configuration will have a really fast jailing/unstaking periods, so it's easier to test. These can be adjusted later.
    
    Note: please use this branch even if you pretend to use a different configuration, as this one uses the `pocket` docker network & configured `.env`. The main branch creates a new network with docker-compose, and we will be running the `portal-api` separately.
    
3. Inside `pocket-e2e-stack`, run this command:

```bash
bin/pkt-stack pokt-net dev up
```

This will get a local pocket blockchain running, and you will be able to use the `pocket-cli` to query the local blockchain. 

If you had any issues until this point, please contact me (CrisOG#5874 on discord) to help you & add the possible problem/solution to the doc.

# Portal API Step

1. Let's move to `Pocket/portal-api` folder, and run `npm install`. 
2. Create a `.tasks.env` and paste this:

```bash
# Mongo Instance to Export Data From
MONGO_SRC_CONNECTION=mongodb+srv://gateway-testnet:RPxg6t2tDuS8SAq@gateway-testnet.kxobp.mongodb.net/gateway-testnet

# Mongo Instance to Write Imports to
MONGO_DEST_CONNECTION=mongodb://mongouser:mongopassword@db:27017/gateway?authSource=admin

MONGO_INITDB_ROOT_USERNAME=mongouser
MONGO_INITDB_ROOT_PASSWORD=mongopassword
MONGO_INITDB_DATABASE=gateway
```

1. Create an `.env` file based on the template & update the following variables:

```bash

# Mongodb env
MONGO_ENDPOINT=mongodb://mongouser:mongopassword@db:27017/gateway?authSource=admin

DISPATCH_URL=http://nodea.dev.pokt:8081,http://nodea.dev.pokt:8081,http://nodea.dev.pokt:8081
ALTRUISTS={"0001": "http://nodea.dev.pokt:8081"}
```

1. Go to `stacks/local.yml` and find for this part of the code:

```bash
networks:
  pocket:
    driver: bridge
```

Please, update this so it uses the `pocket` bridge network we created earlier.

```bash
networks:
  pocket:
    name: pocket
```

Once you have configured all of this, then you can:

```bash
npm start services:all:up
```

Congrats! Now you have a local pocket blockchain, and a portal API for immediate local use.

# Query local pocket blockchain

You can use any client you want to make requests. This is the base URL for calls.

```bash
http://mainnet.localhost:3000/v1/5f3585a6673a2923d229867d
```

If you are on a Mac, you will need to add the subdomains to `/etc/hosts`.
Example:
```
127.0.0.1 localhost mainnet.localhost
```

Note: `5f3585a6673a2923d229867d` is an application ID, you may or may not have this same application ID available to use, as this is fetched from the `portal-api` mongodb local instance (imported from the testnet pocket mongo db instance).

If you get the `application id not found` error, please use a client for MongoDB to find an `applicationID` that you can use.

If you want to ask for the balance for example,

1. Add this path to the base url `/v1/query/balance`
2. Put this in the body.

```bash
{
    "address": "4b54c7ef83273bfb8cfd212ce7266de72716604d",
    "height": 10
}
```

You can view the rest of endpoints using the [OpenAPI spec](https://raw.githubusercontent.com/pokt-network/pocket-core/staging/doc/specs/rpc-spec.yaml). You can copy and paste the raw spec in [this editor](https://editor.swagger.io/) for better visualization. Note: the spec is a bit outdated, so if you have any issues let us know.