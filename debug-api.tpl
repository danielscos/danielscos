# Hackatime API Debug Test

## Connection Test
Attempting to connect to Hackatime API...

## Basic Data Test
{{ if wakatimeData }}
✅ Wakatime data loaded successfully!

### Total Time
Total coding time: {{ wakatimeData.HumanReadableTotal }}

### Available Data
{{ if wakatimeData.Languages }}
Languages count: {{ len wakatimeData.Languages }}
{{ else }}
❌ No languages data
{{ end }}

{{ if wakatimeData.Projects }}
Projects count: {{ len wakatimeData.Projects }}
{{ else }}
❌ No projects data
{{ end }}

### First Language (if available)
{{ with index wakatimeData.Languages 0 }}
- Name: {{ .Name }}
- Time: {{ .Text }}
- Percent: {{ .Percent }}%
{{ else }}
❌ No language data available
{{ end }}

### First Project (if available)
{{ with index wakatimeData.Projects 0 }}
- Name: {{ .Name }}
- Time: {{ .Text }}
- Percent: {{ .Percent }}%
{{ else }}
❌ No project data available
{{ end }}

{{ else }}
❌ Failed to load wakatime data - API connection issue
{{ end }}

---
Debug completed.
