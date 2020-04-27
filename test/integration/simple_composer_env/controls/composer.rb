# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rspec/retry'

RSpec.configure do |config|
  config.verobse_retry = true
  config.display_try_failure_messages = true
end

control "composer" do
  title "GCP Cloud Composer"

  describe command("gcloud composer environments list --project=#{attribute("project_id")} --localtions=#{attribute("region")}") do # describe google_storage_bucket(name: attribute("bucket_name")) do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should match "" }
    its(:stdout) { should match "simple-composer-env-" } # { should eq "#{terraform output -json composer_env_name | jq -r .name}" }
    # it { should exist }
  end

  describe command("gsutil ls -p #{attribute("project_id")}") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match "gs://#{attribute("region")}-#{attribute("project_id")}" }
  end

  # describe json(attribute("terraform_state").chomp).terraform_version do
  #   it { should match /\d+\.\d+\.\d+/ }
  # end

end