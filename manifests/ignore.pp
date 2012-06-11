define etckeeper::ignore($ensure = present) {

    exec {
        "update .gitignore ${name}":
            command   => "echo ${name} >> /etc/.gitignore; git commit -am 'Added ${name} to .gitignore'",
            unless    => "grep ${name} /etc/.gitignore",
            notify    => Exec["remove cache ${name}"],
            require => Exec["etckeeper_init"];
        "remove cache ${name}":
            command     => "/bin/bash -c \"if [ \"$(git ls-files ${name} --error-unmatch >/dev/null 2>&1;echo $?)\" = \"0\" ]; then git rm -r --cached \"${name}\"; git commit -am 'Do not track ${name}'; fi\"",
            cwd         => '/etc',
            provider    => 'shell',
            refreshonly => true;
    }

}
