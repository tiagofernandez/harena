angular.module('Harena').controller "SignUpController", ($scope, Validator) ->

  $scope.validator = new Validator()
  $scope.errors = {}

  $scope.validateUsername = ->
    message = $scope.validator.checkUsername($scope.username)
    $scope.errors.username = message

  $scope.validateEmail = ->
    message = $scope.validator.checkEmail($scope.email)
    $scope.errors.email = message

  $scope.validatePassword = ->
    message = $scope.validator.checkPassword($scope.password)
    $scope.errors.password = message
    @validatePasswordConfirmation()

  $scope.validatePasswordConfirmation = ->
    message = $scope.validator.checkPasswordConfirmation($scope.password, $scope.passwordConfirmation)
    $scope.errors.passwordConfirmation = message

  $scope.validateTimezone = ->
    message = $scope.validator.checkTimezone($scope.timezone)
    $scope.errors.timezone = message
