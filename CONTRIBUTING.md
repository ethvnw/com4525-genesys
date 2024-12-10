# Contributing to Roamio
## Style Guides Used
For all of your code, please ensure that it follows the following style guides:
- Ruby/Rails: The [Shopify Style Guide](https://ruby-style-guide.shopify.dev/)
- JavaScript: The [Airbnb Style Guide](https://github.com/airbnb/javascript)
- HAML: The default style guide provided by [haml-lint](https://github.com/sds/haml-lint)

To ensure accordance with these style guides, we use a variety of tools (please run each of these before making a PR):
- `rubocop` to ensure accordance with the Ruby/Rails style guide.
- `yarn run eslint .` to ensure accordance with the JavaScript style guide.
- `haml-lint` to ensure accordance with the HAML style guide.

## Branch Naming
We use a naming convention that is based on [Conventional Commits](https://www.conventionalcommits.org/en) for our branches. When creating a branch, your branch name should follow the following format:

`type/[story number]-[description]`

Where `type` is one of:
- `feat` for new features.
- `fix` for bugfixes.
- `chore` for small changes that have little impact on the product, such as adding/removing dependencies.
- `test` for adding/updating tests.

## Conventional Commits
We use the [Conventional Commits](https://www.conventionalcommits.org/en) specification for our commit messages.

- Push commits following `type(scope): description` for the name.
  - `type` should be one of the ones outlined [above](#branch-naming).
  - `scope` refers to the _scope_ of the change, e.g. `views`, `admin-dashbaoard`, or `api`.
  - `description` is a short description of the change.
- Ensure that your PRs are titled following this spec, as the PR title becomes the commit message.

## Creating a PR
### First Steps
- Ensure you have added new tests for any new functionality.
- Ensure your code meets the style standards by running the linters `haml-lint`, `yarn run eslint .`, and `rubocop`.
- Ensure your code passes all tests by running `rake spec`.
### Making a PR
Once you have followed all of the above steps, you are free to [make a PR](https://git.shefcompsci.org.uk/com4525-2024-25/team02/project/-/merge_requests/new)!