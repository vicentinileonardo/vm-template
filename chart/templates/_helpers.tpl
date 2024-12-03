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
