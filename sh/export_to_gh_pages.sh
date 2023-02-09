#!/bin/bash
green=`tput setaf 2`
reset=`tput sgr0`
print_message(){
	echo "${green}$1${reset}"
}

print_message "stashing changes"
git add .
git stash || exit "$?"

if test -f ".gitignore"; then 
	GITIGNORE=true
else
	GITIGNORE=false
fi

CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null)
print_message "version $CURRENT_VERSION"

git checkout gh-pages || git checkout -b gh-pages || exit "$?"

[ ! -d $RELEASE_DIR ]

print_message "running git rm -rf on directory (to avoid merge conflicts)"
git rm -rf . || exit "$?"

if $GITIGNORE; then
	print_message "recovering .gitignore"
	git checkout main -- .gitignore || exit "$?"
fi
RELEASE_DIR=releases

print_message "recovering releases or creating releases directory if first release"
git checkout HEAD -- $RELEASE_DIR || mkdir $RELEASE_DIR || exit "$?"

print_message "applying stash"
git stash pop || exit "$?"


DEST_DIR=$RELEASE_DIR/$CURRENT_VERSION
[ ! -d $DEST_DIR ] && mkdir $DEST_DIR

print_message "copying latest export to corresponding release directory $DEST_DIR"
rsync -av --progress index* $DEST_DIR --exclude $RELEASE_DIR

print_message "generating release index"
cd $RELEASE_DIR
cat > index.html <<'EOF'
  <html>
  <head>
    <title>Releases</title>
  </head>
  <body>
    <h1>Releases</h1>
EOF

for f in *; do
  cat >> index.html <<EOF
    <div>
    <a href="$f">
      $f
    </a>
    </div>
EOF
done

cat >> index.html <<'EOF'
  </body>
  </html>
EOF
cd -

print_message "committing changes"
git add .
git commit -m"release"
git push || git push --set-upstream origin gh-pages || exit "$?"
git checkout main