#!/usr/bin/env python3
import requests
import os
import json
import logging
from datetime import datetime

def fetch_hackatime_data():
    # Set up logging
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)

    logger.info("🚀 Starting Hackatime data fetch...")
    logger.info(f"📅 Current time: {datetime.now().isoformat()}")

    api_key = os.environ.get('WAKATIME_API_KEY')
    if not api_key:
        logger.error("❌ WAKATIME_API_KEY environment variable not found")
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
                logger.info(f"✅ Success! Got data from: {endpoint}")
                print(f"✅ Success! Got data from: {endpoint}")
                print(f"Raw response keys: {list(data.keys())}")
                if 'data' in data:
                    stats = data['data']
                    logger.info(f"📊 Stats keys: {list(stats.keys())}")
                    logger.info(f"⏱️ Total time: {stats.get('human_readable_total', 'N/A')}")
                    logger.info(f"💻 Languages count: {len(stats.get('languages', []))}")
                    logger.info(f"📁 Projects count: {len(stats.get('projects', []))}")

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

def merge_duplicates(items):
    """Merge duplicate languages/projects by normalizing names"""
    merged = {}
    logger = logging.getLogger(__name__)

    for item in items:
        # Normalize name (title case, handle common duplicates)
        name = item['name'].strip()
        original_name = name
        normalized_name = name.title()

        # Handle specific cases with more comprehensive mapping
        name_lower = normalized_name.lower()
        if name_lower in ['javascript', 'js', 'jsx', 'typescript', 'ts']:
            if 'jsx' in name_lower or 'tsx' in name_lower:
                normalized_name = 'JSX/TSX'
            elif 'typescript' in name_lower or 'ts' == name_lower:
                normalized_name = 'TypeScript'
            else:
                normalized_name = 'JavaScript'
        elif name_lower in ['python', 'py']:
            normalized_name = 'Python'
        elif name_lower in ['json', 'jsonc', 'json5']:
            normalized_name = 'JSON'
        elif name_lower in ['html', 'htm']:
            normalized_name = 'HTML'
        elif name_lower in ['css', 'scss', 'sass', 'less']:
            normalized_name = 'CSS'
        elif name_lower in ['rust', 'rs']:
            normalized_name = 'Rust'
        elif name_lower in ['markdown', 'md']:
            normalized_name = 'Markdown'
        elif name_lower in ['yaml', 'yml']:
            normalized_name = 'YAML'
        elif name_lower in ['bash', 'sh', 'zsh', 'fish']:
            normalized_name = 'Shell'
        elif name_lower in ['unknown', '']:
            normalized_name = 'Unknown'

        if normalized_name in merged:
            # Merge the times
            merged[normalized_name]['total_seconds'] += item.get('total_seconds', 0)
            logger.debug(f"🔄 Merged {original_name} into {normalized_name}")
        else:
            merged[normalized_name] = {
                'name': normalized_name,
                'total_seconds': item.get('total_seconds', 0)
            }

    # Convert back to list and sort by time
    result = list(merged.values())
    result.sort(key=lambda x: x['total_seconds'], reverse=True)

    logger.info(f"📊 Merged {len(items)} items into {len(result)} unique items")
    return result

def generate_double_category_bar(languages, projects, count=5):
    # Merge duplicates first
    merged_languages = merge_duplicates(languages)
    merged_projects = merge_duplicates(projects)

    # Calculate actual totals
    lang_total_seconds = sum(lang['total_seconds'] for lang in merged_languages)
    proj_total_seconds = sum(proj['total_seconds'] for proj in merged_projects)

    content = "💾 Languages:\n"
    for i, lang in enumerate(merged_languages[:count]):
        name = lang['name']
        seconds = lang['total_seconds']
        time_text = format_time(seconds)
        # Calculate correct percentage based on actual total
        percent = (seconds / lang_total_seconds * 100) if lang_total_seconds > 0 else 0
        bar = create_progress_bar(percent)
        content += f"{name:<12} {time_text:>12}  {bar}  {percent:.1f}%\n"

    content += "\n💼 Projects:\n"
    for i, proj in enumerate(merged_projects[:count]):
        name = proj['name']
        seconds = proj['total_seconds']
        time_text = format_time(seconds)
        # Calculate correct percentage based on actual total
        percent = (seconds / proj_total_seconds * 100) if proj_total_seconds > 0 else 0
        bar = create_progress_bar(percent)
        content += f"{name:<12} {time_text:>12}  {bar}  {percent:.1f}%\n"

    return content

def update_readme():
    logger = logging.getLogger(__name__)
    logger.info("🔄 Starting README update process...")

    data = fetch_hackatime_data()
    if not data:
        logger.error("❌ Failed to fetch Hackatime data")
        print("Failed to fetch Hackatime data")
        return

    print("\n=== DEBUG: Full API Response ===")
    print(json.dumps(data, indent=2))
    print("=== END DEBUG ===\n")

    stats = data.get('data', {})
    total_time = stats.get('human_readable_total', 'N/A')
    languages = stats.get('languages', [])
    projects = stats.get('projects', [])

    logger.info(f"📊 Processing {len(languages)} languages and {len(projects)} projects")
    print(f"Processing {len(languages)} languages and {len(projects)} projects")

    # Calculate actual totals from the data
    total_seconds_from_api = stats.get('total_seconds', 0)
    logger.info(f"⏱️ API claims total: {total_time} ({total_seconds_from_api} seconds)")
    print(f"API claims total: {total_time} ({total_seconds_from_api} seconds)")

    if languages:
        lang_sum = sum(lang.get('total_seconds', 0) for lang in languages)
        logger.info(f"💻 Languages sum: {format_time(lang_sum)} ({lang_sum} seconds)")
        print(f"Languages sum: {format_time(lang_sum)} ({lang_sum} seconds)")

    if projects:
        proj_sum = sum(proj.get('total_seconds', 0) for proj in projects)
        logger.info(f"📁 Projects sum: {format_time(proj_sum)} ({proj_sum} seconds)")
        print(f"Projects sum: {format_time(proj_sum)} ({proj_sum} seconds)")

    # Use the actual language total as the real total time
    actual_total_seconds = sum(lang.get('total_seconds', 0) for lang in languages)
    actual_total_time = format_time(actual_total_seconds)
    logger.info(f"✅ Using corrected total: {actual_total_time} ({actual_total_seconds} seconds)")
    print(f"Using corrected total: {actual_total_time} ({actual_total_seconds} seconds)")

    # Generate the double category bar (top 5 items, fixed percentages)
    stats_content = generate_double_category_bar(languages, projects, 5)

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

⏱️ **Total coding time this week:** {actual_total_time}

```text
{stats_content}
```

---

## Info
[![About Me](https://img.shields.io/badge/About--Me-black?style=for-the-badge&logo=numpy&logoColor=white)](https://danielscos.github.io/about_me)

---

> "Code is like humor. When you have to explain it, it's bad." – Cory House"""

    # Add verification timestamp to README
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")
    readme_content += f"\n\n<!-- Last updated: {timestamp} -->"

    with open('README.md', 'w') as f:
        f.write(readme_content)

    logger.info("✅ README updated successfully!")
    logger.info(f"📊 Summary - Total: {actual_total_time}, Languages: {len(languages)}, Projects: {len(projects)}")
    logger.info(f"🕐 Update completed at: {timestamp}")

    print("README updated successfully!")
    print(f"Total time: {actual_total_time}")
    print(f"Languages: {len(languages)}")
    print(f"Projects: {len(projects)}")
    print(f"Last updated: {timestamp}")

    # Verify the file was actually written
    try:
        with open('README.md', 'r') as f:
            content = f.read()
            if timestamp in content:
                logger.info("✅ Verification: Timestamp found in README - update confirmed!")
                print("✅ Verification: README update confirmed!")
            else:
                logger.warning("⚠️ Verification: Timestamp not found in README")
                print("⚠️ Warning: Could not verify README update")
    except Exception as e:
        logger.error(f"❌ Verification failed: {e}")
        print(f"❌ Verification failed: {e}")

if __name__ == "__main__":
    update_readme()
