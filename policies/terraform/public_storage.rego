package sentinel.terraform.public_storage

import rego.v1

import data.sentinel.terraform.lib

public_gcp_principals := {"allUsers", "allAuthenticatedUsers"}

public_s3_acls := {
	"public-read",
	"public-read-write",
	"authenticated-read",
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "google_storage_bucket"
	after := object.get(resource.change, "after", {})
	object.get(after, "public_access_prevention", "") != "enforced"
	message := sprintf("%s must set public_access_prevention to enforced", [resource.address])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "google_storage_bucket_iam_member"
	after := object.get(resource.change, "after", {})
	object.get(after, "member", "") in public_gcp_principals
	message := sprintf("%s grants public access to Cloud Storage", [resource.address])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "google_storage_bucket_iam_binding"
	after := object.get(resource.change, "after", {})
	some member in object.get(after, "members", [])
	member in public_gcp_principals
	message := sprintf("%s grants public access to Cloud Storage", [resource.address])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "google_storage_bucket_iam_policy"
	after := object.get(resource.change, "after", {})
	policy_data := object.get(after, "policy_data", "")
	is_string(policy_data)
	some principal in public_gcp_principals
	contains(policy_data, principal)
	message := sprintf("%s contains a public Cloud Storage principal", [resource.address])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "aws_s3_bucket"
	after := object.get(resource.change, "after", {})
	object.get(after, "acl", "private") in public_s3_acls
	message := sprintf("%s uses a public S3 ACL", [resource.address])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "aws_s3_bucket_acl"
	after := object.get(resource.change, "after", {})
	object.get(after, "acl", "private") in public_s3_acls
	message := sprintf("%s uses a public S3 ACL", [resource.address])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "aws_s3_bucket_public_access_block"
	after := object.get(resource.change, "after", {})
	some setting in {
		"block_public_acls",
		"block_public_policy",
		"ignore_public_acls",
		"restrict_public_buckets",
	}
	object.get(after, setting, false) != true
	message := sprintf("%s must enable %s", [resource.address, setting])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type == "aws_s3_bucket_policy"
	after := object.get(resource.change, "after", {})
	document := lib.json_document(object.get(after, "policy", {}))
	some statement in lib.statements(document)
	object.get(statement, "Effect", "") == "Allow"
	principal_is_public(object.get(statement, "Principal", {}))
	message := sprintf("%s contains an Allow statement with a public principal", [resource.address])
}

principal_is_public(principal) if principal == "*"

principal_is_public(principal) if {
	is_object(principal)
	lib.contains_wildcard(object.get(principal, "AWS", []))
}
