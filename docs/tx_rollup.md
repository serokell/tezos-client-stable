<!--
   - SPDX-FileCopyrightText: 2022 Oxhead Alpha
   - SPDX-License-Identifier: LicenseRef-MIT-OA
   -->

# Setting up transaction rollup node on Ubuntu

`proto` variable can hold every active protocol, currently `013-PtJakart` and `014-PtKathma`.

By default, `tezos-tx-rollup-node-$proto.service` will using:
* `/var/lib/tezos/.tezos-client` as the `tezos-client` data directory, set in `DATA_DIR`
* `http://localhost:8732` as the `tezos-node` RPC address, set in `NODE_RPC_ENDPOINT`
* `127.0.0.1:8472` as the `tezos-tx-rollup-node-$proto` RPC address, set in `ROLLUP_NODE_RPC_ENDPOINT`
* `observer` as the `tezos-tx-rollup-node-$proto` working mode, set in `MODE`
* `rollup` as the rollup alias, set in `ROLLUP_ALIAS`

In order to change defaults, edit `/etc/default/tezos-tx-rollup-node-$proto` file.

At first you should originate rollup with the provided alias for some implicit account:
```
tezos-client originate tx rollup ${ROLLUP_ALIAS} from ${IMPLICIT_ACCOUNT_ALIAS}
```

After that, with the active `tezos-node` service available with the provided uri, run the following command
```
sudo systemctl start tezos-tx-rollup-node-$proto.service
```

For futher details, see [the documentation](http://tezos.gitlab.io/active/transaction_rollups.html).
