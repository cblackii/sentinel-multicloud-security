package sentinel.terraform

import rego.v1

deny contains violation if {
	some violation in data.sentinel.terraform.public_storage.deny
}

deny contains violation if {
	some violation in data.sentinel.terraform.broad_iam.deny
}

deny contains violation if {
	some violation in data.sentinel.terraform.required_metadata.deny
}
