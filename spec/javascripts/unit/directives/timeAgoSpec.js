describe("Directive: timeAgo", function() {
  var scope, interval, counter = 0;
  
  beforeEach(module("App"));
  
  beforeEach(function() {
    module(function($provide) {
      $provide.value("timeagoFilter", function(value) {
        return counter++;
      });
    })
  })
  
  beforeEach(inject(function($rootScope, $compile, $interval) {
    scope = $rootScope.$new();
    interval = $interval;
    
    var element = '<span time-ago="' + counter + '"></span>';
    element = angular.element(element);
    $compile(element)(scope);
    
    scope = element.isolateScope();
  }));
  
  it("should defined timeago", function() {
    expect(scope.timeago).toBeDefined();
    expect(scope.timeago).toBe(0);
  });
  
  it("should update timeago every one minute", function() {
    scope.$digest();
    expect(scope.timeago).toBe(1);
    
    interval.flush(1000 * 60);
    expect(scope.timeago).toBe(2);
    
    interval.flush(1000 * 60);
    expect(scope.timeago).toBe(3);
  });
});
