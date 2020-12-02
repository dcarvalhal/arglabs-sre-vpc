#! /bin/bash

export TFBIN="terraform"
export WORKSPACE=$2
export AUTO_APPROVE="-auto-approve"

if [ "$ARGLABS_BUCKET" != "" -a "$ARGLABS_BUCKET_REGION" != "" ]; then
  export BUCKET_OPTIONS="-backend-config=bucket=$ARGLABS_BUCKET -backend-config=region=$ARGLABS_BUCKET_REGION"
  export TF_VAR_bucket=$ARGLABS_BUCKET
  export TF_VAR_bucket_region=$ARGLABS_BUCKET_REGION
fi

function f_terraform() {
  cd terraform
  echo "-----------------------------------------------"
  $TFBIN init -reconfigure $BUCKET_OPTIONS     || exit 1
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
  echo "$0 <apply|destroy|plan> <workspace>"
  exit 1
}


if [ "$WORKSPACE" == "" ]; then
  f_usage
fi

case $1 in
  apply|destroy)        f_terraform $1 $WORKSPACE;;
  plan) AUTO_APPROVE="" f_terraform $1 $WORKSPACE;;
  *) f_usage ;;
esac

echo "run.sh done."
