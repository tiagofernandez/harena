angular.module('Harena').controller "SignInController", ($scope, Validator) ->

  $scope.validator = new Validator()
  $scope.errors = {}

  $scope.validateEmail = ->
    message = $scope.validator.checkEmail($scope.email)
    $scope.errors.email = message
