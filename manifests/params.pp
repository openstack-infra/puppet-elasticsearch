# Params class
class elasticsearch::params (
){


  case $::osfamily {
    'Debian': {
      case $::lsbdistcodename {
        'precise': {
          $gem_package = 'rubygems'
          $jre_package = 'openjdk-7-jre-headless'
        }
        'trusty': {
          $gem_package = 'ruby'
          $jre_package = 'openjdk-7-jre-headless'
        }
        'xenial': {
          $gem_package = 'ruby'
          $jre_package = 'openjdk-8-jre-headless'
        }
        default: {
          $gem_package = 'ruby'
          $jre_package = 'openjdk-7-jre-headless'
        }
      }
    }
    default: {
      $gem_package = 'ruby'
      $jre_package = 'openjdk-7-jre-headless'
    }
  }

}

