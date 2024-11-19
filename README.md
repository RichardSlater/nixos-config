A collection of NixOS configurations for different personal projects on my home network.

## Prerequisites

The following channels will need to be added

```zsh
sudo nix-channel --add https://github.com/ryantm/agenix/archive/main.tar.gz agenix
sudo nix-channel --update
```

Additionally the ssh key used by age must be included in `~/.ssh`:

```
-rw-------  1 richardsl users  411 Oct 22 19:27 id_ed25519
-rw-r--r--  1 richardsl users   97 Oct 20 15:02 id_ed25519.pub
```

> [!IMPORTANT]
> It's important that the `id_ed25519` file is non-group and non-group readable as it contains a private key and must be protected accordingly.
> ```sh
> chmod 400 ~/.ssh/id_ed25519
> ```

## DNS

```
whoami.net.scetrov.live
eth-garnet-rpc.web3.scetrov.live
cockpit-brix0001.net.scetrov.live
eth-holesky-rpc.web3.scetrov.live
garnet-rpc.web3.scetrov.live
garnet-rpcws.web3.scetrov.live
dashboard.web3.scetrov.live
metrics-dashboard.net.scetrov.live
```
