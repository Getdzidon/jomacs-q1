bucket = "${data.aws_ssm_parameter.bucket_name.value}"
key    = "${data.aws_ssm_parameter.key.value}"
region = "${data.aws_ssm_parameter.region.value}"
encrypt = true
