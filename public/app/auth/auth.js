'use strict';

angular.module('auther.auth', ['ngRoute', 'ngResource', 'ngCookies'])
.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/login', {
    templateUrl: 'auth/login.html',
    controller: 'LoginCtrl'
  }).
  when('/logout', {
    template: "",
    controller: 'LogoutCtrl'
  });
}])
.controller('LoginCtrl', ['$scope', '$resource', '$location', 'Client', 'AuthSession', function($scope, $resource, $location, Client, AuthSession) {
  $scope.user = {};
  $scope.authError = false;
  $scope.clients = Client.query();
  $scope.login = function() {
    AuthSession.authenticateUser($scope.user).then(function(data) {
      $location.path("/clients");
    }, function(response) {
      $scope.authError = true;
    });
  };
}])
.service("AuthSession", ["$http", "$cookies", "$rootScope", function($http, $cookies, $rootScope) {
  return {
    isAuthenticated: false,
    checkAuthenticationCookie: function() {
      var authCookie = $cookies.getObject("autherAuthSession");
      if (authCookie) {
        this.login(authCookie.authenticatedUser);
      }
    },
    logout: function() {
      this.isAuthenticated = false;
      this.authenticatedUser = null;
      $cookies.remove('autherAuthSession');
      $rootScope.$broadcast('auther:authenticated');
    },
    login: function(user) {
      this.isAuthenticated = true;
      this.authenticatedUser = user;
      $rootScope.$broadcast('auther:authenticated');
    },
    authenticateUser: function(user) {
      user.grant_type = "password";
      var authPromise = $http({
        method: "POST",
        url: '/token',
        params: user
      })
      var self = this;
      authPromise.then(function(response) {
        delete user.password;
        self.login(user);
        var expireDate = new Date((new Date()).getTime() + response.data.expires_in*1000);
        $cookies.putObject("autherAuthSession", self, { expires: expireDate });
      }, function(response) {
        this.isAuthenticated = false;
      });
      return authPromise;
    }
  };
}])
.controller('LogoutCtrl', ['$scope', '$location', 'Client', 'AuthSession', function($scope, $location, Client, AuthSession) {
  AuthSession.logout();
  $location.path("/login");
}]);
