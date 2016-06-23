'use strict';

// Declare app level module which depends on views, and components
angular.module('auther', [
  'ngRoute',
  'ngResource',
  'auther.clients',
  'auther.auth'
]).
config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
  $locationProvider.hashPrefix('!');
  
  $routeProvider.otherwise({redirectTo: '/clients'});
}]).
run(['$rootScope', '$route', 'AuthSession', function($rootScope, $route, AuthSession) {
  $rootScope.route = $route;
  $rootScope.$on('auther:authenticated', function(event, data) {
    $rootScope.isAuthenticated = AuthSession.isAuthenticated;
    $rootScope.authenticatedUser = AuthSession.authenticatedUser;
  });
  AuthSession.checkAuthenticationCookie();
}]);
