file { '/tmp/show_source':
  ensure      => 'present',
  content     => 'test content',
  show_source => true,
}
