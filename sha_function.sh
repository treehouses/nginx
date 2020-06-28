#!/bin/bash
#set -x
get_sha(){
    repo=$1
    docker pull $1 &>/dev/null
    #sha=$(docker image inspect $1 |jq .[0].RootFS.Layers |grep sha)
    sha=$(docker image inspect $1 | jq --raw-output '.[0].RootFS.Layers|.[]')   # [0] means first element of list,[]means all the elments of lists
    echo $sha
    #read -a base_sha <<< $base_sha
    #sha_arr=($sha)
}
is_base (){
    local base_sha    # alpine
    local image_sha   # nginx
    base_repo=$1
    image_repo=$2
    base_sha=$(get_sha $1)
    image_sha=$(get_sha $2)

    found="true"
    for i in $base_sha; do
        for j in $image_sha; do
            if [ "$i" = "$j" ]; then
                #echo "no change, same base image: $i"
                found="false"
                break
            fi
        done
    done
    echo "$found"
}

image_version(){
    local version
    repo=$1    # nginx repo
    version=$(docker run -it $1 /bin/sh -c "nginx -v" |awk '{print$3}')
    echo $version
}

compare (){
    result=$(is_base $1 $2)
    version1=$(image_version $3)
    version2=$(image_version $4)
    if [ $result == "true" ] || [ "$version1" != "$version2" ];
    then
        echo "true"
    else
        echo "false"
    fi
}

#is_base "vmnet8/alpine:latest"  "vmnet8/nginx-tags:alpine-x86"
#flag=$(is_base "vmnet8/alpine:latest"  "vmnet8/nginx-tags:alpine-x86")
#echo $flag
#is_base "treehouses/nginx:1.18" "treehouses/turtleblocksjs-tags:x86"
#is_base "treehouses/alpine:3.11"  "treehouses/nginx:latest"
#get_sha "treehouses/alpine:latest"
#get_sha $1
#is_base
#image_version $1
#compare $@
