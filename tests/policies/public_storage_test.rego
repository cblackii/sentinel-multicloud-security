package sentinel.terraform.public_storage_test

import rego.v1

import data.sentinel.terraform.public_storage.deny

test_blocks_public_gcp_bucket_member if {
	violations := deny with input as plan([
		change("google_storage_bucket_iam_member.public", {"member": "allUsers"}),
	])
	count(violations) == 1
}

test_blocks_gcp_bucket_without_public_access_prevention if {
	violations := deny with input as plan([
		change("google_storage_bucket.logs", {"public_access_prevention": "inherited"}),
	])
	count(violations) == 1
}

test_blocks_public_s3_policy if {
	violations := deny with input as plan([
		change("aws_s3_bucket_policy.public", {
			"policy": json.marshal({
				"Statement": [{"Effect": "Allow", "Principal": "*", "Action": "s3:GetObject", "Resource": "*"}],
			}),
		}),
	])
	count(violations) == 1
}

test_allows_hardened_storage if {
	violations := deny with input as plan([
		change("google_storage_bucket.logs", {"public_access_prevention": "enforced"}),
		change("aws_s3_bucket_public_access_block.logs", {
			"block_public_acls": true,
			"block_public_policy": true,
			"ignore_public_acls": true,
			"restrict_public_buckets": true,
		}),
	])
	count(violations) == 0
}

plan(changes) := {"resource_changes": changes}

change(address, after) := {
	"address": address,
	"mode": "managed",
	"type": split(address, ".")[0],
	"change": {"actions": ["create"], "after": after},
}
