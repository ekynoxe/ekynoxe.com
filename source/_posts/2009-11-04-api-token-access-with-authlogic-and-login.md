---
title: Api token access with authlogic and login
author: Matt
layout: post
categories:
  - authlogic
  - ruby
tags:
  - authlogic
  - ruby
---
Creating an API for one project at work, one of the tasks was to implement a token based authentication for some resources, but the client specifically requested not to have to handle cookies.
Also, it was requested for the user to still have to login with it&#8217;s own login and password, rather than with a permanent token, like a permanent API key.
The solution I implemented used the excellent authlogic capabilities with the single\_access\_token, although used slighlty differently from it&#8217;s original purpose.
<!--more-->

Rather than keeping the single access token generated at user registration untouched, like a standard API key, I enforced it&#8217;s regeneration at both login and logout. Returned in the login response, that token then has to be provided by the client for every request that needs authentication, effectively playing the same role as a cookie.

With this solution, the client looses the ability to stay logged in by storing the credentials in the client&#8217;s machine, but as the project it&#8217;s been created for only required an API, there was no problem with that.
Implementing this solution simply puts a little big more work on the client to store and provide the token in the requests parameters, but I still found it an elegant solution to get around my problem.

The following code implements this solution in the Application and the User\_Session controllers, showing the regeneration of the token in both login and logout actions with authlogic&#8217;s reset\_single\_access\_token method.

<h2>app > controllers > application_controller</h2>

<pre class="brush: ruby; highlight: [7,17]; title: ; notranslate" title="">
  class ApplicationController &gt; ActionController::Base
  ...
  helper_method :check
  ...
  def check
      if current_user==nil
          respond_to do |format|
          format.html {redirect_to login_path} #assuming you have a named login route
          format.xml {render :xml=>'<?xml version="1.0" encoding="UTF-8"?><response><status>401</status><error>unauthorized</error></response>',:status=>:unauthorized}
          end
      end
  end
  ...
</pre>

<h2>app > controllers > user_sessions_controller</h2>
<pre class="brush: ruby; highlight: [7,17]; title: ; notranslate" title="">
class UserSessionsController &lt; ApplicationController

  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save
        current_user.reset_single_access_token!
        format.xml
      else
       format.xml {render :xml=&gt;@user_session.errors, :status=&gt;:unauthorized}
      end
    end
  end

  def destroy
    if(@user_session = UserSession.find)
      current_user.reset_single_access_token!
      @user_session.destroy
      respond_to do |format|
        format.xml {render :xml=&gt;{:status=&gt;'200 ok'},:status=&gt; :ok}
      end
    else
      respond_to do |format|
         format.xml  {render :xml=&gt;@user_session.errors, :status=&gt; :not_found}
      end
    end
  end
end
</pre>

<h2>app > models > user</h2>

<pre class="brush: ruby; highlight: [2]; title: ; notranslate" title="">
  class User &lt; ActiveRecord::Base
    acts_as_authentic
  end
</pre>

<h2>app > views > users_sessions > create.xml.builder</h2>

<pre class="brush: ruby; highlight: [5]; title: ; notranslate" title="">
  xml.instruct! :xml, :version=&gt;&quot;1.0&quot;

  xml.user{
      xml.user_id(current_user.id)
      xml.user_credentials(current_user.single_access_token)
  }
</pre>

<h2>app > controllers > users_controller</h2>

<pre class="brush: ruby; highlight: [2]; title: ; notranslate" title="">
  class UsersController &lt; ApplicationController
    before_filter :check

    def create
    end

    def index
    end

    def update
    end

    def show
    end

  end
</pre>

<h2>db > migrate > create_users</h2>

<pre class="brush: ruby; highlight: [8]; title: ; notranslate" title="">
  class CreateUsers &lt; ActiveRecord::Migration
    def self.up
      create_table :users do |t|
        t.string  :username
        t.string  :crypted_password
        t.string  :password_salt
        t.string  :persistence_token
        t.string  :single_access_token, :null =&gt; false

        t.timestamps
      end
    end

    def self.down
      drop_table :users
    end
  end
</pre>