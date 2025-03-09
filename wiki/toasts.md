# Using the custom toasts
Bootstrap toasts are what we are using to send notifications to the user.
These may be styled with any of the 8 bootstrap types
(`["primary", "secondary", "success", "danger", "warning", "info", "light", "dark"]` -
see [the Bootstrap documentation](https://getbootstrap.com/docs/4.0/components/alerts/)).

## From the server
Sending an alert from the server is exactly the same as it was before.
Just use `flash[:notice]` or `flash[:alert]`, and the `convert_flash_message`
method of `ApplicationController` will handle the rest!

E.g.:
```ruby
redirect_to(:root_path, notice: "Hello, World!!")
```

For access to the full set of bootstrap alert types, make use of `flash[:notifications]`
to store your messages as a hash containing both `message` (the message you want
to send, and `notification_type` to select which of the 8 bootstrap alert types 
you want to style it as.

E.g.:
```ruby
flash[:notifications] << { message: "Hello, World!!", notification_type: "success" }
```

`flash[:alerts]` will be iterated over in `application.html.haml`, allowing you
to send as many notifications as you wish (they will stack automatically).

## From the client
To send a notification to the user from client-side javascript, you can make use
of the `buildNewToast` method exported by the `ToastUtils` module to generate a
bootstrap toast, and then call its `.show` method to show it.

E.g.:

```javascript
buildNewToast('Hello, World!!', 'success').show();
```

To make a toast to show the user that something is happening in the background
(e.g. attempting to regain connection, or a request is being made), make use of
the optional `spinner` argument, as below:

```javascript
buildNewToast('Attempting to regain connection...', 'warning', true).show();
```

This will create a toast that can only be dismissed through calling its `.hide`
method, which contains a spinner.

See [`scripts/lib/ToastUtils.js`](../app/packs/scripts/lib/ToastUtils.js) for
the full function signature/docstrings.
