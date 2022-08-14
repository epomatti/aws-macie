# AWS Macie

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

A file with vulnerabilities will be automatically uploaded:

```
Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

Credit Card Number: 5555555555554444
Type: Mastercard
CVC: 761
```

Terraform will attempt to enable Macie. If you already have it enabled, comment the resource `aws_macie2_account` declaration from the code.

Create a Macie job. Replace the `accountId` and `buckets` values accordingly.

```sh
aws macie2 create-classification-job \
  --job-type "ONE_TIME" \
  --name "job1" \
  --s3-job-definition '{"bucketDefinitions":[{"accountId":"000000000000", "buckets":["<bucket-name>"]}]}'
```

Review the results on the console.

<img src="findings.png" />
