## tmux

The tmux prefix is `` ` ``

- `prefix + j/k/h/l` - move panes
- `prefix + t/z` - zoom current pane
- `prefix + x` - close current pane
- `prefix + c/b` - open new window
- `prefix + &` - close current window
- `prefix + ,` - rename current window
- `prefix + n/Tab` - next window
- `prefix + p/S-Tab` - previous window
- `prefix + -` - split window horizontally
- `prefix + _` - split window vertically
- `prefix + =` - split window horizontally 70/30
- `prefix + Esc` - enter copy mode, then `Enter` to copy
- `prefix + $` - rename current session
- `prefix + q` - kill current session

## PDB

### Stepping

- `n(ext)` - Step over
- `s(tep)` - Step into
- `r(eturn)` - Continue until the current function returns
- `c(ontinue)` - Continue until the next breakpoint is encountered
- `unt(il) line_number` - Continue until a specific line is encountered
- `u(p)` - Up one level in the stack trace
- `d(own)` - Down one level in the stack trace
- `h(elp)` - Show help
- `q(uit)` - Quit debugger

### Breakpoints

- `b(reak)` - Show all breakpoints
- `b(reak) line_number` - Set a breakpoint at a specific line
- `b(reak) line_number, condition` - Set a breakpoint at a specific line, if condition is met
- `b(reak) file:line_number` - Set a breakpoint in a file at a specific line
- `b(reak) func` - Set a breakpoint at the first line of a function
- `disable number` - Disable breakpoint number
- `enable number` - Enable breakpoint number
- `clear number` - Remove breakpoint number

### Printing

- `p(rint) expr` - Print the value of expr
- `w(here)` - Print current position and stack trace
- `l(ist)` - Print 11 lines of code around the current line
- `ll(onglist)` - Print the entire code for current function or frame
- `a(rgs)` - Print the arguments of the current function

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

> [!NOTE]
> If the remote forwarding stops working for whatever reason. Use the following command:
> `rm $(gpgconf --list-dir agent-socket)`, then reconnect the SSH session
