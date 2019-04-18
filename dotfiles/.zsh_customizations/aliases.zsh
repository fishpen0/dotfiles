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
    awsacct_tools=(aws terraform)
    profiles=$(grep '^[[]profile' <~/.aws/config | awk '{print $2}' | sed 's/]$//')

    if [ $# -eq 0 ]
    then
        echo $profiles
    else
        export AWS_DEFAULT_PROFILE=$1
        for i in ${awsacct_tools[@]}; do
            alias $i="aws-vault exec --assume-role-ttl=60m $AWS_DEFAULT_PROFILE -- $i"
        done
    fi
}

function awscssh() {
    if [[ $AWS_DEFAULT_PROFILE == "default" ]]
    then 
        echo "please set your aws profile with awsacct"
    else
        tmux-cssh `get-instance-ips $1 $2` 
    fi
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
alias dotfiles="code $GIT_DIR_PERSONAL/dotfiles"

##############
# Kubernetes #
##############

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

function kube_on {
    export KUBERNETES_DISPLAY=1
}

function kube_off {
    export KUBERNETES_DISPLAY=0
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