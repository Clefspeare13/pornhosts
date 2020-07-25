# Contributing

If you feel like contributing there are a couple of ways to do this

1. You can add new super high speed bash code, optimizing existing or rewrite for 
    broader support of bash environments across OS's
1. You can add domains to either the [hosts.txt](submit_here/hosts.txt) in the
    source folder. or for snuff in [snuff.txt](submit_here/snuff.txt)
1. Please add you contribution to either the very beginning of the file or the
    bottom, the top of the file, then the CI/CD will do the sorting.

# Workflow

## Github
### Add new hosts
The workflow is a bit clumsy, but the most reliable and simple. Beside it leaves
the why to the history book (commits) and the one who is reviewing the PR/Issue
doesn't have to do a second manual lookup of the submission.
 
1. You add an issue with you question, feature request or ? 
    (This is the _why_ to block)
1. You open a MR (Merge Request) where you'll add your contribution 
    (This is the _when_ and _who_ did the block)
1. Add your new hosts to either `submit_here/hosts.txt` or `submit_here/snuff.txt`
1. You add the new hosts entry in the top or bottom of the list, then it is 
    easier to find. 
    The code will make it appear in alphanumeric hierarchical order.
1. Follow the [New commit](#new-commit) guide

### New code
If you like to add new code or modify existing code to make it run better,
faster, smarter. You will by editing and contributing to the code, automatically
be redirected to a fork of the main repo, from where you add and/or modify the code.

#### New commit
When you are done with your contribution, you will save the the file in a new branch

![new commit](https://user-images.githubusercontent.com/44526987/68994730-a380f980-0886-11ea-84a6-7a921902de98.png)

Next you'll be taken to the `Open a pull request` 

![Open a pull request](https://user-images.githubusercontent.com/44526987/68994731-a4199000-0886-11ea-8158-1cd2b0a4a271.png)

And if everything is filled out, you just hit the `Create pull request` and
you are done.

<!--
# GPG signed
We require all submissions to be signed with a valid GPG key.

Only exception to this rule is the CI/CD bot
-->

## How do I sign with GPG
If you know nothing about GPG keys I really suggest you search on 
[duckduckgo](https://safe.duckduckgo.com) for the best way to do it, on your current OS.

However if you do have a GPG key, add it to you submission profile add a `-S`
to the `git commit -S -m "Some very cool enhancements"` and that's is. You can set 
this globally or pr git. Do a search on [duckduckgo](https://duckduckgo.com)
to figure out the current way.

# Encoding when writing files/lines
- All files most end with a newline (\n)(LF) UTF-8.
- All files have to be in universal UTF-8 style without BOM
- Any files or file location containing `_windows_` in it's name most be 
  encoded in `ISO-8859-1 Latin1` and newlines *most* end in (CRLF)
- Line length should not be any longer than 80 chars for terminals support

## Branching
Branching is a core concept in Git, and the entire GitHub flow is based upon it.
There's only one rule: anything in the master branch is always deployable.

Because of this, it's extremely important that your new branch is created off
of master when working on a feature or a fix. Your branch name should be
descriptive (e.g., `new $domain`, `removal $domain`, `new feature`), so that 
others can see what is being worked on.
