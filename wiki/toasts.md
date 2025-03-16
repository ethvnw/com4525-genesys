# Using the custom toasts
Bootstrap toasts are what we are using to send notifications to the user.
These may be styled with any of the 8 bootstrap types
(`["primary", "secondary", "success", "danger", "warning", "info", "light", "dark"]` -
see [the Bootstrap documentation](https://getbootstrap.com/docs/4.0/components/alerts/)).

## From the server
### Before a full redirect
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

### Using turbo streams
More sophisticated toasting can be achieved using 
[Turbo streams](https://turbo.hotwired.dev/handbook/streams), by using the `append`
action to add a toast to the toast list, which will then be detected & shown by
the `MutationObserver`. See below for an example (from 
[`controllers/invitations_controller`](../app/controllers/invitations_controller.rb)).

```ruby
format.turbo_stream do
  render(turbo_stream: [
    # ...
    # Other turbo stream actions (if any)
    # ...
    turbo_stream.append(
      "toast-list",
      partial: "partials/toast",
      locals: {
        notification_type: "success",
        message: "Invitation sent successfully to #{user.email}.",
      },
    ),
  ])
  format.html { redirect_to(admin_dashboard_path) }
end
```

## From the client
To send a notification to the user from client-side javascript, you can make use
of the `buildNewToast` method exported by the `ToastUtils` module to generate a
bootstrap toast. Once used, the toast's addition to the DOM will be detected by
the `MutationObserver`, and the toast will be shown

E.g.:

```javascript
buildNewToast('Hello, World!!', 'success');
```

To make a toast to show the user that something is happening in the background
(e.g. attempting to regain connection, or a request is being made), make use of
the optional `spinner` argument, as below:

```javascript
buildNewToast('Attempting to regain connection...', 'warning', true);
```

This will create a toast which contains a spinner and can only be dismissed 
through calling its `.hide()` method.

See [`scripts/lib/ToastUtils.js`](../app/packs/scripts/lib/ToastUtils.js) for
the full function signature/docstrings.
