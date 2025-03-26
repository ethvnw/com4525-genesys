# Using Turbo Streams

Form updates should be performed using turbo streams, which can be done easily
using the helper concern, `Streamable`. Simply include this in your controller
and then you're ready to use the turbo helpers:

```ruby
class YourController < ApplicationController
  include Streamable
  # ... rest of your controller code
end
```

## Turbo Stream Templates
To effectively use turbo streams, you first need to create a turbo stream 
template file, which will be stored in the views directory, with the naming convention `turbo_stream_templates/controller/action.turbo_stream.haml`. An
example of one of these templates can be seen below:

```haml
= turbo_stream.update("visible-count", @visible_items.count)
= turbo_stream.update("hidden-count", @hidden_items.count)

= turbo_stream.update("visible-items",
                      partial: "partials/admin/admin_item_list",
                      locals: { items: @visible_items.decorate })

= turbo_stream.update("hidden-items",
                      partial: "partials/admin/admin_item_list",
                      locals: { items: @hidden_items.decorate })
```

More information on these templates can be found [on the hotwired docs](https://www.hotrails.dev/turbo-rails/turbo-frames-and-turbo-streams).

## Available Methods

### stream_response

The `stream_response` method handles both Turbo Stream and HTML requests. 

```ruby
stream_response(
  "reviews/create", 
  root_path,
  { type: "success", content: "Successfully added review." }
)
```

For turbo stream requests, this will render the template
`turbo_stream_templates/reviews/create.turbo_stream.haml`, and show the user
a flash success message with the content "Successfully added review".

For HTML requests, this will redirect the user to `root_path`, and show a
flash message. 

### turbo_redirect_to

A convenience method for handling Turbo Stream redirects, useful if you want
a form to show errors on failure, and to redirect on success.

Can be used as a drop-in replacement for `redirect_to`:

```ruby
if @registration.save
  turbo_redirect_to(
    root_path,
    notice: "Successfully registered. Keep an eye on your inbox for updates!"
  )
else
  @subscription_tier_id = registration_params[:subscription_tier_id]
  stream_response("registrations/create", new_subscription_path(s_id: @subscription_tier_id))
end
```

Or you can pass a custom message to access the full range of bootstrap toasts:

```ruby
turbo_redirect_to(admin_dashboard_path, { content: "Access removed for #{user.email}", type: "info" })
```

### respond_with_toast

Handles responses that should only show a toast notification, with no other
stream actions:

```ruby
respond_with_toast(
  { type: "success", content: "Resource was successfully deleted." },
  resources_path
)
```

Still requires a fallback path, for HTML requests
