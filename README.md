## tmux

The tmux prefix is `` ` ``

- `prefix + j/k/h/l` - move panes
- `prefix + t/z` - zoom current pane
- `prefix + x` - close current pane
- `prefix + c` - open new window
- `prefix + &` - close current window
- `prefix + ,` - rename current window
- `prefix + n/Tab` - next window
- `prefix + p/S-Tab` - previous window
- `prefix + -/H` - split window horizontally
- `prefix + _/V` - split window vertically
- `prefix + Esc` - enter copy mode
- `prefix + Enter` - copy selection
- `prefix + q` - kill current session

## SSH

To fix agent forwarding, use `fixssh`

If SSH isn't working on macOS (no identities), use `ssh-add --apple-use-keychain`

## GPG

### Helpful Links

- [GPG Quickstart](https://github.com/bfrg/gpg-guide)
- [GnuPG forwarding setup](https://wiki.gnupg.org/AgentForwarding)
- [Offline master key](https://incenp.org/notes/2015/using-an-offline-gnupg-master-key.html)
- [Mac-specific forwarding setup](https://gist.github.com/TimJDFletcher/85fafd023c81aabfad57454111c1564d)
- [YubiKey commit signing](https://github.com/YubicoLabs/sign-git-commits-yubikey)
- [YubiKey big guide](https://github.com/drduh/YubiKey-Guide)

### Useful Commands

- `gpg --export -a 07F64768955B38A4A934E3D9C5389003AC500A4A | ssh $HOSTNAME 'gpg --import  -'` export public keys to remote
- `gpgconf --kill gpg-agent` when remote isn't working
- `gpg-connect-agent reloadagent /bye` when local agent isn't working
- `gpg --list-secret-keys --keyid-format=long` long IDs
- `gpgconf --list-dir agent-socket` populate SSH config
- If `gpg -k` hangs locally, try removing lockfiles at `~/.gnupg/*.lock` and `~/.gnupg/public-keys.d/*.lock`
- On the remote, make sure `SSH_AUTH_SOCK` isn't set (`unset SSH_AUTH_SOCK`)

Remember to add `StreamLocalBindUnlink yes` to `/etc/ssh/sshd_config`

You can append `!` to get a specific GPG key
