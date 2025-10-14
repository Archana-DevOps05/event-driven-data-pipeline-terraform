import json
import boto3
import os
from urllib.parse import unquote_plus
from datetime import datetime, timezone

s3 = boto3.client('s3')
PROCESSED_BUCKET = os.environ.get('PROCESSED_BUCKET')

def lambda_handler(event, context):
    records = event.get('Records', [])
    results = []
    for r in records:
        try:
            bucket = r['s3']['bucket']['name']
            key = unquote_plus(r['s3']['object']['key'])
            print(f"Processing s3://{bucket}/{key}")
            obj = s3.get_object(Bucket=bucket, Key=key)
            body = obj['Body'].read().decode('utf-8')
            # Example processing: assume JSON
            data = json.loads(body)
            # Add processing metadata
            data['processed'] = True
            data['processed_at'] = datetime.now(timezone.utc).isoformat()
            out_key = f"processed/{key}"
            s3.put_object(Bucket=PROCESSED_BUCKET, Key=out_key, Body=json.dumps(data).encode('utf-8'))
            results.append({'key': key, 'status': 'processed'})
        except Exception as e:
            print(f"Error processing record: {e}")
            err_key = f"failed/{key}.error"
            try:
                s3.put_object(Bucket=PROCESSED_BUCKET, Key=err_key, Body=str(e).encode('utf-8'))
            except Exception as inner:
                print(f"Failed to write error object: {inner}")
            results.append({'key': key, 'status': 'error', 'error': str(e)})
    return {
        "statusCode": 200,
        "body": json.dumps(results)
    }
