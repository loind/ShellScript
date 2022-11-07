#/bin/bash

SLACK_URL="###SLACK_URL###"
message_slack=""

ARRAY_IMAGES=`kubectl get pods -n mobio -o jsonpath="{.items[*].spec.containers[*].image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c | awk '{print($2)}'`
for image in ${ARRAY_IMAGES[@]}
do
    result=`trivy -q image --ignore-unfixed --security-checks vuln --skip-update --format template --template '{{- $critical := 0 }}{{- $high := 0 }}{{- $medium := 0 }}{{- $total :=0 }}{{- range . }}{{- range .Vulnerabilities }}{{- if  eq .Severity "CRITICAL" }}{{- $critical = add $critical 1 }}{{- end }}{{- if  eq .Severity "HIGH" }}{{- $high = add $high 1 }}{{- end }}{{- if  eq .Severity "MEDIUM" }}{{- $medium = add $medium 1 }}{{- end }}{{- end }}{{- end }}{{- $total = add $critical $high $medium }}{{ $total }};Critical: {{ $critical }}, High: {{ $high }}, MEDIUM: {{ $medium }}' $image`
    IFS=";" read total_error detail_error <<< "$result"
    if [[ $total_error -gt 0 ]];
    then
        text="\`$image\`: $detail_error"
        message_slack="$message_slack\n$text"
    fi
done

if [[ ${#message_slack} -gt 0 ]];
then
    PAYLOAD="{
      \"attachments\": [
        {
          \"pretext\": \"Danh sách image bị lỗi bảo mật trong cụm máy test\",
          \"text\": \"$message_slack\",
          \"color\": \"#EED202\",
          \"mrkdwn_in\": [\"text\"],
        }
      ]
    }"
    /usr/bin/curl -s -X POST --data-urlencode "payload=$PAYLOAD" $SLACK_URL
fi
