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
{{ $totalLanguageSeconds := 0 }}
{{ range $index, $lang := slice wakatimeData.Languages 0 15 }}
**{{ $lang.Name }}**: {{ $lang.Text }} ({{ $lang.TotalSeconds }}s, {{ printf "%.2f" $lang.Percent }}%)
{{ $totalLanguageSeconds = add $totalLanguageSeconds $lang.TotalSeconds }}
{{ end }}

**Sum of top 15 language seconds**: {{ $totalLanguageSeconds }}
**Language total vs API total difference**: {{ sub wakatimeData.TotalSeconds $totalLanguageSeconds }} seconds

## Raw Time Calculations Check
{{ $manualTotal := 0 }}
**Manual Project Addition:**
{{ range wakatimeData.Projects }}
- {{ .Name }}: {{ .TotalSeconds }}s ({{ .Text }})
{{ $manualTotal = add $manualTotal .TotalSeconds }}
{{ end }}
**Manual Total**: {{ $manualTotal }} seconds
**Manual Total in Hours/Minutes**: {{ div $manualTotal 3600 }}h {{ div (mod $manualTotal 3600) 60 }}m

## DISCREPANCY ANALYSIS
- **API Reports Total**: {{ wakatimeData.TotalSeconds }} seconds ({{ wakatimeData.HumanReadableTotal }})
- **Sum of All Projects**: {{ $manualTotal }} seconds ({{ div $manualTotal 3600 }}h {{ div (mod $manualTotal 3600) 60 }}m)
- **Missing/Extra Time**: {{ sub wakatimeData.TotalSeconds $manualTotal }} seconds
- **Percentage Difference**: {{ if ne $manualTotal 0 }}{{ printf "%.1f" (mul (div (sub wakatimeData.TotalSeconds $manualTotal) $manualTotal) 100) }}%{{ else }}N/A{{ end }}

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

## SUMMARY OF ISSUES FOUND
{{ $projectTotal := 0 }}
{{ range wakatimeData.Projects }}{{ $projectTotal = add $projectTotal .TotalSeconds }}{{ end }}
{{ if ne wakatimeData.TotalSeconds $projectTotal }}
🚨 **MAJOR DISCREPANCY DETECTED**:
- API claims total: {{ wakatimeData.HumanReadableTotal }} ({{ wakatimeData.TotalSeconds }}s)
- Projects actually sum to: {{ div $projectTotal 3600 }}h {{ div (mod $projectTotal 3600) 60 }}m ({{ $projectTotal }}s)
- **Missing/Extra**: {{ sub wakatimeData.TotalSeconds $projectTotal }} seconds ({{ printf "%.1f" (div (sub wakatimeData.TotalSeconds $projectTotal) 60.0) }} minutes)

**POSSIBLE CAUSES**:
1. API aggregation bug in Hackatime
2. Data sync issues between different API endpoints
3. Hidden/uncategorized time not shown in projects breakdown
4. Time range mismatch between total and breakdown calls
{{ else }}
✅ **NO DISCREPANCY**: Project times sum correctly to API total
{{ end }}

Debug complete - check for time discrepancies above.
