#
# Cookbook Name:: whenever
# Recipe:: default
#

ey_cloud_report "whenever" do
  message "starting whenever recipe"
end

app_name = "boxcast"

if ['solo', 'util'].include?(node[:instance_role])

  gem_package "bundler" do
    source "http://rubygems.org"
    action :install
    version "1.0.21"
  end

  local_user = node[:users].first
  execute "whenever" do
    cwd "/data/#{app_name}/current"
    user local_user[:username]
    command "bundle exec whenever --update-crontab #{app_name} --set environment=#{node[:environment][:framework_env]}"
    action :run
  end

  ey_cloud_report "whenever" do
    message "whenever recipe complete"
  end

end
