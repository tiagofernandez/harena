app = angular.module('Harena', ['ui.bootstrap'])

# Add CSRF token to API requests
app.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

# Directive to check that passwords match
app.directive "passwordMatch", [->
  restrict: "A"
  scope: true
  require: "ngModel"
  link: (scope, elem, attrs, control) ->
    checker = ->
      e1 = scope.$eval(attrs.ngModel)
      e2 = scope.$eval(attrs.passwordMatch)
      e1 is e2
    scope.$watch checker, (n) ->
      control.$setValidity "unique", n
]

$(document).on 'page:load', ->
  # Makes AngularJS work with turbolinks
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])

$ ->
  # Activate image picker for avatars
  $("select#player_avatar").imagepicker()
