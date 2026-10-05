package sentinel.terraform.required_metadata_test

import rego.v1

import data.sentinel.terraform.required_metadata.deny

test_blocks_missing_gcp_labels if {
	violations := deny with input as plan([
		change("google_storage_bucket.logs", {"labels": {"project": "sentinel"}}),
	])
	count(violations) == 1
	contains(violations[_], "environment, managed_by")
}

test_blocks_missing_aws_tags if {
	violations := deny with input as plan([
		change("aws_s3_bucket.logs", {"tags_all": {"Project": "sentinel", "Environment": "dev"}}),
	])
	count(violations) == 1
	contains(violations[_], "ManagedBy")
}

test_allows_complete_metadata if {
	violations := deny with input as plan([
		change("google_storage_bucket.logs", {
			"labels": {"project": "sentinel", "environment": "dev", "managed_by": "terraform"},
		}),
		change("aws_s3_bucket.logs", {
			"tags_all": {"Project": "sentinel", "Environment": "dev", "ManagedBy": "Terraform"},
		}),
	])
	count(violations) == 0
}

test_ignores_delete_only_changes if {
	resource := change("google_storage_bucket.old", {})
	deleting := object.union(resource, {"change": {"actions": ["delete"], "after": null}})
	violations := deny with input as plan([deleting])
	count(violations) == 0
}

plan(changes) := {"resource_changes": changes}

change(address, after) := {
	"address": address,
	"mode": "managed",
	"type": split(address, ".")[0],
	"change": {"actions": ["create"], "after": after},
}
