describe("Directive: email", function() {
  var scope, form;
  
  beforeEach(module("App"));
  
  beforeEach(inject(function($rootScope, $compile) {
    scope = $rootScope.$new();
    
    var element = "<form name='form' novalidate>" +
              "<input type='text' name='email' ng-model='user.email' email>" +
              "</form>";
    
    element = angular.element(element);
    scope.user = {};
    $compile(element)(scope);
    form = scope.form;
  }));
  
  it("should be valid when in correct format", function() {
    form.email.$setViewValue("norin@example.com");
    scope.$digest();
    expect(form.$invalid).toBe(false);
  });
  
  it("should be invalid when not in correct format", function() {
    form.email.$setViewValue("norin@example");
    scope.$digest();
    expect(form.$invalid).toBe(true);
  });
});
