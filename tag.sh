#!/bin/bash
sed "s/tagVersion/$1/g" pod.yml > my-app-pod.yml
