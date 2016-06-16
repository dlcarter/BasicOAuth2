'use strict';

// Declare app level module which depends on views, and components
angular.module('auther', [
  'ngRoute',
  'ngResource',
  'auther.users',
  'auther.clients'
]).
config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
  $locationProvider.hashPrefix('!');

  $routeProvider.otherwise({redirectTo: '/clients'});
}]);
