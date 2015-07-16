var app = angular.module("App", ["ngMessages"]);

app.service("uniqueValidationService", function($http, $q) {
  this.isUnique = function(value, validateUrl) {
    var defer = $q.defer();
    
    $http.get(validateUrl, {params: value}).success(function(unique) {
      defer.resolve(unique);
    }).error(function(error) {
      defer.reject(error);
    });
    
    return defer.promise;
  }
});

app.directive("passwordConfirm", function() {
  return {
    restrict: "AE",
    require: "ngModel",
    scope: {
      passwordConfirm: "="
    },
    link: function(scope, elem, attr, ngModel) {
      scope.$watch(function() {
        ngModel.$validate();
      });
      
      ngModel.$validators.passwordConfirm = function(value) {
        return value == scope.passwordConfirm;
      }
    }
  }
});

app.directive("email", function() {
  return {
    restrict: "AE",
    require: "ngModel",
    link: function(scope, elem, attr, ngModel) {
      scope.$watch(function() {
        ngModel.$validate();
      });
      
      ngModel.$validators.email = function(value) {
        exp = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        return exp.test(value);
      }
    }
  }
});

app.directive("unique", function(uniqueValidationService, $timeout) {
  var timeout;
  
  return {
    restrict: "AE",
    require: "ngModel",
    link: function(scope, elem, attr, ngModel) {
      elem.bind("blur", function() {
        var params = {};
        params[attr.unique] = ngModel.$viewValue;
        
        uniqueValidationService.isUnique(params, attr.url)
          .then(function(unique) {
            ngModel.$setValidity("unique", unique);
          }, function(error) {
            ngModel.$setValidity("unique", false);
          });
      });
    }
  };
});
