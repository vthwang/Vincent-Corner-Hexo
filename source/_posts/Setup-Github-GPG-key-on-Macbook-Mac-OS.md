---
title: Setup Github GPG key on Macbook (Mac OS)
thumbnail:
  - /images/gpg.jpeg
toc: true
date: 2022-07-27 14:19:10
categories: Skill Share
tags: Mac
---
<img src="/images/gpg.jpeg">

***
# Create gpg key
1. Install gpg command.
    - `brew install gnupg`
2. Create gpg key and keep press enter to use the default setting. In the last step, set up a paraphrase(password).
    - `gpg --full-generate-key`
3. Check your gpg key.
    - `gpg --list-secret-keys --keyid-format=long`
4. Copy the `A111111111A11A11` part.
    - Example: `ed25519/A111111111A11A11`
5. Export gpg key.
    - `gpg --armor --export A111111111A11A11`
# Setup gpg in Github
1. Setting -> SSH and GPG keys -> New GPG key.
2. Paste the export from the previous step.
# Git setting
1. Tell git your sign key.
    - `git config --global user.signingkey A111111111A11A11`
2. Force git to sign commits.
    - `git config --global commit.gpgsign true`
3. Install [gpgtools](https://gpgtools.org/) to save the paraphrase.
    - `brew install --cask gpg-suite`
# Setup gpg variables
1. Edit config file.
    - `sudo vim ~/.zshrc`
    - Add `export GPG_TTY=$(tty)` to the end of file.
2. Update config file.
    - `source ~/.zshrc`
# Setup gpg timeout
1. `sudo vim ~/.gnupg/gpg-agent.conf`
```
default-cache-ttl 34560000
max-cache-ttl 34560000
```
# Sign commit
1. `git commit -s -m 'your commit'`
