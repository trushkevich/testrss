testrss
=======

In order to make Google auth working locally testrss.example.com domain should be added to hosts file (Google blocks adding redirect URI with custom tld so a webserver rewrite rule is being used). Also virtual host should be configured to use testrss.example.com as a server alias and should allow overriding rules in .htaccess file.

To add task to cron run in command line:
$ whenever --update-crontab testrss --set environment=development

To set a user to be an admin run in command line:
$ rake users:set_admin[:id]

To unset a user from being an admin run in command line:
$ rake users:unset_admin[:id]