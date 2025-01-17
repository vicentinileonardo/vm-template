{{/*
This helper template is used to find the best VM size based on the CPU and Memory requirements.
*/}}
{{- define "findBestVmSize" -}}
{{- $cpu := .cpu -}}
{{- $memory := .memory -}}
{{- $vmSizes := .vmSizes -}}
{{- $defaultVmSize := .defaultVmSize -}}
{{- $cpuThreshold := .cpuThreshold | default 1 -}}
{{- $memoryThreshold := .memoryThreshold | default 2 -}}
{{- $minDiff := 9999 -}}
{{- $bestMatch := $defaultVmSize -}}

{{- range $vmSizes }}
    {{- $cpuDiff := sub (max $cpu .cpu) (min $cpu .cpu) -}}
    {{- $memoryDiff := sub (max $memory .memory) (min $memory .memory) -}}
    
    {{- if and (le $cpuDiff $cpuThreshold) (le $memoryDiff $memoryThreshold) }}
        {{- $totalDiff := add $cpuDiff $memoryDiff -}}
        {{- if le $totalDiff $minDiff }}
            {{- $minDiff = $totalDiff -}}
            {{- $bestMatch = .size -}}
        {{- end }}
    {{- end }}
{{- end }}

{{- $bestMatch -}}
{{- end -}}

{{/*
This helper template is used to find the AMI based on the region, OS and version.
*/}}
{{- define "getAMI" -}}
{{- $region := index . 0 -}}
{{- $os := index . 1 -}}
{{- $version := index . 2 -}}
{{- $amiData := (.Files.Get "aws_ami.yaml") | fromYaml }}

{{- if hasKey $amiData $region -}}
  {{- $regionData := index $amiData $region -}}
  {{- $found := dict -}}
  {{- range $entry := $regionData -}}
    {{- if and (eq $entry.os $os) (eq $entry.version $version) -}}
      {{- $found = $entry -}}
    {{- end -}}
  {{- end -}}
  {{- if $found -}}
    {{- $found.ami -}}
  {{- else -}}
    {{- fail (printf "No AMI found for OS %s version %s in region %s" $os $version $region) -}}
  {{- end -}}
{{- else -}}
  {{- fail (printf "No AMI data found for region %s" $region) -}}
{{- end -}}
{{- end -}}
