# Using the `PageAlert` module
`PageAlert` is a custom JS module to give the user pretty alert messages. You can use any of the 8 bootstrap types
(`["primary", "secondary", "success", "danger", "warning", "info", "light", "dark"]` - see [the Bootstrap documentation](https://getbootstrap.com/docs/4.0/components/alerts/)).
## From the server
Sending an alert from the server is exactly the same as it was before.
Just use `flash[:notice]` or `flash[:alert]`, and the `convert_flash_message` method of `ApplicationController` will handle the rest!

E.g.:
```ruby
redirect_to(:root_path, notice: "Hello, World!!")
```

For access to the full set of bootstrap alert types, make use of `flash[:alert_message]` to store your message, and `flash[:alert_type]` to select one of the 8 bootstrap alert types.

E.g. (in a controller):
```ruby
flash[:alert_message] = "Hello, World!!"
flash[:alert_type] = "danger"
```

## From the client
Interacting with the module in javascript is fairly simple, `PageAlert.js` exports a singleton, `pageAlert`, that you can use to show messages.

To send an alert to the user from a client-side script, first use the `PageAlert#setMessage` method to set your message,
followed by the `PageAlert#flash` to actually send that message to the user, as is used in `page_alert_driver`.

E.g.:

```javascript
pageAlert.setMessage("Hello, World!!", "danger");
pageAlert.flash(true, 3000)
```

See `scripts/lib/PageAlert.js` for the full function signature/docstrings.
