package sentinel.terraform.required_metadata

import rego.v1

import data.sentinel.terraform.lib

required_gcp_labels := {"environment", "managed_by", "project"}
required_aws_tags := {"Environment", "ManagedBy", "Project"}

gcp_labeled_resource_types := {
	"google_compute_disk",
	"google_compute_instance",
	"google_compute_snapshot",
	"google_container_cluster",
	"google_secret_manager_secret",
	"google_storage_bucket",
}

aws_tagged_resource_types := {
	"aws_dynamodb_table",
	"aws_iam_openid_connect_provider",
	"aws_iam_role",
	"aws_instance",
	"aws_kms_key",
	"aws_s3_bucket",
	"aws_security_group",
	"aws_subnet",
	"aws_vpc",
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type in gcp_labeled_resource_types
	after := object.get(resource.change, "after", {})
	labels := gcp_labels(resource.type, after)
	missing := required_gcp_labels - present_keys(labels, required_gcp_labels)
	count(missing) > 0
	message := sprintf("%s is missing required GCP labels: %s", [resource.address, concat(", ", sort(missing))])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type in aws_tagged_resource_types
	after := object.get(resource.change, "after", {})
	tags := aws_tags(after)
	missing := required_aws_tags - present_keys(tags, required_aws_tags)
	count(missing) > 0
	message := sprintf("%s is missing required AWS tags: %s", [resource.address, concat(", ", sort(missing))])
}

gcp_labels("google_container_cluster", after) := object.get(after, "resource_labels", {})

gcp_labels(resource_type, after) := object.get(after, "labels", {}) if resource_type != "google_container_cluster"

aws_tags(after) := tags if {
	tags_all := object.get(after, "tags_all", null)
	is_object(tags_all)
	tags := tags_all
}

aws_tags(after) := object.get(after, "tags", {}) if {
	tags_all := object.get(after, "tags_all", null)
	not is_object(tags_all)
}

present_keys(metadata, required) := {key |
	some key in required
	value := object.get(metadata, key, "")
	is_string(value)
	value != ""
}
