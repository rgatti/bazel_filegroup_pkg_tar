#!/bin/bash

set -eu


function run_test() {
    tar_file="$1.tar"
    target="//:$1"

    echo ">> Cleaning workspace"
    bazel clean

    echo ">> Run #1, writing 'run 1' to src/data"
    echo "run 1" > src/data
    bazel build $target
    run1="$(tar -Oxf bazel-bin/$tar_file ./src/data)"

    echo ">> Run #2, writing 'run 2' to src/data"
    echo "run 2" > src/data
    bazel build $target
    run2="$(tar -Oxf bazel-bin/$tar_file ./src/data)"

    echo -n ">> Result: "
    if [ "$run1" == "$run2" ]
    then
        echo "SAME"
    else
        echo "DIFFERENT"
    fi

    echo ">> #1: '$run1'"
    echo ">> #2: '$run2'"
}


echo
echo ">> WORKING EXAMPLE"
echo ">> ----------------------------------------"

run_test works

echo
echo ">> NON WORKING EXAMPLE"
echo ">> ----------------------------------------"
run_test does_not_work

