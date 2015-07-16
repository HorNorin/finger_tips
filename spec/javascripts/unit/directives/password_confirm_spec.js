describe("passwordConfirm", function() {
  var scope, form;
  
  beforeEach(module("App"));
  
  beforeEach(inject(function($rootScope, $compile) {
    scope = $rootScope.$new();
    
    var element = "<form name='form' novalidate>" +
              "<input type='password' name='password' ng-model='user.password'>" +
              "<input type='password' name='passwordConfirm' ng-model='user.passwordConfirm' password-confirm='user.password'>" +
              "</form>";
    
    element = angular.element(element);
    scope.user = {};
    $compile(element)(scope);
    form = scope.form;
  }));
  
  it("should be valid when password match passwordConfirm", function() {
    form.password.$setViewValue("secret");
    form.passwordConfirm.$setViewValue("secret");
    scope.$digest();
    expect(form.$invalid).toBe(false);
  });
  
  it("should be invalid when password not match passwordConfirm", function() {
    form.password.$setViewValue("secret");
    form.passwordConfirm.$setViewValue("secret111");
    scope.$digest();
    expect(form.$invalid).toBe(true);
  });
});
