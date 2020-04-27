/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


# provider "google" {
#   version = "~> 3.19"
# }

module "composer" {
  source = "../../modules/composer"

  name   = var.name
  region = var.region
  project = var.project_id
  labels = var.labels

  config = [
   {
    node_count = 3
    node_config = [{
      zone = "a"
      machine_type = "n1-standard-1"
      network = "default"
      subnetwork = "default"
      tags = ["tag1", "tag2", "tag3"]
      // ip_allocation_policy = []
    }]
    sotfware_config = []
    private_environment_config = [{
      enable_private_endpoint = false
    }]
   }
  ]
}

output "composer_example" {
  value = module.composer.composer
}