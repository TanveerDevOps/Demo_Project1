#!/bin/bash
sed "s/tagVersion/$1/g" pods.yml > my-app-pod.yml
