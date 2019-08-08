provider "aws" {
  region = "us-west-2"
}

data "template_file" "app_payload" {
  template = "${file("policy.json")}"
  vars = {
    bucket_name = "${var.bucket_name}"
  }
}

resource "aws_s3_bucket" "satellite_fed" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"

  policy = "${data.template_file.app_payload.rendered}"

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}