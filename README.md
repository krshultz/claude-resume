# claude-resume

Tab completion for `claude --resume` in zsh.

When you quit a [Claude Code](https://claude.com/claude-code) session, it often prints something like:

```
Resume this session with:
claude --resume bdfd6099-6313-4c1f-8699-7ef75d3b15ec
```

Rather than copying that ID, type `claude -r` and press Tab. You get a list of the sessions you
started in the current directory, newest first. Each one is labeled with when it was last used
and the title Claude Code gave it:

```
$ claude -r <Tab>
c314cca8-feab-4327-8dfc-21e387dcfd7c  -- 2026-09-26 12:34  Claude resume command completion
b3be8c97-a9fa-474f-9c1f-1bdb08eec2c5  -- 2026-09-24 09:10  Search CachedData for targa
```

## Please read first: use at your own risk

This is a small personal tool, shared in case it's useful to you. **It comes with no warranty or
support, and you use it at your own risk** (see [LICENSE](LICENSE)).

- **Tested:** zsh with [Oh My Zsh](https://ohmyz.sh/) on macOS. That's the only setup I use.
- **Not tested:** plain zsh without a framework. The instructions below should work, but I
  haven't used it that way day to day.
- **Unknown:** other plugin managers (zinit, antidote, zplug, Prezto, and so on). They may
  load it without trouble, but I haven't tried them and can't say.

It also depends on how Claude Code stores sessions on disk
(`~/.claude/projects/<directory>/<session-id>.jsonl`). That's an internal detail, not a
documented interface, so a future Claude Code release could break this plugin.

Issues and pull requests are welcome, especially reports of setups where it works or doesn't.

## Install

### Oh My Zsh (tested)

1. Clone the repo into your custom plugins folder:

   ```sh
   git clone https://github.com/krshultz/claude-resume.git \
     "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/claude-resume"
   ```

2. Add `claude-resume` to the `plugins=(...)` line in `~/.zshrc`, for example:

   ```sh
   plugins=(git claude-resume)
   ```

3. Open a new terminal, or run `exec zsh`.

#### Or: clone it somewhere else and symlink it

If you'd rather keep the repo with your other projects, clone it there and put a symlink in
the plugins folder (step 2 above still applies):

```sh
git clone https://github.com/krshultz/claude-resume.git ~/Repositories/claude-resume
ln -s ~/Repositories/claude-resume \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/claude-resume"
```

This is how I run it myself. See [Development](#development) for why it helps.

### Plain zsh (untested)

Clone the repo anywhere, then source the plugin in `~/.zshrc`. It must come **after**
`compinit`, which turns on zsh's completion system:

```sh
autoload -Uz compinit && compinit
source /path/to/claude-resume/claude-resume.plugin.zsh
```

## How it works

Claude Code saves each session as a file named after its session ID, in a folder named after
the directory the session started in (with `/` and `.` replaced by `-`). The plugin lists those
files newest first and reads the `aiTitle` entry from each one to use as the label. The date is
the file's last-modified time. Claude Code adds to the file as the session runs, so that time is
when the session was last used.

## Limitations

- **Current directory only.** You only see sessions started in the directory you're in, because
  that's how Claude Code files them. Run `claude -r` from the same directory as the session you want.
- **Other `claude` options.** The plugin adds a completion for the `claude` command, so pressing
  Tab on other options falls back to ordinary filename completion. As far as I know, Claude Code
  doesn't ship a zsh completion of its own, so you shouldn't lose anything.
- **Untitled sessions** show as `(untitled)`.

## Development

If you plan to change the plugin, use the symlink install above. That way there's only one
copy: the Oh My Zsh plugin folder points at your working repo, so you edit, commit and test in
the same place. You never find yourself editing one copy while your shell loads another.

- **Reload after editing:** run `exec zsh`. It starts a fresh shell, which is more reliable
  than `source ~/.zshrc` re-running your config on top of the current one.
- **Check which file is loaded:** `whence -v _claude_sessions` prints the path the function
  came from.
- **If you move or rename the repo,** the symlink breaks and Oh My Zsh warns
  `[oh-my-zsh] plugin 'claude-resume' not found` at startup. Point it at the new location with:

  ```sh
  ln -sfn /new/path/to/claude-resume \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/claude-resume"
  ```

## Uninstall

Remove `claude-resume` from `plugins=(...)`, or delete the `source` line, then delete the cloned
folder. If you used a symlink, delete the link too (`rm` on the link removes only the link, not
the repo).

## License

[MIT](LICENSE)
