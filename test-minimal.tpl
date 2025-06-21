# Wakatime Connection Test

## Test 1: Basic Total Time
Total: {{ wakatimeData.HumanReadableTotal }}

## Test 2: Raw Languages Data
{{ range wakatimeData.Languages }}
- {{ .Name }}: {{ .Text }} ({{ .Percent }}%)
{{ end }}

## Test 3: Raw Projects Data
{{ range wakatimeData.Projects }}
- {{ .Name }}: {{ .Text }} ({{ .Percent }}%)
{{ end }}

## Test 4: First Language Only
{{ with index wakatimeData.Languages 0 }}
Top Language: {{ .Name }} - {{ .Text }}
{{ end }}

End of test.
