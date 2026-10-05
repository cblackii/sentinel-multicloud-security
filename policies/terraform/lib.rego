package sentinel.terraform.lib

import rego.v1

# managed_changes exposes only managed resources that Terraform will create or
# update. Read-only data sources and no-op/delete-only changes do not need a
# preventive policy decision.
managed_changes contains resource if {
	resource := input.resource_changes[_]
	resource.mode == "managed"
	some action in resource.change.actions
	action in {"create", "update"}
}

arrayify(value) := value if is_array(value)

arrayify(value) := [value] if not is_array(value)

json_document(value) := value if is_object(value)

json_document(value) := document if {
	is_string(value)
	document := json.unmarshal(value)
}

statements(document) := arrayify(object.get(document, "Statement", []))

contains_wildcard(value) if {
	some item in arrayify(value)
	item == "*"
}
