class etckeeper {
    case $operatingsystem {
        fedora: {
            $highlevel_package_manager = "yum"
            $lowlevel_package_manager ="rpm"
        }
        ubuntu, debian: {
            $highlevel_package_manager = "apt"
            $lowlevel_package_manager ="dpkg"
        }
        default: { fail("Don't know how to handle ${operatingsystem}") }
    }

    if ! defined (Package["etckeeper"]) {
        package { "etckeeper": ensure => installed; }
    }

    if ! defined (Package["git"]) {
        package { "git": ensure => installed; }
    }

    Package["etckeeper"] -> Package["git"]

    file {
        "/etc/etckeeper/etckeeper.conf":
            ensure => present,
            content => template("etckeeper/etckeeper.conf.erb"),
            require => Package["etckeeper"];
        "/etc/.git/config":
            ensure  => present,
            content => template("etckeeper/config.erb"),
            mode    => '644',
            require => Exec["etckeeper_init"];
        "/etc/cron.weekly/etckeeper-garbagecolector":
            ensure  => present,
            source  => 'puppet:///modules/etckeeper/etckeeper-gc',
            mode    => '755',
            require => Package["etckeeper"];
    }

    case $operatingsystem {
        'Debian': { $etckeeper = '/usr/sbin/etckeeper' }
        'Ubuntu': { $etckeeper = '/usr/bin/etckeeper' }
    }


    exec {
        "etckeeper_init":
            command => "${etckeeper} init",
            creates => "/etc/.git",
            require => File["/etc/etckeeper/etckeeper.conf"];
    }

    #Custom ignore Example
    # etckeeper::ignore {
    #     ['hosts.deny']:
    # }

}
