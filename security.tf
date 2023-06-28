resource "oci_kms_vault" "test_vault" {
    #Required
    compartment_id = var.compartment_id
    display_name = var.vault_name
    vault_type = "DEFAULT"

    #Optional
}

resource "oci_kms_key" "test_key" {
    #Required
    compartment_id = var.compartment_id
    display_name = var.key_name
    key_shape {
        #Required
        algorithm = "AES"
        length = "32"
    }
    management_endpoint = oci_kms_vault.test_vault.management_endpoint
    protection_mode = "HSM"
}


resource "oci_vault_secret" "test_secret" {
    #Required
    compartment_id = var.compartment_id
    secret_content {
        #Required
        content_type = "BASE64"

        #Optional
        content = var.secret_content
        name = var.secret_name
    }
    secret_name = "Test_Secret_1"
    vault_id = oci_kms_vault.test_vault.id
    key_id = oci_kms_key.test_key.id

    secret_rules {
        rule_type = "SECRET_EXPIRY_RULE"
    }
    
    #Optional
    description = var.secret_description
}

output management_endpoint {
  value       = oci_kms_vault.test_vault.management_endpoint
  description = "Management Endpoint"
}
