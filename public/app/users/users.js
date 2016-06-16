'use strict';

angular.module('auther.users', ['ngRoute', 'ngResource'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/users', {
    templateUrl: 'users/users.html',
    controller: 'UsersCtrl'
  });
}])

.controller('UsersCtrl', ['$scope', '$resource', 'User', function($scope, $resource, User) {
  console.log("yey");
  var users = new User.query(function(data) {
    $scope.newUser = new User();
    $scope.users = data;
    console.log($scope.users);
  });
  
  $scope.saveNewUser = function() {
    $scope.newUser.$save();
  };

}])

.factory("User", ["$http", "$resource", function($http, $resource) {
  var url = "/users"
  return $resource(url);
}]);
