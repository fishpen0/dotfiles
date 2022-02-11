#@IgnoreInspection BashAddShebang

# ZSH Related
alias reload=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"

# Assume vscode should open current dir
function smart_code() {
    if [[ -z $1 ]] ; then
        command code .
    else
        command code "$@"
    fi
}
alias code=smart_code

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

#################
# AWS Shortcuts #
#################

function awsacct() {
    declare -A accounts=( [circle-dev]=124945441934 [circle-ops]=514563129364 [circle-pay]=908968368384 [circle-platform]=683583236714 )
    if [ $# -eq 0 ]
    then
        aws configure list-profiles
    else
        eval $(op signin circlefin)
        export AWS_PROFILE=$1
        export AWS_DEFAULT_PROFILE=$1
        echo -e `op get totp onelogin` | aws-auth-onelogin -u  `op get item onelogin --fields username` --onelogin-password `op get item onelogin --fields password` -p $1 --aws-role-name CFN-Circle-SSO-Ops --aws-account-id ${accounts[$1]}
    fi
}

function eksctx() {
  export KUBERNETES_DISPLAY=1
  if [ $# -eq 0 ]
  then
      kubectx
  else
      aws eks --region us-east-1 update-kubeconfig --name $1 --alias $1
  fi
}

function awslogin() {
  echo -e `op get totp onelogin` | aws-auth-onelogin -u  `op get item onelogin --fields username` --onelogin-password `op get item onelogin --fields password` -p circle-dev --aws-role-name CFN-Circle-SSO-Ops --aws-account-id 124945441934
  echo -e `op get totp onelogin` | aws-auth-onelogin -u  `op get item onelogin --fields username` --onelogin-password `op get item onelogin --fields password` -p circle-ops --aws-role-name CFN-Circle-SSO-Ops --aws-account-id 514563129364
  echo -e `op get totp onelogin` | aws-auth-onelogin -u  `op get item onelogin --fields username` --onelogin-password `op get item onelogin --fields password` -p circle-pay --aws-role-name CFN-Circle-SSO-DevOps --aws-account-id 908968368384
  echo -e `op get totp onelogin` | aws-auth-onelogin -u  `op get item onelogin --fields username` --onelogin-password `op get item onelogin --fields password` -p circle-platform --aws-role-name CFN-Circle-SSO-DevOps --aws-account-id 683583236714
}

function awscssh() {
    if [[ $AWS_DEFAULT_PROFILE == "default" ]]
    then 
        echo "please set your aws profile with awsacct"
    else
        tmux-cssh `get-instance-ips $1 $2` 
    fi
}

function awscommand() {

}

function bucketsize() {
    local env=$1
    local region=$2
    local bucket=$3

    local now=$(date +%s)
    local data=$(aws-vault exec "${env}" -- aws cloudwatch get-metric-statistics --namespace AWS/S3 --start-time "$(echo "${now} - 86400" | bc)" --end-time "${now}" --period 86400 --statistics Average --region "${region}"  --metric-name BucketSizeBytes --dimensions Name=BucketName,Value="${bucket}" Name=StorageType,Value=StandardStorage)
    local sizeinbytes=$(echo $data | jq '.Datapoints | .[] | .Average')
    echo ${sizeinbytes}
}

function bucketcost() {
    local env=$1
    local region=$2
    local bucket=$3

    local sizeinbytes=$(bucketsize ${env} ${region} ${bucket})
    local cost="$((0.024 * (${sizeinbytes} / 10000000000.0)))"
    echo $cost
}

function get-instance-ips() {
    if [[ $AWS_DEFAULT_PROFILE == "default" ]]
    then 
        echo "please set your aws profile with awsacct"
    else
        env=$1
        roles=$2
        aws-vault exec --assume-role-ttl=60m $AWS_DEFAULT_PROFILE -- aws ec2 describe-instances --filters "Name=tag:roles,Values=$roles" "Name=tag:env,Values=$env" --query "Reservations[*].Instances[*].PrivateIpAddress" --output=text
    fi
}

function get-instance-ids() {
    if [[ $AWS_DEFAULT_PROFILE == "default" ]]
    then 
        echo "please set your aws profile with awsacct"
    else
        env=$1
        roles=$2
        aws-vault exec --assume-role-ttl=60m $AWS_DEFAULT_PROFILE -- aws ec2 describe-instances --filters "Name=tag:roles,Values=$roles" "Name=tag:env,Values=$env" --query "Reservations[*].Instances[*].PrivateIpAddress" --output=text
    fi
}

function ecr-login() {
    # $(aws ecr get-login --no-include-email --registry-ids 514563129364)
    # $(aws ecr get-login --no-include-email --registry-ids 683583236714)
    # $(aws ecr get-login --no-include-email --registry-ids 124945441934)

    aws ecr get-login-password --region=us-east-1 | docker login --username AWS --password-stdin 514563129364.dkr.ecr.us-east-1.amazonaws.com
    aws ecr get-login-password --region=us-east-1 | docker login --username AWS --password-stdin 683583236714.dkr.ecr.us-east-1.amazonaws.com
    aws ecr get-login-password --region=us-east-1 | docker login --username AWS --password-stdin 124945441934.dkr.ecr.us-east-1.amazonaws.com
}


function rds-vacuum-logs() {
    local env=$1
    local region=us-west-2
    local db_name=roleiq-production
    # local schema_name=roleiq
    # local table_name=table1
    local hours_to_check=24

    $(aws-vault exec "${env}" -- aws rds describe-db-log-files --region ${region} --db-instance-identifier ${db_name} --output text | sort -k2 -n | tail -${hours_to_check} | awk -F' ' '{print $3}' )# | while read i;
    # do
    # aws rds download-db-log-file-portion --region ${region} --db-instance-identifier ${db_name} --log-file-name ${i} --output text | grep -A 5 "automatic vacuum of table \"${db_name}.${schema_name}.${table_name}\""
    # done 
}

#############
# Git Repos #
#############
GIT_DIR_PERSONAL="~/dev/personal"
GIT_DIR_WORK="~/dev/circle"
alias dotfiles="code $GIT_DIR_PERSONAL/dotfiles"

##############
# Kubernetes #
##############

function kube_on {
    export KUBERNETES_DISPLAY=1
}

function kube_off {
    unset KUBERNETES_DISPLAY
}

function kubeacct {
    if [ -z "$1" ]
    then
        kubectl config get-contexts
    else
        kubectl config use-context $1
        export TILLER_NAMESPACE=$1
        
    fi
}

function kubens {
    if [ -z "$1" ]
    then
        /usr/local/bin/kubens
    else
        namespace=$1
        /usr/local/bin/kubens $namespace
        export TILLER_NAMESPACE=$namespace
    fi
}

###########
# Network #
###########

function spoof(){
    local old_mac=$(ifconfig en0 | grep ether | awk '{print $2}')
    local new_mac=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`
    sudo ifconfig en0 ether $new_mac
    echo "$old_mac => $new_mac"
}

function unspoof(){
    echo "TODO: MAKE THIS WORK"
}

#############
# 1password #
#############

1pass () {
    eval $(op signin circlefin)
}

#############
# Terraform #
#############

function tf() {
    select FILENAME in *;
    do
        case $FILENAME in
            "$QUIT")
            echo "Exiting."
            break
            ;;
            *)
            echo "You picked $FILENAME ($REPLY)"
            ;;
    esac
    done
}

#########
# Other #
#########
function slackify() {
  LENGTH=$((${#1}*${#2}))
  echo $LENGTH
  if [ $LENGTH -gt 4000 ]; then
    echo "Your string is too long"
  else
    figlet -f banner "$1" | sed -e's/#/'$2'/g' | sed -e's/ /:blank:/g' | pbcopy
  fi
}

######################
# ZSH Theme segments #
######################

zsh_aws() {
  if [ "$AWS_DEFAULT_PROFILE" != "default" ]; then
    local color='%F{208}'
    echo -n "\ue7ad ${AWS_DEFAULT_PROFILE}"
  fi
}

zsh_kubernetes() {
  if [[ ${KUBERNETES_DISPLAY} ]]; then
    context=$(kubectl config current-context | awk -F\. '{print $1}')
    namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
    local color='%F{68}'
    echo -n "\ufd31 ${context} | ${namespace}"
  fi
}

zsh_randicon(){ 
  randicons=(
    "\uf1a8" # Pied Piper
    "\uf2cd" # Bathtub
    "\ue286" # Biohazard
    "\ue28d" # Bread
    "\ue28c" # Brain
    "\ue29f" # Chicken
    "\ue260" # king
    "\ue273" # donut
    "\ue24b" # intestines
    "\ue231" # poison
    "\ue238" # radioactive
    "\uf614" # hundo
    "\uf64e" # clippy
    "\uf6e4" # duck
    "\uf79f" # ghost
    "\ue36a" # meteor
    "\ue36e" # alien
    "\ue000" # japanese arch
    "\ue006" # palm tree
    "\uf483" #squirrel
    "\uf427" # rocket
    "\uf490" # fire
    "\uf499" # beaker
    "\uf7b3" # controller
    "\ufa2a" # traffic light
    "\ufa28" # tooth
    "\ufb67" # test tube
    "\ue219" # taco
    "\ue251" # hotdog
    "\ufb8a" # skull
    "\ufb08" # saxophone
    "\uf901" # pill
    "\uf872" # creeper
    "\uf855" # martini
    "\ufcd3" # lava lamp
    "\ue24d" # burger
    "\uf7a4" # glass flute
    "\uf7a5" # mug
    "\uf699" # cow
  )
  random=$(($[$$$(date +%s) % ${#randicons[@]}] + 1))
  echo -n "${randicons[$random]}"
}

zsh_terraform() {
  # break if there is no .terraform directory
  if [[ -d .terraform ]]; then
    local tf_workspace=$(/usr/local/bin/terraform workspace show)
    # local tf_short_workspace=${tf_workspace:0:1:u}
    local tf_region=$(readlink backend.tf | awk -F. '{print $3}')

    if [[ $tf_short_workspace == "P" ]]
    then
      local color='%F{red}'
    else
      local color='%F{white}'
    fi 

    case $tf_region in
      us-west-2)
        local tf_short_region="UW2"
        ;;
      us-west-2)
        local tf_short_region="UE2"
        local color='%F{red}'
        ;;
      *)
        local tf_short_region=$tf_region
        local color='%F{yellow}'
        ;;
    esac

    # echo -n "%{$color%}\ufbdf $tf_short_workspace:$tf_short_region%{%f%}"
    echo -n "%{$color%}\ufbdf $tf_workspace%{%f%}"
  fi
}