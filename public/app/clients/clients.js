'use strict';

angular.module('auther.clients', ['ngRoute', 'ngResource'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/clients', {
    templateUrl: 'clients/clients.html',
    controller: 'ClientsCtrl'
  })
  .when('/clients/:clientId', {
    templateUrl: 'clients/client_show.html',
    controller: 'ClientShowCtrl'
  });
}])

.controller('ClientsCtrl', ['$scope', '$resource', 'Client', function($scope, $resource, Client) {
  $scope.setup = function() {
    $scope.newClient = new Client();
    $scope.clients = new Client.query();
    $scope.isAddingClient = false;
  }
  $scope.setup();
  $scope.saveNewClient = function() {
    $scope.newClient.$save().then(function() {
      $scope.setup();
    }, function(response) {
      if (response && response.data && response.data.errors) {
        $scope.newClient.errors = response.data.errors;
      } else {
        $scope.newClient.errors = { base: ["There was an error communicating with the server, please try again."] }
      }
    });
  };

}])

.controller('ClientShowCtrl', ['$scope', '$resource', '$routeParams', 'Client', 'User', function($scope, $resource, $routeParams, Client, User) {
  $scope.client = Client.get({id: $routeParams.clientId}, function(data) {
    $scope.client = data;
  });
  $scope.setup = function() {
    $scope.newUser = new User();
    User.query({clientId: $routeParams.clientId }, function(data) {
      $scope.users = data;
    });
    $scope.isAddingUser = false;
  }
  $scope.setup();
  
  $scope.saveNewUser = function() {
    $scope.newUser.$save({ clientId: $scope.client.id }).then(function () {
      $scope.setup();
    }, function(response) {
      if (response && response.data && response.data.errors) {
        $scope.newUser.errors = response.data.errors;
      } else {
        $scope.newUser.errors = { base: ["There was an error communicating with the server, please try again."] }
      }
    });
  };

}])


.factory("Client", ["$http", "$resource", function($http, $resource) {
  var url = "/clients/:id"
  return $resource(url, { id: "@id" });
}])

.factory("User", ["$http", "$resource", function($http, $resource) {
  var url = "/clients/:clientId/users"
  return $resource(url, { clientId: "@client_id" });
}]);
