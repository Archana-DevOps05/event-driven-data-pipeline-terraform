#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ZIP_DIR="$ROOT_DIR/lambda_zip"
mkdir -p "$ZIP_DIR"

echo "Building processor lambda..."
cd "$ROOT_DIR/lambda/processor"
# if you have dependencies, install to temp dir and zip; here requirements likely empty
pip install -r requirements.txt -t ./package || true
cd package || true
zip -r9 "$ZIP_DIR/processor.zip" . || true
cd ..
if [ -f package ]; then
  rm -rf package
fi
# include app.py at root if package didn't exist
if [ ! -s "$ZIP_DIR/processor.zip" ]; then
  zip -r9 "$ZIP_DIR/processor.zip" app.py
fi

echo "Building daily report lambda..."
cd "$ROOT_DIR/lambda/daily_report"
pip install -r requirements.txt -t ./package || true
cd package || true
zip -r9 "$ZIP_DIR/report.zip" . || true
cd ..
if [ -f package ]; then
  rm -rf package
fi
if [ ! -s "$ZIP_DIR/report.zip" ]; then
  zip -r9 "$ZIP_DIR/report.zip" app.py
fi

echo "Built zips in $ZIP_DIR:"
ls -l "$ZIP_DIR"
