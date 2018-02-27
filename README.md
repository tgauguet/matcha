# Matcha

This project belongs to 42's web branch.
It's purpose is to create a Tinder like without any ORM like ActiveRecord

## Getting started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

1. Ruby version 2.2.4
2. Sinatra version 2.0.0
3. MySQL version 5.7.10

### Installing

```
mysql -u root -proot
create database matcha;
exit

git clone https://github.com/tgauguet/matcha_tim.git
cd matcha_tim
bundle install
ruby app.rb
```
### Running

```
ruby app.rb
```

## Running the tests

```
soon
```

## Built with

* Ruby
* Sinatra
* jQuery

## How to :

### Index all Objects

in ObjectController
```
@object = Object.all
```
in views/object/index.html.erb
```
<% @object.each do |object| %>
  <% object.to_dot %>
  <%= object.id %>
<% end %>
```

### Find object by id (or whatever you want)

in ObjectController
```
@object = Object.find_by("id", current_object.id)
```
in views/object/show.html.erb
```
<%= @object.id %>
```

### Create new object
