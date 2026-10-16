---
name: lxd-test-vm
description: Build, lint or test LXD inside the lxd-test VM (v1) for a worktree, never on the host.
argument-hint: <worktree-name> [make-target|suite]
disable-model-invocation: true
---
Never run LXD builds, `make static-analysis`, `make check-unit` or `./test/main.sh` on the host.
`v1` mounts `/home/gajesh/git/lxd` at `/root/lxd`, so worktree `$1` is `/root/lxd/.claude/worktrees/$1`.

1. Write a script (outside the repo) that does:

       export PATH=/root/go/bin:/snap/bin:$PATH
       cd /root/lxd/.claude/worktrees/$1
       eval "$(make env | grep '^export')"
       make ${2:-static-analysis}     # or: ./test/main.sh <suite>

2. `lxc file push <script> v1/root/run.sh`, then `lxc exec v1 -- bash /root/run.sh` with run_in_background.
3. Never interrupt `make static-analysis`; a half-run leaves broken `*.mapper.go`. Report the result.
