class { '::elasticsearch':
  version            => '0.20.5',
  es_template_config => {
    'cluster.name' => 'acceptance-test',
    'path.data'    => '/tmp/acceptance',
  },
}
