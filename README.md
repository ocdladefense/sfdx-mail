# sfdx-mail
Mail client and related classes for sending email using the Salesforce Platform.

## Development
* Create a scratch org.
* Identify org-dependencies.
* Resolve org-dependencies; convert org-specific names into generic names.
* Organize meta-data into folders.

## Releated SFDX commands
### Create a package
sf package create --name LibMail --package-type Unlocked --path sfdx-source/Modules/mail

### Create a version of a package
sf package version create --package "LibMail" --code-coverage --installation-key-bypass --wait 30 --dev-hub DevHub__Ocdla
```

### Release a package version
sf package version promote --package "LibMail@0.2.0-1" --target-dev-hub DevHub__Ocdla

