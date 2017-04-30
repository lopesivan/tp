#!/usr/bin/env bash

# Fail fast, we're messing with git internals!
#set -x

BRANCH=${1:-deploy}

# Don't interfere with the real index, which means we are immune to "dirty" working copies
TMPDIR=`mktemp -d -t deploy-indexXXXXXX`
export GIT_INDEX_FILE=$TMPDIR/index

# This is where we would want to "Do stuff" like 'npm install --production`

echo "Creating branch '$BRANCH' if it doesn't exist..."
git branch $BRANCH 2> /dev/null || echo "using existing"
PARENT=`git rev-parse refs/heads/$BRANCH`

# Start building our new index
echo "Creating index... (this can take a while)"

# Every file that is tracked or untracked
git ls-files --cached --other | while read f; do
    # Create a new git blob object, writing it to .git/objects
    if test -L "$f"; then
        # Symlinks are hashes of the path pointed to
        OBJ=`readlink "$f" | git hash-object -w --stdin`
    else
        # Everything else is a hash of the file contents
        OBJ=`git hash-object -w "$f"`
    fi
    MODE=`stat -c %a "$f"`

    # Add the object to the index as a file with a name and mode
    git update-index --add --replace --cacheinfo $MODE $OBJ "$f"
done

# At this point we've got a giant index representing the current state of every file under $CWD

echo "Creating tree from index..."
TREE=`git write-tree --missing-ok`
echo "Created tree $TREE"

# Create a new commit object decending from the $BRANCH branch containing out new tree
echo "Creating commit..."
SHA1=`git commit-tree -p $PARENT -m "Deploy snapshot $(date)" $TREE`
echo "Created commit $SHA1"

# We now have a commit, but nothing is pointing to it

# Update our "$BRANCH" branch to point to the new commit, which is a child of the $BRANCH branch head
git update-ref refs/heads/$BRANCH $SHA1

# Clean up after ourselves, or echo the name of our temp file if $DEBUG is set
test -n "$DEBUG" && ls -l $GIT_INDEX_FILE || rm -rf $TMPDIR