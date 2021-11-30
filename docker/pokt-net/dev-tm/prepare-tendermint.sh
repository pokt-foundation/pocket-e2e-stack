#!/bin/sh

if [[ ! -f "$POCKET_ROOT/go.mod.tendermint" ]]; then
  mv $POCKET_ROOT/go.mod.tendermint $TENDERMINT_PATH/go.mod
  cd $TENDERMINT_PATH
  echo "Installing dependencies for tendermint..."
  go mod download
fi

if [[ ! -f "$POCKET_ROOT/go.mod.core" ]]; then
  mv $POCKET_ROOT/go.mod.core $POCKET_PATH/go.mod
  cd $POCKET_PATH
  echo "Installing dependencies for core..."
  go mod download
fi

cd $POCKET_ROOT
