angular.module('Harena').factory 'Validator', () ->
  class Validator

    unless String::trim then String::trim = -> @replace /^\s+|\s+$/g, ""

    constructor: ->
      @patterns =
        email    : /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i
        timezone : /^GMT[+-][01]\d:[0-5][05]\s.{3,}$/
        title    : /^[\w\s]+$/i
        username : /^[a-zA-Z0-9]+$/i

    checkUsername: (username) ->
      switch
        when not username
          'Enter your username'
        when username.length < 3
          'Enter at least 3 characters'
        when username.length > 20
          'Enter at most 20 characters'
        when not username.match @patterns.username
          'Use only letters and numbers'
        else
          ''

    checkEmail: (email) ->
      switch
        when not email?.match @patterns.email
          'Enter a valid e-mail'
        else
          ''

    checkPassword: (password) ->
      switch
        when not password
          'Enter a password'
        when password.length < 6
          'Enter at least 6 characters'
        else
          ''

    checkPasswordConfirmation: (password, passwordConfirmation) ->
      switch
        when password isnt passwordConfirmation
          'Confirmation does not match'
        else
          ''
        
    checkTimezone: (timezone) ->
      switch
        when not timezone
          'Set your timezone'
        when not timezone.match @patterns.timezone
          'Invalid timezone'
        else
          ''

    checkTitle: (title) ->
      switch
        when not title
          'Enter the title'
        when title.length < 10
          'Enter at least 10 characters'
        when title.length > 40
          'Enter at most 40 characters'
        when not title.match @patterns.title
          'Use only alphanumeric characters'
        else
          ''