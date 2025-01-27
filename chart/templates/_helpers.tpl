{{/*
[GENERAL]
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
[GCP]
Helper template to get a GCP zone in the GCP region based on hash of the VM name
The consistency is needed since the function is called in more than one template
*/}}
{{- define "getZone" -}}
{{- $regionZoneMap := index . 0 -}}
{{- $region := trim (index . 1) -}}  {{/* Trim whitespace */}}
{{- $vmName := index . 2 -}}

{{- if hasKey $regionZoneMap $region -}}
    {{- $zones := index $regionZoneMap $region -}}
    {{- if gt (len $zones) 0 -}}
        {{- $hash := sha256sum $vmName -}}
        {{- $hashSlice := trunc 8 $hash -}}
        {{- $hashInt := (mod (atoi $hashSlice) (len $zones)) -}}  {{/* Convert to int and calculate index */}}
        {{- index $zones $hashInt -}}
    {{- else -}}
        {{- fail (printf "No zones available for region %s" $region) -}}
    {{- end -}}
{{- else -}}
    {{- fail (printf "Region %s not found in region zone map" $region) -}}
{{- end -}}
{{- end -}}

{{/*
[AWS]
This helper template is used to find the AMI based on the region, OS, version, and architecture.
*/}}
{{- define "getAMI" -}}
{{- $region := index . 0 -}}
{{- $os := index . 1 -}}
{{- $version := index . 2 -}}
{{- $arch := index . 3 -}}
{{- $amiData := index . 4 -}}

{{- if and $region $os $version $arch -}}
  {{- if hasKey $amiData "amis" -}}
    {{- $amis := index $amiData "amis" -}}
    {{- if hasKey $amis $region -}}
      {{- $regionData := index $amis $region -}}
      {{- $found := dict -}}
      {{- range $entry := $regionData -}}
        {{- if and (eq $entry.os $os) (eq $entry.version $version) (eq $entry.arch $arch) -}}
          {{- $found = $entry -}}
        {{- end -}}
      {{- end -}}
      {{- if not (empty $found) -}}
        {{- $found.ami -}}
      {{- else -}}
        {{- fail (printf "No AMI found for OS %s version %s architecture %s in region %s" $os $version $arch $region) -}}
      {{- end -}}
    {{- else -}}
      {{- fail (printf "No AMI data found for region %s" $region) -}}
    {{- end -}}
  {{- else -}}
    {{- fail (printf "Invalid AMI data structure: missing 'amis' key") -}}
  {{- end -}}
{{- else -}}
  {{- fail (printf "Missing required parameters: region, os, version, or architecture") -}}
{{- end -}}
{{- end -}}
