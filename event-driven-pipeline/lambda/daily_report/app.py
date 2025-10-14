import boto3
import json
import os
import io
import csv
from datetime import datetime, timezone

s3 = boto3.client('s3')
PROCESSED_BUCKET = os.environ.get('PROCESSED_BUCKET')

def lambda_handler(event, context):
    prefix = "processed/"
    paginator = s3.get_paginator('list_objects_v2')
    items = []
    for page in paginator.paginate(Bucket=PROCESSED_BUCKET, Prefix=prefix):
        for obj in page.get('Contents', []):
            key = obj['Key']
            try:
                resp = s3.get_object(Bucket=PROCESSED_BUCKET, Key=key)
                body = resp['Body'].read().decode('utf-8')
                data = json.loads(body)
                # Example summary field extraction; customize as needed
                items.append({
                    'key': key,
                    'processed_time': obj['LastModified'].isoformat(),
                    'device_id': data.get('device_id', ''),
                    'temperature': data.get('temperature', '')
                })
            except Exception as e:
                print(f"Skipping {key}: {e}")
                continue

    # Build CSV summary
    output = io.StringIO()
    writer = csv.DictWriter(output, fieldnames=['key','processed_time','device_id','temperature'])
    writer.writeheader()
    for it in items:
        writer.writerow(it)
    summary_csv = output.getvalue()

    # Save report with date
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    report_key = f"reports/daily-summary-{now}.csv"
    s3.put_object(Bucket=PROCESSED_BUCKET, Key=report_key, Body=summary_csv.encode('utf-8'))
    print(f"Stored report at s3://{PROCESSED_BUCKET}/{report_key}")
    return {
        "statusCode": 200,
        "body": json.dumps({"report_key": report_key, "items_count": len(items)})
    }
