describe("Directive: unique", function() {
  var scope, form, input, fakeService, q;
  
  beforeEach(module("App"));
  
  beforeEach(inject(function($rootScope, $compile, uniqueValidationService, $q) {
    q = $q;
    scope = $rootScope.$new();
    
    var element = angular.element(
      "<form name='form' novalidate>" +
        "<input type='text' name='email'" +
          "ng-model='user.email'" +
          "unique='email'" +
          "url='/api/users/validate'>" +
      "</form>"
    );
    
    input = element.find("input");
    $compile(element)(scope);
    form = scope.form;
    
    fakeService = uniqueValidationService;
  }));
  
  it("should be valid when email doesn't exist", function() {
    spyOn(fakeService, "isUnique").and.callFake(function() {
      var d = q.defer();
      d.resolve(true);
      return d.promise;
    });
    
    form.email.$setViewValue("norin1@example.com");
    input.triggerHandler("blur");
    
    scope.$digest();
    expect(form.$invalid).toBe(false);
  });
  
  it("should be invalid when email exists", function() {
    spyOn(fakeService, "isUnique").and.callFake(function() {
      var d = q.defer();
      d.resolve(false);
      return d.promise;
    });
    
    form.email.$setViewValue("norin@example.com");
    input.triggerHandler("blur");
    
    scope.$digest();
    expect(form.$invalid).toBe(true);
  });
});
