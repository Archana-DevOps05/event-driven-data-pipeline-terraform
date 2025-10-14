#!/usr/bin/env python3
import boto3
import json
import sys
import os
from datetime import datetime, timezone
from uuid import uuid4

s3 = boto3.client('s3')

def upload_sample(bucket, key=None, device_id=None, temperature=25.0):
    if key is None:
        key = f"test/{uuid4().hex}.json"
    if device_id is None:
        device_id = f"dev-{uuid4().hex[:6]}"
    payload = {
        "device_id": device_id,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "temperature": temperature
    }
    s3.put_object(Bucket=bucket, Key=key, Body=json.dumps(payload).encode('utf-8'))
    print(f"Uploaded s3://{bucket}/{key}")
    return key

def main():
    if len(sys.argv) < 2:
        print("Usage: upload_test_data.py <raw-bucket-name> [temperature]")
        sys.exit(1)
    bucket = sys.argv[1]
    temp = float(sys.argv[2]) if len(sys.argv) >= 3 else 25.0
    upload_sample(bucket, temperature=temp)

if __name__ == "__main__":
    main()
