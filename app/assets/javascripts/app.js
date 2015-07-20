var app = angular.module("App", ["ngMessages", "ngResource", "ngAnimate"]);

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

app.factory("Episode", function($resource) {
  return $resource("/api/episodes/:id", {title: "@title", page: "@page"}, {
    search: {method: "GET", url: "/api/episodes/search"},
    index: {method: "GET"}
  });
})

app.factory("sharedScope", function($rootScope) {
  var scope = $rootScope.$new(true);
  scope.data = {};
  return scope;
})

app.controller("HomeController", function($scope, sharedScope, Episode) {
  $scope.object = sharedScope.data;
  
  Episode.index({}, function(object) {
    $scope.object.paginate = object;
    $scope.object.searchMode = false;
  });
  
  $scope.goto = function(page) {
    if ($scope.object.searchMode) {
      Episode.search({title: $scope.object.title, page: page}, function(object) {
        $scope.object.paginate = object;
      });
    } else {
      Episode.index({page: page}, function(object) {
        $scope.object.paginate = object;
      });
    }
  }
});

app.directive("search", function(Episode, $timeout) {
  return {
    restrict: "AE",
    require: "?ngModel",
    templateUrl: "templates/directives/search.html",
    link: function(scope, elem, attr, ngModel) {
      var timeout;
      scope.$watch(attr.search, function(value) {
        if (timeout) $timeout.cancel(timeout);
        
        timeout = $timeout(function() {
          if (value && value !== "") {
            Episode.search({title: value}, function(object) {
              scope.object.paginate = object;
              scope.object.searchMode = true;
            });
          } else if(value !== undefined) {
            Episode.index({}, function(object) {
              scope.object.paginate = object;
              scope.object.searchMode = false;
            });
          }
        }, 500);
      });
    }
  };
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
