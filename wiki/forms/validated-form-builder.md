# Creating validated forms
When adding a form, make use of the `ValidatedFormBuilder` helper class to
construct it. This integrates nicely with the default form helpers, using the
`builder` option, as follows:

```haml
= simple_form_for(resource,
                  as: resource_name,
                  url: registration_path(resource_name),
                  builder: ValidatedFormBuilder,
                  errors: errors,
                  html: { method: :put, "data-turbo": "true" }) do |f|
```

This tells the form to use `ValidatedFormBuilder` when creating its fields,
retrieving error messages from the `errors` hash (in the format supplied by
`errors_to_hash(true)` - e.g. `@trip.errors_to_hash(true)`).

To create validated fields, use the `validated_x` variant of form fields.
Currently, this supports `input`, `select`, and `datetime`. For an example,
see below (taken from `partials/plans/_form.html.haml`)

```haml
= f.validated_input(:title,
                    placeholder: "Enter the title of the plan...")
= f.validated_select(:plan_type,
                    options_for_select(plan_types, selected: plan.plan_type)
                    prompt: "Select plan type",
                    required: true)

...

= f.validated_datetime(:start_date)
= f.validated_datetime(:end_date)
```

These can be used in the same way as the regular versions. Any options passed
are passed through to the input element itself, with the exception of `class`.
This option is used to set the class of the div which wraps the input.

Another useful option is `error_key`, which can be used if the input should
display an error with a key other than its attribute name.