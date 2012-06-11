class etckeeper {
    case $operatingsystem {
        fedora: {
            $highlevel_package_manager = "yum"
            $lowlevel_package_manager ="rpm"
        }
        ubuntu: {
            $highlevel_package_manager = "apt"
            $lowlevel_package_manager ="dpkg"
        }
        default: { fail("Don't know how to handle ${operatingsystem}") }
    }

    if ! defined (Package["etckeeper"]) {
        package { "etckeeper": ensure => installed; }
    }


    file {
        "/etc/etckeeper/etckeeper.conf":
            ensure => present,
            content => template("etckeeper/etckeeper.conf.erb"),
            require => Package["etckeeper"];
    }

    Exec { path => ["/usr/bin", "/usr/sbin"] }

    exec {
        "etckeeper_init":
            command => "etckeeper init",
            creates => "/etc/.git",
            require => File["/etc/etckeeper/etckeeper.conf"];
    }
}
