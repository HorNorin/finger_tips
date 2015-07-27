var app = angular.module("App", ["ngMessages", "ngResource", "ngAnimate", "ngtimeago"]);

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

app.factory("Lesson", function($resource) {
  return $resource("/api/lessons/:id", {name: "@name", page: "@page"}, {
    index: {method: "GET"},
    trending: {method: "GET", url: "/api/lessons/trending"},
    search: {method: "GET", url: "/api/lessons/search"}
  });
});

app.factory("Episode", function($resource) {
  return $resource("/api/episodes/:id", {title: "@title", page: "@page"}, {
    index: {method: "GET"},
    trending: {method: "GET", url: "/api/episodes/trending"},
    search: {method: "GET", url: "/api/episodes/search"}
  });
});

app.factory("Comment", function($resource) {
  return $resource("/api/comments/:id", {id: "@id"});
});

app.factory("User", function($resource) {
  return $resource("/api/users/:id", {id: "@id"}, {
    update: {method: "POST", url: "/api/users/update", isArray: false}
  });
});

app.factory("sharedScope", function($rootScope) {
  var scope = $rootScope.$new(true);
  scope.data = {};
  return scope;
});

app.controller("HomeController", function($scope, $interval) {
  $scope.lessons = [
    "Lesson #1",
    "aaaaaaaaaaaaa",
    "bbbbbbbbbbbbbbbb",
    "cccccccccccccccccccccc",
    "ddddddddddddddddddddddddddd"
  ];
  
  $scope.currentIndex = 0;
  
  $scope.isCurrentIndex = function(index) {
    return $scope.currentIndex === index;
  }
  
  $scope.nextImage = function() {
    if ($scope.currentIndex == $scope.lessons.length - 1) {
      $scope.currentIndex = 0;
    } else {
      ++$scope.currentIndex;
    }
  }
  
  $scope.interval = $interval($scope.nextImage, 3000);
  
  $scope.pause = function() {
    if ($scope.interval) $interval.cancel($scope.interval);
    console.log("pause");
  }
  
  $scope.resume = function() {
    $scope.interval = $interval($scope.nextImage, 3000);
    console.log("resume");
  }
});

app.animation(".slide-animation", function() {
  return {
    beforeAddClass: function(element, clasName, done) {
      if (clasName === "ng-hide") {
        var start = element.parent().width();
        TweenLite.to(element, 0.5, {left: start, onComplete: done});
      } else {
        done();
      }
    },
    removeClass: function(element, clasName, done) {
      var scope = element.scope();
      if (clasName === "ng-hide") {
        var start = element.parent().width();
        element.removeClass("ng-hide"); 
        TweenLite.fromTo(element, 0.5, {left: -start}, {left: 0, onComplete: done});
      } else {
        done();
      }
    }
  }
});

app.controller("EpisodesController", function($scope, sharedScope, Episode) {
  $scope.object = sharedScope.data;
  
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
  
  $scope.all = function() {
    Episode.index({}, function(object) {
      $scope.object.paginate = object;
      $scope.object.searchMode = false;
      $scope.isAll = true;
    });
  }
  
  $scope.trending = function() {
    Episode.trending({}, function(object) {
      $scope.object.paginate = object;
      $scope.object.searchMode = false;
      $scope.isAll = false;
    });
  }
  
  $scope.all();
});

app.controller("LessonsController", function($scope, sharedScope, Lesson) {
  $scope.object = sharedScope.data;
  
  
  $scope.goto = function(page) {
    if ($scope.object.searchMode) {
      Lesson.search({name: $scope.object.name, page: page}, function(object) {
        $scope.object.paginate = object;
      });
    } else {
      Lesson.index({page: page}, function(object) {
        $scope.object.paginate = object;
      });
    }
  }
  
  $scope.all = function() {
    Lesson.index({}, function(object) {
      $scope.object.paginate = object;
      $scope.object.searchMode = false;
      $scope.isAll = true;
    });
  }
  
  $scope.trending = function() {
    Lesson.trending({}, function(object) {
      $scope.object.paginate = object;
      $scope.object.searchMode = false;
      $scope.isAll = false;
    });
  }
  
  $scope.all();
});

app.directive("account", function() {
  return {
    restrict: "AE",
    templateUrl: "/templates/directives/account_form.html",
    scope: {
      emailAddress: "@emailAddress",
      username: "@"
    },
    controller: function($scope, User) {
      $scope.updateAccount = function() {
        User.update($scope.user, function(location) {
          window.location = location.path;
        });
      }
      
      $scope.user = {
        email: $scope.emailAddress,
        username: $scope.username
      };
    }
  }
});

app.directive("commentArea", function() {
  return {
   restrict: "AE",
   templateUrl: "/templates/directives/comment_area.html",
   scope: {
    isLoggedIn: "=loggedIn",
    episode: "=episode"
   },
   controller: function($scope, Comment) {
    $scope.comment = {};
    $scope.comments = Comment.query({episode_id: $scope.episode});
    $scope.createComment = function() {
      $scope.comment.episode_id = $scope.episode;
      var comment = new Comment({comment: $scope.comment});
      Comment.save(comment, function(newComment) {
        $scope.comments.unshift(newComment);
        $scope.comment = {};
      });
    }
   }
  }
});

app.directive("timeAgo", function() {
  return {
    restrict: "AE",
    template: "{{ timeago }}",
    scope: { timeAgo: "=" },
    controller: function($scope, $interval, $filter) {
      $scope.timeago = $filter("timeago")(new Date($scope.timeAgo));
      $interval(function() {
        $scope.timeago = $filter("timeago")(new Date($scope.timeAgo));
      }, 1000 * 60);
    }
  }
});

app.directive("episodeSearch", function(Episode, $timeout) {
  return {
    restrict: "AE",
    require: "?ngModel",
    templateUrl: "/templates/directives/episode_search.html",
    link: function(scope, elem, attr, ngModel) {
      var timeout;
      scope.$watch(attr.episodeSearch, function(value) {
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

app.directive("lessonSearch", function(Lesson, $timeout) {
  return {
    restrict: "AE",
    require: "?ngModel",
    templateUrl: "/templates/directives/lesson_search.html",
    link: function(scope, elem, attr, ngModel) {
      var timeout;
      scope.$watch(attr.lessonSearch, function(value) {
        if (timeout) $timeout.cancel(timeout);
        
        timeout = $timeout(function() {
          if (value && value !== "") {
            Lesson.search({name: value}, function(object) {
              scope.object.paginate = object;
              scope.object.searchMode = true;
            });
          } else if(value !== undefined) {
            Lesson.index({}, function(object) {
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
        if (!value && !scope.passwordConfirm) return true;
        return value === scope.passwordConfirm;
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
        if (attr.old === ngModel.$viewValue) return;
        
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
