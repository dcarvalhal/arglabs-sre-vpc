#! /bin/bash

export TFBIN="terraform"
export WORKSPACE=$2
export AUTO_APPROVE="-auto-approve"

function f_terraform() {
  cd terraform
  echo "-----------------------------------------------"
  $TFBIN init                        || exit 1
  echo "-----------------------------------------------"
  echo "Setting workspace: $WORKSPACE"
  $TFBIN workspace new    $WORKSPACE 2> /dev/null
  $TFBIN workspace select $WORKSPACE || exit 1 
  echo "-----------------------------------------------"
  $TFBIN $1 $AUTO_APPROVE            || exit 1 
  echo "-----------------------------------------------"
  cd ..
  echo -e "`pwd`: finished !!"
}


function f_usage() {
  echo "$0 <apply|destroy|plan> <global|staging|production>"
  exit 1
}


case $WORKSPACE in
  global|staging|production) true ;;
  *) f_usage ;;
esac

case $1 in
  apply|destroy)        f_terraform $1 $WORKSPACE;;
  plan) AUTO_APPROVE="" f_terraform $1 $WORKSPACE;;
  *) f_usage ;;
esac

echo "run.sh done."
