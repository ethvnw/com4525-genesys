# Using the `PageAlert` module
## From the server
Sending an alert from the server is exactly the same as it was before.
Just use `flash[:notice]` or `flash[:alert]`, and the `convert_flash_message` method of `ApplicationController` will handle the rest!

E.g.:
```ruby
redirect_to(:root_path, notice: "Hello, World!!")
```

For access to the full set of bootstrap alert types, add an 'alert' hash to the `@js_data` instance variable, containing both `message` and `type`.

E.g. (in a controller):
```ruby
@js_data = { alert: { message: "Hello, World!!", type: "danger" } }
```

Or if your controller redirects, use `flash[:js_data]`, like so:
```ruby
flash[:js_data] = { alert: { message: "Hello, World!!", type: "danger" } }
```

`type` can be any of `["primary", "secondary", "success", "danger", "warning", "info", "light", "dark"]`.
See [the Bootstrap documentation](https://getbootstrap.com/docs/4.0/components/alerts/).

## From the client
To send an alert to the user from a client-side script, make use of the `pageAlert#flash` method, as is used in `page_alert_driver`.

E.g.:
```javascript
pageAlert.flash("Hello, World!!", "danger", true, 3000);
```

See `scripts/lib/PageAlert.js` for the full function signature/docstrings.
