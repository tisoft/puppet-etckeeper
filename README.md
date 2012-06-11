# Puppet etckeeper module

This module tracks changes of /etc in a git repository.

## Requirements

Be sure to add 
    prerun_command=/etc/puppet/etckeeper-commit-pre
 and 
    postrun_command=/etc/puppet/etckeeper-commit-post
to your puppet.conf in the [main] section.

## Classes

### etckeeper
The Class adds the Package "etckeeper", and ensures there is a weekly cronjob for git garbage collection.

### etckeeper::ignore

If you want some files in etc ignred you can create a etckeeper::ignore in your nodedefinition/client class.

For files: "file", "/etc/file" and "folder/*/folder2/file" works.

For folder: "folder/", "folder/*", and "/etc/folder/", "/etc/folder/*" works.

RECOMENDED: "/etc/folder/" or "/etc/folder/*"

Only add relative folder path, like 'ssl/' if you realy want to untrack any 'ssl/' folder in /etc'

REMEMBER: If you ignore 'ssl/' puppet will only remove the existing '/etc/ssl/' from chache. If there was a /etc/apache2/ssl/ folder, content added after you created the rule, wont be tracked.
But content added before you added the rule will be tracked. ("git rm -r --cached file" to untrack them.)

For e.g.

    etckeeper::ignore {
        ['hosts.deny', '/etc/postfix/','ssl/']:
    }

