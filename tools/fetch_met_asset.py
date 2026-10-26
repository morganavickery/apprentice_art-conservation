#!/usr/bin/env python3
"""Download a public domain image from The Met and log it in ASSET_LOG.csv.

Development-time helper only; the game itself never makes network calls.

Usage:
    python3 tools/fetch_met_asset.py OBJECT_ID OUTPUT_PATH [--small] [--dry-run]

Example:
    python3 tools/fetch_met_asset.py 436535 games/conservator/assets/art/wheat_field.jpg

The object ID is the number at the end of a Met collection URL
(metmuseum.org/art/collection/search/436535). The script refuses objects that
are not public domain, and refuses to overwrite files or duplicate log rows.
After running it, fill in the "modifications" column for any edits you make.
"""

import argparse
import csv
import json
import sys
import urllib.request
from datetime import date
from pathlib import Path

API = "https://collectionapi.metmuseum.org/public/collection/v1/objects/{}"
REPO_ROOT = Path(__file__).resolve().parent.parent
ASSET_LOG = REPO_ROOT / "docs" / "assets" / "ASSET_LOG.csv"
USER_AGENT = "ApprenticeAssetFetcher/1.0 (development tool)"


def fetch(url):
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


def fail(message):
    sys.exit(f"error: {message}")


def attribution(obj):
    parts = [obj["title"] or "Untitled"]
    if obj["artistDisplayName"]:
        parts.append(obj["artistDisplayName"])
    if obj["objectDate"]:
        parts.append(obj["objectDate"])
    credit = ". ".join(parts) + ". The Metropolitan Museum of Art"
    if obj["creditLine"]:
        credit += f", {obj['creditLine']}"
    return f"{credit}. Object {obj['objectID']}."


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("object_id", type=int, help="Met object ID")
    parser.add_argument("output", help="repo-relative path to save the image to")
    parser.add_argument("--small", action="store_true",
                        help="download the lower-resolution primaryImageSmall")
    parser.add_argument("--dry-run", action="store_true",
                        help="show the log row without downloading or writing anything")
    args = parser.parse_args()

    output = (REPO_ROOT / args.output).resolve()
    if REPO_ROOT not in output.parents:
        fail("output path must be inside the repository")
    rel_path = output.relative_to(REPO_ROOT).as_posix()

    obj = json.loads(fetch(API.format(args.object_id)))
    if not obj.get("isPublicDomain"):
        fail(f"object {args.object_id} is not marked public domain; not downloading")
    image_url = obj["primaryImageSmall"] if args.small else obj["primaryImage"]
    if not image_url:
        fail(f"object {args.object_id} has no downloadable image")

    with ASSET_LOG.open(newline="", encoding="utf-8") as f:
        if any(row["file_path"] == rel_path for row in csv.DictReader(f)):
            fail(f"{rel_path} is already in {ASSET_LOG.name}")
    if output.exists():
        fail(f"{rel_path} already exists")

    row = {
        "file_path": rel_path,
        "title": obj["title"],
        "creator": obj["artistDisplayName"] or obj["culture"] or "Unknown",
        "source_url": obj["objectURL"],
        "license": "CC0 1.0 (The Met Open Access)",
        "date_accessed": date.today().isoformat(),
        "modifications": "",
        "attribution_text": attribution(obj),
    }

    if args.dry_run:
        print(f"image: {image_url}")
        for key, value in row.items():
            print(f"{key}: {value}")
        return

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(fetch(image_url))
    with ASSET_LOG.open("a", newline="", encoding="utf-8") as f:
        csv.DictWriter(f, fieldnames=row.keys(), lineterminator="\n").writerow(row)
    print(f"saved {rel_path} and added it to {ASSET_LOG.name}")
    print("remember: resize before committing, and fill in 'modifications' if you edit it")


if __name__ == "__main__":
    main()
