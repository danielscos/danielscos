#!/usr/bin/env python3
import requests
import os
import json

def fetch_hackatime_data():
    api_key = os.environ.get('WAKATIME_API_KEY')
    if not api_key:
        print("WAKATIME_API_KEY environment variable not found")
        return None

    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }

    # Try different time periods
    endpoints = [
        'https://hackatime.hackclub.com/api/hackatime/v1/users/current/stats/last_7_days',
        'https://hackatime.hackclub.com/api/hackatime/v1/users/current/stats/last_30_days',
        'https://hackatime.hackclub.com/api/hackatime/v1/users/current/stats/last_6_months',
        'https://hackatime.hackclub.com/api/hackatime/v1/users/current/stats/last_year'
    ]

    for endpoint in endpoints:
        try:
            print(f"Trying endpoint: {endpoint}")
            response = requests.get(endpoint, headers=headers, timeout=10)

            if response.status_code == 200:
                data = response.json()
                print(f"✅ Success! Got data from: {endpoint}")
                print(f"Raw response keys: {list(data.keys())}")
                if 'data' in data:
                    stats = data['data']
                    print(f"Stats keys: {list(stats.keys())}")
                    print(f"Total time: {stats.get('human_readable_total', 'N/A')}")
                    print(f"Languages count: {len(stats.get('languages', []))}")
                    print(f"Projects count: {len(stats.get('projects', []))}")

                    # Show first few languages and projects for debugging
                    languages = stats.get('languages', [])
                    projects = stats.get('projects', [])

                    if languages:
                        print("First 3 languages:")
                        for i, lang in enumerate(languages[:3]):
                            print(f"  {i+1}. {lang.get('name', 'Unknown')}: {lang.get('text', 'N/A')} ({lang.get('percent', 0):.1f}%)")

                    if projects:
                        print("First 3 projects:")
                        for i, proj in enumerate(projects[:3]):
                            print(f"  {i+1}. {proj.get('name', 'Unknown')}: {proj.get('text', 'N/A')} ({proj.get('percent', 0):.1f}%)")

                return data
            else:
                print(f"❌ {endpoint} returned {response.status_code}: {response.text}")

        except Exception as e:
            print(f"❌ Error with {endpoint}: {e}")
            continue

    print("All endpoints failed")
    return None

def format_time(seconds):
    if seconds < 3600:
        return f"{int(seconds // 60)} mins"
    else:
        hours = int(seconds // 3600)
        minutes = int((seconds % 3600) // 60)
        if minutes > 0:
            return f"{hours} hrs {minutes} mins"
        return f"{hours} hrs"

def create_progress_bar(percent, length=25):
    filled = int(length * percent / 100)
    return '█' * filled + '░' * (length - filled)

def generate_double_category_bar(languages, projects, count=None):
    # Show ALL languages and projects to debug totals
    content = "💾 Languages (ALL):\n"
    lang_total_seconds = 0
    for i, lang in enumerate(languages):
        name = lang['name']
        time_text = lang['text']
        percent = lang['percent']
        seconds = lang.get('total_seconds', 0)
        lang_total_seconds += seconds
        bar = create_progress_bar(percent)
        content += f"{name:<12} {time_text:>12}  {bar}  {percent:.1f}% ({seconds}s)\n"

    content += f"\nLanguages Total: {format_time(lang_total_seconds)} ({lang_total_seconds} seconds)\n"

    content += "\n💼 Projects (ALL):\n"
    proj_total_seconds = 0
    for i, proj in enumerate(projects):
        name = proj['name']
        time_text = proj['text']
        percent = proj['percent']
        seconds = proj.get('total_seconds', 0)
        proj_total_seconds += seconds
        bar = create_progress_bar(percent)
        content += f"{name:<12} {time_text:>12}  {bar}  {percent:.1f}% ({seconds}s)\n"

    content += f"\nProjects Total: {format_time(proj_total_seconds)} ({proj_total_seconds} seconds)\n"

    return content

def update_readme():
    data = fetch_hackatime_data()
    if not data:
        print("Failed to fetch Hackatime data")
        return

    print("\n=== DEBUG: Full API Response ===")
    print(json.dumps(data, indent=2))
    print("=== END DEBUG ===\n")

    stats = data.get('data', {})
    total_time = stats.get('human_readable_total', 'N/A')
    languages = stats.get('languages', [])
    projects = stats.get('projects', [])

    print(f"Processing {len(languages)} languages and {len(projects)} projects")

    # Calculate actual totals from the data
    total_seconds_from_api = stats.get('total_seconds', 0)
    print(f"API claims total: {total_time} ({total_seconds_from_api} seconds)")

    if languages:
        lang_sum = sum(lang.get('total_seconds', 0) for lang in languages)
        print(f"Languages sum: {format_time(lang_sum)} ({lang_sum} seconds)")

    if projects:
        proj_sum = sum(proj.get('total_seconds', 0) for proj in projects)
        print(f"Projects sum: {format_time(proj_sum)} ({proj_sum} seconds)")

    # Generate the double category bar (show ALL items)
    stats_content = generate_double_category_bar(languages, projects)

    # Create the full README content
    readme_content = f"""# Hi there, I'm Daniel 👋

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

⏱️ **Total coding time this week:** {total_time}

```text
{stats_content}
```

---

## Info
[![About Me](https://img.shields.io/badge/About--Me-black?style=for-the-badge&logo=numpy&logoColor=white)](https://danielscos.github.io/about_me)

---

> "Code is like humor. When you have to explain it, it's bad." – Cory House"""

    with open('README.md', 'w') as f:
        f.write(readme_content)

    print("README updated successfully!")
    print(f"Total time: {total_time}")
    print(f"Languages: {len(languages)}")
    print(f"Projects: {len(projects)}")

if __name__ == "__main__":
    update_readme()
