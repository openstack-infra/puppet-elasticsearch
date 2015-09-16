describe cron, :if => ['debian', 'ubuntu'].include?(os[:family]) do
  it { should have_entry('7 6 * * * find /var/log/elasticsearch -type f -mtime +14 -delete').with_user('root') }
end
