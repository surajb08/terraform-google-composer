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


resource "google_composer_environment" "default" {
  name    = var.name
  region  = var.region
  project = var.project
  labels  = var.labels

  dynamic "config" {
    for_each = var.config
    content {

      node_count = config.value["node_count"]

      dynamic "node_config" {
        for_each = lookup(config.value, "node_config", [])
        content {
          zone            = "${var.region}-${lookup(node_config.value, "zone", null)}" # join("-", [ var.region, lookup(config.value["node_config"], "zone", "")])
          machine_type    = lookup(node_config.value, "machine_type", null)
          network         = lookup(node_config.value, "network", null)
          subnetwork      = lookup(node_config.value, "subnetwork", null)
          disk_size_gb    = lookup(node_config.value, "disk_size_gb", null)
          oauth_scopes    = lookup(node_config.value, "oauth_scopes", null) #  defaults to ["https://www.googleapis.com/auth/cloud-platform"]
          service_account = lookup(node_config.value, "service_account", null)
          tags            = lookup(node_config.value, "tags", null)
          dynamic "ip_allocation_policy" {
            for_each = lookup(node_config.value, "ip_allocation_policy", [])
            content {
              use_ip_aliases                = lookup(ip_allocation_policy.value, "use_ip_aliases", false)
              cluster_secondary_range_name  = lookup(ip_allocation_policy.value, "cluster_secondary_range_name", null)
              services_secondary_range_name = lookup(ip_allocation_policy.value, "services_secondary_range_name", null)
              cluster_ipv4_cidr_block       = lookup(ip_allocation_policy.value, "cluster_ipv4_cidr_block", null)
              services_ipv4_cidr_block      = lookup(ip_allocation_policy.value, "services_ipv4_cidr_block", null)
            }
          }
        }
      }

      dynamic "software_config" {
        for_each = lookup(config.value, "software_config", [])
        content {
          airflow_config_overrides = lookup(software_config.value, "airflow_config_overrides", null)
          pypi_packages            = lookup(software_config.value, "pypi_packages", null)
          env_variables            = lookup(software_config.value, "env_variables", null)
          image_version            = lookup(software_config.value, "image_version", null)
          python_version           = lookup(software_config.value, "python_version", null)
        }
      }

      dynamic "private_environment_config" {
        for_each = lookup(config.value, "private_environment_config", [])
        content {
          enable_private_endpoint = lookup(private_environment_config.value, "enable_private_endpoint", null)
          master_ipv4_cidr_block  = lookup(private_environment_config.value, "master_ipv4_cidr_block", null)
        }
      }
    }
  }
}