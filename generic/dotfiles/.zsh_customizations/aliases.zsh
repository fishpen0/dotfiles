#@IgnoreInspection BashAddShebang

# ZSH Related
alias reload=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"

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
bucketsize() {
    local env=$1
    local region=$2
    local bucket=$3

    local now=$(date +%s)
    local data=$(aws-vault exec "${env}" -- aws cloudwatch get-metric-statistics --namespace AWS/S3 --start-time "$(echo "${now} - 86400" | bc)" --end-time "${now}" --period 86400 --statistics Average --region "${region}"  --metric-name BucketSizeBytes --dimensions Name=BucketName,Value="${bucket}" Name=StorageType,Value=StandardStorage)
    local sizeinbytes=$(echo $data | jq '.Datapoints | .[] | .Average')
    echo ${sizeinbytes}
}

bucketcost() {
    local env=$1
    local region=$2
    local bucket=$3

    local sizeinbytes=$(bucketsize ${env} ${region} ${bucket})
    local cost="$((0.024 * (${sizeinbytes} / 10000000000.0)))"
    echo $cost
}