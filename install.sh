#!/bin/bash

RUNS=("generate-githubflow-scripts.pl")

SCRIPT_DIR=$(dirname $0)

FROM_DIR=$SCRIPT_DIR/scripts
TO_DIR=~/bin

if [ ! -e $TO_DIR ];then
    mkdir $TO_DIR 
fi

for file in $FROM_DIR/*
do
    echo "COPY $file"
    cp $file $TO_DIR
    chmod 755 $TO_DIR/$(basename $file)
done

for file in ${RUNS[@]}
do
    chmod 755 ./bin/$file
    ./bin/$file
done

cd src/go-uuid && go build -o $TO_DIR/gen-uuid main.go && chmod 755 $TO_DIR/gen-uuid
