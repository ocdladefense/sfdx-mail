# sfdx-mail
Mail client and related classes for sending email using the Salesforce Platform.

## Development
* Create a scratch org.
* Identify org-dependencies.
* Resolve org-dependencies; convert org-specific names into generic names.
* Organize meta-data into folders.

## Releated SFDX commands
### Create a package
sf package create --name Mail --package-type Unlocked --path sfdx-source/Modules/mail

### Create a version of a package
sf package version create -c --package "Mail" --installation-key-bypass

### Release a package version
sf package version promote -c --package "Mail"

