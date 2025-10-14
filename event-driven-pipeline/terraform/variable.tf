variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "raw_bucket_name" {
  description = "Unique name for raw data S3 bucket"
  type        = string
  default     = "edp-raw-bucket-archana-devops05"
}

variable "processed_bucket_name" {
  description = "Unique name for processed data S3 bucket"
  type        = string
  default     = "edp-processed-bucket-archana-devops05"
}

variable "processor_zip_path" {
  description = "Path to processor lambda zip file"
  type        = string
  default     = "/home/ubuntu/event-driven-pipeline/terraform/my_lambdas/processor.zip"   # update this to the correct folder
}

variable "report_zip_path" {
  description = "Path to report lambda zip file"
  type        = string
  default     = "/home/ubuntu/event-driven-pipeline/terraform/my_lambdas/report.zip"     # update this to the correct folder
}

