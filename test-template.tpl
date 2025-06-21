# Test Template for Wakatime Debug

## Basic Wakatime Data Test

### Test 1: Simple Total Time
Total time: {{ wakatimeData.HumanReadableTotal }}

### Test 2: Languages List
{{ range wakatimeData.Languages }}
- {{ .Name }}: {{ .Percent }}%
{{ end }}

### Test 3: Projects List
{{ range wakatimeData.Projects }}
- {{ .Name }}: {{ .Percent }}%
{{ end }}

### Test 4: Simple Category Bar
{{ wakatimeData.Languages | wakatimeCategoryBar 5 }}

### Test 5: Double Category Bar (Original Goal)
{{ wakatimeDoubleCategoryBar "💾 Languages:" wakatimeData.Languages "💼 Projects:" wakatimeData.Projects 5 }}

---
Debug complete!
