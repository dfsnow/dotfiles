# Installation

```
cd ~
git clone https://github.com/dfsnow/dotfiles
cd ~/dotfiles
source setup.sh
```

# Usage

## Tmux

Tmux prefix is `Ctrl + a`

### Windows

* `prefix + c` open new window
* `prefix + &` close current window
* `prefix + ,` rename current window
* `prefix + n` next window
* `prefix + p` previous window

### Panes

* `prefix + -` split window horizontally
* `prefix + _` split window vertically
* `prefix + x` close current pane
* `prefix + q` kill current session

# GPG

## Links

* [GPG Quickstart](https://github.com/bfrg/gpg-guide)
* [GnuPG forwarding setup](https://wiki.gnupg.org/AgentForwarding)
* [Mac-specific forwarding setup](https://gist.github.com/TimJDFletcher/85fafd023c81aabfad57454111c1564d)
* [YubiKey commit signing](https://github.com/YubicoLabs/sign-git-commits-yubikey)
* [YubiKey big guide](https://github.com/drduh/YubiKey-Guide)

## Useful Commands

* `gpg --export -a 07F64768955B38A4A934E3D9C5389003AC500A4A | ssh $HOSTNAME 'gpg --import  -'` export public keys to remote
* `gpgconf --kill gpg-agent` when remote isn't working
* `gpg-connect-agent reloadagent /bye` when local agent isn't working
* `gpg --list-secret-keys --keyid-format=long` long IDs
* `gpgconf --list-dir agent-socket` populate SSH config

Remember to add `StreamLocalBindUnlink yes` to `/etc/ssh/sshd_config`

