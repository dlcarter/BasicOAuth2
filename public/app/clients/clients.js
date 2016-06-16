'use strict';

angular.module('auther.clients', ['ngRoute', 'ngResource'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/clients', {
    templateUrl: 'clients/clients.html',
    controller: 'ClientsCtrl'
  });
}])

.controller('ClientsCtrl', ['$scope', '$resource', 'Client', function($scope, $resource, Client) {
  console.log("yey");
  $scope.newClient = new Client();
  $scope.clients = new Client.query();
  $scope.saveNewClient = function() {
    console.log("Saving...", $scope.newClient);
    console.log("OK");
    $scope.isAdding = false;
    $scope.newClient.$save().then(function() {
      $scope.newClient = new Client();
      $scope.clients = new Client.query();
    });
  };

}])

.factory("Client", ["$http", "$resource", function($http, $resource) {
  var url = "/clients"
  return $resource(url);
}]);
