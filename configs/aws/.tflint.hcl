# config {
#   module = true # Inspect module calls
# }

# Enable TFLint ruleset plugin for aws (200+ rules)
plugin "aws" {
  enabled = true
  version = "0.25.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Rules which are enabled by default, are not listed here, see
# https://github.com/terraform-linters/tflint/tree/master/docs/rules#rules

# Disallow legacy dot index syntax.
rule "terraform_deprecated_index" {
  enabled = true
}

# Disallow variables, data sources, and locals that are declared but never used.
rule "terraform_unused_declarations" {
  enabled = true
}

# Disallow // comments in favor of #
rule "terraform_comment_syntax" {
  enabled = true
}

# Disallow output declarations without description.
rule "terraform_documented_outputs" {
  enabled = true
}

# Disallow variable declarations without description.
rule "terraform_documented_variables" {
  enabled = true
}

# Disallow variable declarations without type.
rule "terraform_typed_variables" {
  enabled = true
}

# Enforce naming conventions.
rule "terraform_naming_convention" {
  enabled = true
}

# Disallow terraform declarations without required_version.
rule "terraform_required_version" {
  enabled = true
}

# Require that all providers have version constraints through required_providers.
rule "terraform_required_providers" {
  enabled = true
}

# Check that all required_providers are used in the module
rule "terraform_unused_required_providers" {
  enabled = true
}

# Ensure https://www.terraform.io/docs/language/modules/develop/index.html#standard-module-structure
rule "terraform_standard_module_structure" {
  enabled = true
}