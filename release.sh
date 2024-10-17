#!/bin/sh

### This should be a pipeline, but for this example let use this ###

setup() {
    git fetch
}

check_last_commit() {
    last_commit_message=$(git log -1 --pretty=format:%s)
    if [ "$last_commit_message" = "[RELEASE] - bump version" ]; then
        echo "Nothing to release!!!"
        exit 1
    fi
}

un_snapshot_catalog() {
    sed -i "s/^\($1\s*=\s*\"[0-9.]*\)-SNAPSHOT.*$/\1\"/" hlaeja.versions.toml
}

un_snapshot_version() {
    sed -i 's/\(version\s*=\s*[0-9.]*\)-SNAPSHOT/\1/' gradle.properties
}

get_current_version() {
    awk -F '=' '/version\s*=\s*[0-9.]*/ {gsub(/^ +| +$/,"",$2); print $2}' gradle.properties
}

stage_files() {
    for file in "$@"; do
        if git diff --exit-code --quiet -- "$file"; then
            echo "No changes in $file"
        else
            git add "$file"
            echo "Changes in $file staged for commit"
        fi
    done
}

commit_change() {
    stage_files gradle.properties hlaeja.versions.toml
    git commit -m "[RELEASE] - $1"
    git push --porcelain origin master
}

add_tag() {
    gitTag="v$(get_current_version)"
    git tag -a "$gitTag" -m "release"
    git push --porcelain origin "$gitTag"
}

snapshot_version() {
    new_version="$(get_current_version | awk -F '.' '{print $1 "." $2 "." $3+1}')"
    sed -i "s/\(version\s*=\s*\)[0-9.]*/\1$new_version-SNAPSHOT/" gradle.properties
}

# gitCmd
setup

# checkLastCommit
check_last_commit

# unSnapshotCatalogVersion

# unSnapshotVersion
un_snapshot_version

# commitVersionChange
commit_change "release version: $(get_current_version)"

## tagCommit
add_tag

## snapshotCommit
snapshot_version

## commitVersionChange
commit_change 'bump version'
