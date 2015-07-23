describe("Directive: commentArea", function() {
  var scope, comment, httpBackend;
  
  beforeEach(module("App"));
  
  beforeEach(inject(function($rootScope, $compile, $httpBackend, Comment) {
    scope = $rootScope.$new();
    comment = Comment;
    httpBackend = $httpBackend;
    
    $httpBackend.whenGET("/templates/directives/comment_area.html").respond(200);
    $httpBackend.whenGET("/api/comments?episode_id=1").respond(200, []);
    var element = '<comment-area logged-in="true" episode="1"></comment-area>'
    
    element = angular.element(element);
    $compile(element)(scope);
    $httpBackend.flush();
    scope = element.isolateScope();
  }));
  
  it("should defined isLoggedIn", function() {
    expect(scope.isLoggedIn).toBeDefined();
    expect(scope.isLoggedIn).toBeTruthy();
  });
  
  it("should defined episode", function() {
    expect(scope.episode).toBeDefined();
    expect(scope.episode).toEqual(1);
  });
  
  it("should defined comments", function() {
    expect(scope.comments).toBeDefined();
  });
  
  it("createComment should append comment to comments array when success", function() {
    httpBackend.whenPOST("/api/comments").respond(200, {body: "one comment"});
    
    scope.createComment();
    httpBackend.flush();
    expect(scope.comments.length).toBe(1);
    expect(scope.comments[0].body).toBe("one comment");
  });
  
  it("createComment should not append comment to comments array when failed", function() {
    httpBackend.whenPOST("/api/comments").respond(404);
    
    scope.createComment();
    httpBackend.flush();
    expect(scope.comments.length).toBe(0);
  });
});
