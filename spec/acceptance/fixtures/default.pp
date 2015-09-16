class { '::elasticsearch':
  es_template_config => {
    'cluster.name' => 'acceptance-test',
    'path.data'    => '/tmp/acceptance',
  },
}
