angular.module('Harena').controller "NewTournamentController", ($scope, Validator) ->

  $scope.validator = new Validator()
  $scope.errors = {}

  $scope.validateTitle = ->
    message = $scope.validator.checkTitle($scope.title)
    $scope.errors.title = message
