# ActiveModel::Session

`ActiveModel::Session` is a lightweight session model implemented
on top of `ActiveModel::Model`.

## Installation

Add this line to your application's Gemfile:

    gem "active_model-session"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model-session

## Usage

The most popular workflow is:

    class SessionsController < ApplicationController
      def new
        @session = ActiveModel::Session.new
      end

      def create
        @session = ActiveModel::Session.new(session_params)
        if @session.valid?
          session[:user_id] = @session.user_id
          redirect_to root_url, notice: "You have been successfully logged in."
        else
          render :new
        end
      end

      private

      def session_params
        params.require(:active_model_session).permit(:email, :password)
      end
    end

It uses `User` model by default, and executes `authenticate` method
provided normally by `has_secure_password` in `User` model. If you
need to authenticate a different type of user, you can do:

     @session = ActiveModel::Session.new(session_params)
     @session.user = Admin.find_by(email: @session.email)
     if @session.valid?
       # ...

If you don't like the default behavior, you can always inherit the
session model and override some defaults:

     class Session < ActiveModel::Session
       def email=(email)
         @email = email.downcase if email.present?
       end
     end


## Copyright

Copyright © 2013 Kuba Kuźma. See LICENSE for details.
