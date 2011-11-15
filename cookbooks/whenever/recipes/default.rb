#
# Cookbook Name:: whenever
# Recipe:: default
#

ey_cloud_report "whenever" do
  message "starting whenever recipe"
end

app_name = "boxcast"

if ['solo', 'util'].include?(node[:instance_role])

  local_user = node[:users].first
  execute "whenever" do
    cwd "/data/#{app_name}/current"
    user local_user[:username]
    command "test -x /data/#{app_name}/shared/bundled_gems/ruby/1.9.1/bin/whenever && bundle exec whenever --update-crontab '#{app_name}_#{node[:environment][:framework_env]}'"
    action :run
  end

  ey_cloud_report "whenever" do
    message "whenever recipe complete"
  end

end
