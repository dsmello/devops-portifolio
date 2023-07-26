

terraform {
  backend "s3" {
    endpoint                    = "https://objectstore.fra1.civo.com"
    bucket                      = "terraform-states"
    key                         = "base/terraform.tfstate"
    region                      = "fra1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }


  required_providers {
    civo = {
      source = "civo/civo"
      version = "1.0.35"
    }
  }
}

provider "civo" {
  # Configuration options 
  token = var.civo_api_key
  region = "fra1"
}