#!/bin/bash

# Date lable
DATE='date+%Y%m%d-%H%M%S'

# Arguments are required
if [ $# -eq 0]
  then
    echo "An Argument is Required"
    echo "-----------------------------"
    echo "Choose one of the following:"
    echo "1) vshpere-base"
    echo "-----------------------------"
else
  case "$1" in
    vsphere-base)
      packer build -var "image_name=golden-ubuntu-image-$DATE" /vsphere/base.json
      ;;
    *)
    # other-base)
    #   packer build -var "image_name=golden-ubuntu-image-$DATE" /other/base.json
    #   ;;
    # *)    
      echo "Could not match the option provided."
      echo "Please try again."
      exit 1
      ;;
  esac
fi
