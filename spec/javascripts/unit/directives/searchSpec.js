describe("Directive: search", function() {
  var scope, input, httpBackend, timeout, service;
  
  beforeEach(module("App"));
  
  beforeEach(inject(function($rootScope, $compile, $httpBackend, $timeout, Episode) {
    scope = $rootScope.$new();
    httpBackend = $httpBackend;
    timeout = $timeout;
    service = Episode;
    
    var element = angular.element(
      "<form name='form'>" +
        "<input name='title' ng-model='object.title'>" +
      "</form>" +
      "<div search='object.title'></div>"
    );
    
    scope.object = {};
    $compile(element)(scope);
    
    input = scope.form.title;
    httpBackend.whenGET("templates/directives/search.html").respond(200);
    httpBackend.flush();
  }));
  
  it("should be in search mode when model is not empty", function() {
    httpBackend.whenGET("/api/episodes/search?title=title").respond(200, {episodes: [1,2,3]});
    input.$setViewValue("title");
    timeout.flush(500);
    httpBackend.flush();
    scope.$digest();
    
    expect(scope.object.searchMode).toBe(true);
    expect(scope.object.paginate).toBeDefined();
    expect(scope.object.paginate.episodes).toBeDefined();
  });
  
  it("should not be in search mode when model is empty", function() {
    httpBackend.whenGET("/api/episodes").respond(200, {episodes: [1,2,3]});
    input.$setViewValue("");
    timeout.flush(500);
    httpBackend.flush();
    scope.$digest();
    
    expect(scope.object.searchMode).toBe(false);
    expect(scope.object.paginate).toBeDefined();
    expect(scope.object.paginate.episodes).toBeDefined();
  });
});
