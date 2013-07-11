henchman { 'Puppet::Type::File::Show_source':
  type     => 'file',
  property => 'show_source',
} ->
file { '/tmp/show_source':
  ensure      => 'present',
  content     => 'test content',
  show_source => true,
}
