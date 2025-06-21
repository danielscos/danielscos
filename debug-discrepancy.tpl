# Hackatime Data Discrepancy Debug

## API Endpoint Information
- **API URL**: {{ wakatimeData.Username }}'s data from Hackatime API
- **User ID**: {{ wakatimeData.UserID }}
- **Time Range**: {{ wakatimeData.Range }} ({{ wakatimeData.HumanReadableRange }})
- **Start Date**: {{ wakatimeData.Start }}
- **End Date**: {{ wakatimeData.End }}
- **Status**: {{ wakatimeData.Status }}

## Total Time Analysis
- **API Total**: {{ wakatimeData.HumanReadableTotal }} ({{ wakatimeData.TotalSeconds }} seconds)
- **Daily Average**: {{ wakatimeData.DailyAverage }} seconds/day
- **Days Including Holidays**: {{ wakatimeData.DaysIncludingHolidays }}
- **Days Minus Holidays**: {{ wakatimeData.DaysMinusHolidays }}

## ALL Projects (Complete List)
Total Projects Count: {{ len wakatimeData.Projects }}

{{ range $index, $proj := wakatimeData.Projects }}
**Project {{ add $index 1 }}: {{ $proj.Name }}**
- Raw Seconds: {{ $proj.TotalSeconds }}
- Formatted Time: {{ $proj.Text }}
- Digital Format: {{ $proj.Digital }}
- Percentage: {{ printf "%.2f" $proj.Percent }}%
- Hours: {{ $proj.Hours }}
- Minutes: {{ $proj.Minutes }}
- Seconds: {{ $proj.Seconds }}

{{ end }}

## Project Time Verification
{{ $totalProjectSeconds := 0 }}
{{ range wakatimeData.Projects }}
{{ $totalProjectSeconds = add $totalProjectSeconds .TotalSeconds }}
{{ end }}
- **Sum of all project seconds**: {{ $totalProjectSeconds }}
- **Expected total seconds**: {{ wakatimeData.TotalSeconds }}
- **Difference**: {{ sub wakatimeData.TotalSeconds $totalProjectSeconds }} seconds

## Language Time Analysis (Top 15)
{{ range $index, $lang := slice wakatimeData.Languages 0 15 }}
**{{ $lang.Name }}**: {{ $lang.Text }} ({{ $lang.TotalSeconds }}s, {{ printf "%.2f" $lang.Percent }}%)
{{ end }}

## Raw Time Calculations Check
{{ $manualTotal := 0 }}
**Manual Project Addition:**
{{ range wakatimeData.Projects }}
- {{ .Name }}: {{ .TotalSeconds }}s
{{ $manualTotal = add $manualTotal .TotalSeconds }}
{{ end }}
**Manual Total**: {{ $manualTotal }} seconds

## Time Range Verification
- **Period**: {{ wakatimeData.Start }} to {{ wakatimeData.End }}
- **Timezone**: {{ wakatimeData.Timezone }}
- **Is Up To Date**: {{ wakatimeData.IsUpToDate }}
- **Is Already Updating**: {{ wakatimeData.IsAlreadyUpdating }}
- **Percent Calculated**: {{ wakatimeData.PercentCalculated }}%

## Data Freshness Indicators
- **Created At**: {{ wakatimeData.CreatedAt }}
- **Modified At**: {{ wakatimeData.ModifiedAt }}
- **Is Coding Activity Visible**: {{ wakatimeData.IsCodingActivityVisible }}
- **Writes Only**: {{ wakatimeData.WritesOnly }}

---

**EXPECTED vs ACTUAL**:
- Dashboard osint-news-channel: ~4h 48m (17,280 seconds)
- API osint-news-channel: {{ range wakatimeData.Projects }}{{ if eq .Name "osint-news-channel" }}{{ .Text }} ({{ .TotalSeconds }}s){{ end }}{{ end }}

Debug complete - check for time discrepancies above.
