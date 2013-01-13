# DynMeta

Automate the lookup of page meta information based on the current request context. Meta information such as page titles and descriptions can be stored in a translations file rather than floating around in controllers or views.

## Installation

Add dyn_meta to your Gemfile

 gem 'dyn_meta'

Install the gem

 bundle install
 
## Usage

Set up your translations as follows:

```yml
en:
  meta:
    <meta key pluralized>:
      <controller>:
        <action>:
          <id>: "Some meta value"
```

For example:

```yml
en:
  meta:
    titles:
      users:
        new: "Create Your Account"
        edit: "Update Your Account"
```

You usually won't go down to the `id` level but occasionally it's useful:

```yml
en:
  meta:
    titles:
      pages:
        show:
          tos: "Terms of Service"
          pp: "Privacy Policy"
          about: "About My Site"
```

You can define catch-alls via the `default` key:

```yml
en:
  meta:
    titles:
      default: "My Super Site"
      users:
        default: "Manage Your Account"
        new: "Create Your Account"
        edit: "Update Your Account"
``` 

DynMeta provides one method *meta*. It's both a setter and a getter. Just use the *meta* method in your template:

```erb
<title><%= meta(:title) %></title>
<meta name="description" content="<%= meta(:description) %>" />
```

If you'd like to override meta content you can just pass a value to the *meta* method:

```ruby
def show
  @user = User.find(params[:id])
  meta(:title, "#{@user.display_name} :: Profile")
end
```

You can also provide interpolations via the meta method rather than overriding entire locales:

```ruby
def show
  @user = User.find(params[:id])
  meta(:title, :name => @user.display_name})
end
```
 