package sentinel.terraform.broad_iam

import rego.v1

import data.sentinel.terraform.lib

gcp_iam_resource_types := {
	"google_folder_iam_binding",
	"google_folder_iam_member",
	"google_organization_iam_binding",
	"google_organization_iam_member",
	"google_project_iam_binding",
	"google_project_iam_member",
}

gcp_primitive_roles := {"roles/owner", "roles/editor"}

aws_inline_policy_types := {
	"aws_iam_group_policy",
	"aws_iam_policy",
	"aws_iam_role_policy",
	"aws_iam_user_policy",
}

aws_broad_managed_policies := {
	"arn:aws:iam::aws:policy/AdministratorAccess",
	"arn:aws:iam::aws:policy/IAMFullAccess",
	"arn:aws:iam::aws:policy/PowerUserAccess",
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type in gcp_iam_resource_types
	after := object.get(resource.change, "after", {})
	role := object.get(after, "role", "")
	role in gcp_primitive_roles
	message := sprintf("%s uses overly broad GCP role %s", [resource.address, role])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type in aws_inline_policy_types
	after := object.get(resource.change, "after", {})
	document := lib.json_document(object.get(after, "policy", {}))
	some statement in lib.statements(document)
	object.get(statement, "Effect", "") == "Allow"
	lib.contains_wildcard(object.get(statement, "Action", []))
	lib.contains_wildcard(object.get(statement, "Resource", []))
	message := sprintf("%s allows every AWS action on every resource", [resource.address])
}

deny contains message if {
	some resource in lib.managed_changes
	resource.type in {
		"aws_iam_group_policy_attachment",
		"aws_iam_role_policy_attachment",
		"aws_iam_user_policy_attachment",
	}
	after := object.get(resource.change, "after", {})
	policy_arn := object.get(after, "policy_arn", "")
	policy_arn in aws_broad_managed_policies
	message := sprintf("%s attaches overly broad AWS policy %s", [resource.address, policy_arn])
}
