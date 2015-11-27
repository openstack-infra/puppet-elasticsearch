# Params class
class elasticsearch::params (
){


  case $::osfamily {
    'Debian': {
      if $::lsbdistcodename == 'precise' {
        # package names
        $gem_package = 'rubygems'
      } else {
        # package names
        $gem_package = 'ruby'
      }
    }
  }

}

