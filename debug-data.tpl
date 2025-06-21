# Hackatime Data Structure Debug

## Raw Data Inspection

### Basic Info Check
{{ if wakatimeData }}
✅ wakatimeData is available
{{ else }}
❌ wakatimeData is NOT available
{{ end }}

### Total Time Debug
- HumanReadableTotal: "{{ wakatimeData.HumanReadableTotal }}"
- TotalSeconds: {{ wakatimeData.TotalSeconds }}
- DailyAverage: {{ wakatimeData.DailyAverage }}
- Status: "{{ wakatimeData.Status }}"
- Username: "{{ wakatimeData.Username }}"
- UserID: "{{ wakatimeData.UserID }}"

### Time Range
- Start: "{{ wakatimeData.Start }}"
- End: "{{ wakatimeData.End }}"
- Range: "{{ wakatimeData.Range }}"
- HumanReadableRange: "{{ wakatimeData.HumanReadableRange }}"

### Languages Array Debug
Languages count: {{ len wakatimeData.Languages }}
{{ if wakatimeData.Languages }}
Languages available: YES
{{ range $index, $lang := wakatimeData.Languages }}
Language {{ $index }}:
  - Name: "{{ $lang.Name }}"
  - TotalSeconds: {{ $lang.TotalSeconds }}
  - Percent: {{ $lang.Percent }}
  - Digital: "{{ $lang.Digital }}"
  - Text: "{{ $lang.Text }}"
  - Hours: {{ $lang.Hours }}
  - Minutes: {{ $lang.Minutes }}
  - Seconds: {{ $lang.Seconds }}
{{ end }}
{{ else }}
Languages: EMPTY or NULL
{{ end }}

### Projects Array Debug
Projects count: {{ len wakatimeData.Projects }}
{{ if wakatimeData.Projects }}
Projects available: YES
{{ range $index, $proj := wakatimeData.Projects }}
Project {{ $index }}:
  - Name: "{{ $proj.Name }}"
  - TotalSeconds: {{ $proj.TotalSeconds }}
  - Percent: {{ $proj.Percent }}
  - Digital: "{{ $proj.Digital }}"
  - Text: "{{ $proj.Text }}"
  - Hours: {{ $proj.Hours }}
  - Minutes: {{ $proj.Minutes }}
  - Seconds: {{ $proj.Seconds }}
{{ end }}
{{ else }}
Projects: EMPTY or NULL
{{ end }}

### Categories Debug
Categories count: {{ len wakatimeData.Categories }}
{{ if wakatimeData.Categories }}
{{ range $index, $cat := wakatimeData.Categories }}
Category {{ $index }}: "{{ $cat.Name }}" - {{ $cat.Percent }}% - {{ $cat.Text }}
{{ end }}
{{ else }}
Categories: EMPTY or NULL
{{ end }}

### Editors Debug
Editors count: {{ len wakatimeData.Editors }}
{{ if wakatimeData.Editors }}
{{ range $index, $editor := wakatimeData.Editors }}
Editor {{ $index }}: "{{ $editor.Name }}" - {{ $editor.Percent }}% - {{ $editor.Text }}
{{ end }}
{{ else }}
Editors: EMPTY or NULL
{{ end }}

### Operating Systems Debug
OS count: {{ len wakatimeData.OperatingSystems }}
{{ if wakatimeData.OperatingSystems }}
{{ range $index, $os := wakatimeData.OperatingSystems }}
OS {{ $index }}: "{{ $os.Name }}" - {{ $os.Percent }}% - {{ $os.Text }}
{{ end }}
{{ else }}
Operating Systems: EMPTY or NULL
{{ end }}

### Best Day Debug
{{ if wakatimeData.BestDay }}
Best Day:
  - Date: "{{ wakatimeData.BestDay.Date }}"
  - Text: "{{ wakatimeData.BestDay.Text }}"
  - TotalSeconds: {{ wakatimeData.BestDay.TotalSeconds }}
{{ else }}
Best Day: EMPTY or NULL
{{ end }}

### Flags and Status
- IsUpToDate: {{ wakatimeData.IsUpToDate }}
- IsAlreadyUpdating: {{ wakatimeData.IsAlreadyUpdating }}
- IsCodingActivityVisible: {{ wakatimeData.IsCodingActivityVisible }}
- PercentCalculated: {{ wakatimeData.PercentCalculated }}
- DaysIncludingHolidays: {{ wakatimeData.DaysIncludingHolidays }}
- DaysMinusHolidays: {{ wakatimeData.DaysMinusHolidays }}
- Holidays: {{ wakatimeData.Holidays }}

---
Debug complete - check all sections above for data availability
