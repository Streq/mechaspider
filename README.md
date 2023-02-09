## Create project from skel
```
git clone https://github.com/Streq/GodotSkel.git miproject
cd miproject
rm -rf .git
git init -b develop
git add .
git commit -m"first commit"
gh repo create

? What would you like to do? Push an existing local repository to GitHub
? Path to local repository .
? Repository name miproject
? Description description
? Visibility Public
✓ Created repository Streq/miproject on GitHub
? Add a remote? Yes
? What should the new remote be called? origin
✓ Added remote git@github.com:Streq/miproject.git
? Would you like to push commits from the current branch to "origin"? Yes
✓ Pushed commits to git@github.com:Streq/miproject.git

git branch gh-pages
git checkout gh-pages
git push --set-upstream origin gh-pages
git checkout develop
#configure gh-pages branch on the gh repo

git branch main
git checkout main
git push --set-upstream origin main
git checkout develop

```

## Update secrets
```
cp secrets_template.sh secrets.sh
chmod +x secrets.sh
#edit secrets.sh with keys and configs
./secrets.sh
```

## Create main
```
git checkout -b main
git push origin main
git push --set-upstream origin main
git checkout develop
```

## Release
```
chmod +x release.sh
./release.sh "release message"
```

## Versioning by commit message
```
#in develop
git commit -m"(MAJOR) algo" # 1.0.0 -> 2.0.0
git commit -m"(MINOR) algo" # 1.0.0 -> 1.1.0
git commit -m"algo"         # 1.0.0 -> 1.0.1
```
