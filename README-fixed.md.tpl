# Hi there, I'm Daniel 👋

## A silly Italian compooters guy :3

# 🚀 Tech Stack

[![Python](https://img.shields.io/badge/Python-3.13%2B-blue?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Rust](https://img.shields.io/badge/Rust-1.87%2B-black?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110.0%2B-green?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![React](https://img.shields.io/badge/React-19.1.0%2B-blue?style=for-the-badge&logo=react&logoColor=white)](https://react.dev/)
[![Electron](https://img.shields.io/badge/Electron-36.2.0%2B-dark?style=for-the-badge&logo=electron&logoColor=white)](https://www.electronjs.org/)

---

## 📊 Coding Stats

[![Hackatime](https://img.shields.io/badge/Hackatime-Hack%20Club-orange?style=for-the-badge&logo=wakatime&logoColor=white)](https://hackatime.hackclub.com)

{{ $totalProjectSeconds := 0 }}
{{ range wakatimeData.Projects }}
{{ $totalProjectSeconds = add $totalProjectSeconds .TotalSeconds }}
{{ end }}
{{ $totalHours := div $totalProjectSeconds 3600 }}
{{ $remainingMinutes := div (mod $totalProjectSeconds 3600) 60 }}

⏱️ **Total coding time this week:** {{ $totalHours }}h {{ $remainingMinutes }}m

```text
💾 Languages:
{{ range $index, $lang := wakatimeData.Languages }}{{ if lt $index 10 }}{{ printf "%-20s" $lang.Name }} {{ printf "%10s" $lang.Text }}   {{ printf "%s" (repeat "█" (div (mul $lang.Percent 25) 100)) }}{{ printf "%s" (repeat "░" (sub 25 (div (mul $lang.Percent 25) 100))) }}  {{ printf "%.2f" $lang.Percent }}%
{{ end }}{{ end }}

💼 Projects:
{{ range $index, $proj := wakatimeData.Projects }}{{ if lt $index 10 }}{{ printf "%-20s" $proj.Name }} {{ printf "%10s" $proj.Text }}   {{ printf "%s" (repeat "█" (div (mul $proj.Percent 25) 100)) }}{{ printf "%s" (repeat "░" (sub 25 (div (mul $proj.Percent 25) 100))) }}  {{ printf "%.2f" $proj.Percent }}%
{{ end }}{{ end }}
```

**📝 Note:** *Total time calculated from individual project data to ensure accuracy. {{ if ne wakatimeData.TotalSeconds $totalProjectSeconds }}API reported {{ wakatimeData.HumanReadableTotal }} but projects sum to {{ $totalHours }}h {{ $remainingMinutes }}m.{{ end }}*

*Data last updated: {{ wakatimeData.Start }} to {{ wakatimeData.End }}*

---

## Info
[![About Me](https://img.shields.io/badge/About--Me-black?style=for-the-badge&logo=numpy&logoColor=white)](https://danielscos.github.io/about_me)

---

> "Code is like humor. When you have to explain it, it's bad." – Cory House
