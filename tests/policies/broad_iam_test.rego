package sentinel.terraform.broad_iam_test

import rego.v1

import data.sentinel.terraform.broad_iam.deny

test_blocks_gcp_primitive_role if {
	violations := deny with input as plan([
		change("google_project_iam_member.owner", {"role": "roles/owner"}),
	])
	count(violations) == 1
}

test_blocks_aws_wildcard_policy if {
	violations := deny with input as plan([
		change("aws_iam_role_policy.admin", {
			"policy": json.marshal({
				"Statement": [{"Effect": "Allow", "Action": "*", "Resource": "*"}],
			}),
		}),
	])
	count(violations) == 1
}

test_blocks_broad_aws_managed_policy if {
	violations := deny with input as plan([
		change("aws_iam_role_policy_attachment.admin", {
			"policy_arn": "arn:aws:iam::aws:policy/AdministratorAccess",
		}),
	])
	count(violations) == 1
}

test_allows_scoped_iam if {
	violations := deny with input as plan([
		change("google_project_iam_member.viewer", {"role": "roles/logging.viewer"}),
		change("aws_iam_policy.logs", {
			"policy": json.marshal({
				"Statement": [{"Effect": "Allow", "Action": ["s3:GetObject"], "Resource": "arn:aws:s3:::logs/*"}],
			}),
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
