describe("HomeController", function() {
  var scope;
  
  beforeEach(function() {
    module("App");
    
    inject(function($controller, $rootScope) {
      scope = $rootScope.$new();
      $controller("HomeController", {$scope: scope});
      
      scope.$digest();
    });
  });
  
  it("should have content", function() {
    expect(scope.content).toBe("Hello, World!");
  });
});
