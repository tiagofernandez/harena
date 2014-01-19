app = angular.module('Harena', ['ui.bootstrap'])

# Add CSRF token to API requests
app.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

$(document).on 'page:load', ->
  # Makes AngularJS work with turbolinks
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])

$ ->
  # Activate image picker for avatars
  $("select#player_avatar").imagepicker()
