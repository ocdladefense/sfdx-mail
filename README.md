# sfdx-mail
Mail client and related classes for sending email using the Salesforce Platform.

## Development
* Create a scratch org.
* Identify org-dependencies.
* Resolve org-dependencies; convert org-specific names into generic names.
* Organize meta-data into folders.

## Releated SFDX commands
### Create a package
<code>sf package create --name LibMail --package-type Unlocked --path sfdx-source/Modules/mail</code>

### Create a package version
<code>sf package version create --package "LibMail" --code-coverage --installation-key-bypass --wait 30 --target-dev-hub DevHub__Ocdla</code>

### Release a package version
<code>sf package version promote --package "LibMail@0.2.0-1" --target-dev-hub DevHub__Ocdla</code>


## Documentation
LibMail provides these mail clients, which extend <code>MailClientBase</code>.
* MailClient - A production mail client intended to send mail to ad-hoc addresses, Contacts and Accounts.
* MailClientTesting - A test mail client intended to redirect mail to the current User.  This client is used for evaluation purposes.
* MailClientPreview - A dummy mail cleint intended to provide a preview of mail subjects and bodies.  This client does not actually send mail but provides <code>send()</code> and <code>sendAsync()</code> methods for compatibility purposes.

LibMail is agnostic with respect to email composition.  This means that you can marshal Salesforce resources to compose mail messages in a way that suits the unique needs of your organization.  The <code>MailClient</code> will send those mail messages on behalf of your organization (using an Org-Wide Email Address, if you have one setup).  The MailClient supports ad-hoc mail send and generated mail send through the use of the <code>MailGenerator</code> class, which can be extended to generate mail using your own custom implementation.

## Example Usage

### Send a single mail message.
```java
MailClientTesting client = new MailClientTesting();

Mailbox outbox = new Mailbox();
outbox.addMessage(new MailMessage('john.doe@example.com', 'Test Mail', 'This is a test message'));

List<MailSendStatus> statuses = client.send(generator);
```

### Send several mail messages using a generator.
```java
Id eventId = 'a235b00000J4cJtAAJ';
MailClientTesting client = new MailClientTesting();
MailGenerator generator = new AttendeeConfirmationEmail(eventId);
MailSendStatus[] results = client.send(generator);
```