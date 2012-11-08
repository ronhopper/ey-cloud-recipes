#
# Cookbook Name:: clockwork
# Recipe:: default
#
if ['solo', 'util'].include?(node[:instance_role])
  execute "install clockwork gem" do
    command "gem install clockwork -r"
    not_if { "gem list | grep clockwork" }
  end

  node[:applications].each do |app, data|
    template "/etc/monit.d/clockwork_#{app}.monitrc" do
      owner 'root'
      group 'root'
      mode 0644
      source "clockwork.monitrc.erb"
      variables({
      :app_name => app,
      :rails_env => node[:environment][:framework_env]
      })
    end

    remote_file "/data/#{app}/shared/bin/clockwork" do
      source "clockwork"
      owner 'root'
      group 'root'
      mode 0755
      backup 0
    end
  end

  execute "ensure-clockwork-is-setup-with-monit" do
    command %Q{
    monit reload
    }
  end
end
