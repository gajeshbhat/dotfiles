---
name: draft-pr
description: Commit current changes (signed, conventional), push the feature branch and open a draft PR.
disable-model-invocation: true
---
1. Refuse on `main`/`master`: create or switch to a feature branch first.
2. Stage only intended files; commit with a conventional message (`feat|fix|refactor|docs|build|style|test|ci: ...`),
   GPG-signed. If signing fails (`Inappropriate ioctl for device`), stop and ask the user to run
   `! echo unlock | gpg --clearsign > /dev/null`. Never disable signing.
3. Add no Claude co-author trailer and no "Generated with Claude Code" line.
4. `git push -u origin HEAD`, then `gh pr create --draft` with a short body; never merge.
5. Run `gh pr checks` and report the result.
