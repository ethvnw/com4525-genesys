# Getting started

## Additional configs
This template has most config set up already to work with our servers. There are however a few additional tweaks you need to make specific to your project.

### Sentry config
Before you start your group project, you will get an invitation to set up an account on Sentry (https://sentry.shefcompsci.org.uk/). Sentry is a tool we use to report errors on server, if any errors occurred on your site, you will get an email notification about it.

Once you have set up the account, you can create a project. By the end of the process you should get a `DSN` code. You will need to replace the `REPLACE_WITH_YOUR_DSN` part in `config/initializers/sentry.rb` with this code.

### Deployment config
When the QA and demo server for your group project is ready, you can find the details on https://info.shefcompsci.org.uk/genesys/
Once these details are available, you need to include them in your deployment config file. I.e. you need to replace `QA_SERVER` and `QA_USER` in `config/deploy/qa.rb` to the ones provided on the info page, and also replace `PUT_APP_URL_HERE` in `config/environments/qa.rb` to the URL of your QA site. Same needs to be done to `config/deploy/demo.rb` and `config/environments/demo.rb`.

### Email config
If you need to send out emails from your application, you will need to add the following config to your `config/application.rb`, inside the `class Application < Rails::Application ... end` block:
```
config.action_mailer.smtp_settings = {
  address:              'mailhost.shef.ac.uk',
  port:                 587,
  enable_starttls_auto: true,
  openssl_verify_mode:  OpenSSL::SSL::VERIFY_PEER,
  openssl_verify_depth: 3,
  ca_file:              '/etc/ssl/certs/ca-certificates.crt'
}
```

You will also need to config the `from` address of your mailers to `no-reply@sheffield.ac.uk`.

On your local machine, we use a gem called `letter_opener`, which is already installed an configured in this template, and instead of sending out an email, the application will open up a tab in your browser, allowing you to view the content of the email.

On QA and demo server, if you do not wish the emails to be sent to the actual recipients, you can use the gem `sanitize_email` to redirect these emails to yourself. The gem is already included in the template, and you can find out more about how to configure it on their GitHub page: https://github.com/pboling/sanitize_email.

## Styling your application
We use `shakapacker` gem to manage static assets in this template, which is a Rails wrapper for the Javascript library `webpack`.

You can find out more about `shakapacker` on their GitHub page: https://github.com/shakacode/shakapacker.

### Add custom JS
Additional Javascript files should be added to the `app/packs/scripts` directory, e.g. `app/packs/scripts/landing_page.js`. Then the file must be added to the entrypoint file `app/packs/entrypoints/application.js`, e.g.:
```
import '../scripts/landing_page.js'
```

### Installing additional JS libraries
Any JS libraries hosted on NPM can be installed with yarn. For example to install jQuery, run the following command:
```
yarn add jquery
```

Then in the file you would like to use jQuery (e.g. `app/packs/scripts/landing_page.js`), add:
```
import 'jquery';
```

Alternatively, if you wish to make jQuery globally available through your project, add the following to `app/packs/entrypoints/application.js`:
```
import $ from 'jquery';
window.$ = $;
```

### Add custom CSS
Additional stylesheets should be added to the `app/packs/styles` directory in `scss` format, e.g. `app/packs/styles/landing_page.scss`. Then the file must be added to the entrypoint file `app/packs/entrypoints/styles.js`, e.g.:
```
import '../styles/landing_page';
```

### Add images
Images should be added to `app/packs/images`, e.g. `app/packs/images/logo.png`. Then to include the image in your view, use the `image_pack_tag` helper, e.g.:
```
= image_pack_tag 'logo.png', height: 40
```
Please note that you **do not need to** include the `images/` path when using this helper.

Alternatively, to use an image in your CSS, use the `url` function, e.g. in your `app/packs/styles/layout.scss`, add:
```
body {
  background-image: url(images/logo.png);
}
```
Please note that you **need to** include the `images/` path when referring an image in CSS.
