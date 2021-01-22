((magit-branch nil)
 (magit-commit nil
               ("--all"))
 (magit-diff
  ("--no-ext-diff" "--stat")
  (("--" "Source/Tasks/SuperTask.cpp")))
 (magit-fetch nil)
 (magit-format-patch:--reroll-count "1")
 (magit-gitignore nil)
 (magit-log
  ("-n256" "--graph" "--decorate")
  (("--" "Main/Source/main.cpp"))
  (("--" "docker/README.md"))
  (("--" ".git/COMMIT_EDITMSG")))
 (magit-patch nil)
 (magit-patch-create
  ("--reroll-count=1"))
 (magit-pull nil)
 (magit-push nil)
 (magit-reset nil)
 (magit-run nil))
