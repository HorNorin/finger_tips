describe("Controllers: EpisodesController", function() {
  var scope, shared, episode, controller, httpBackend;
  
  beforeEach(module("App"));
  
  beforeEach(inject(function($rootScope, $compile, $controller, $httpBackend, sharedScope, Episode) {
    scope = $rootScope.$new();
    shared = sharedScope;
    episode = Episode;
    httpBackend = $httpBackend;
    
    var element = angular.element("<input name='title' ng-model='object.title'>");
    $compile(element)(scope);
    
    controller = $controller("EpisodesController", {
      $scope: scope,
      sharedScope: sharedScope,
      Episode: Episode
    });
    
    httpBackend.whenGET("/api/episodes").respond(200, {episodes: [1,2,3,4]});
  }));
  
  it("should have defined object", function() {
    scope.$digest();
    
    expect(scope.object).toBeDefined();
    expect(scope.object).toEqual(shared.data);
  });
  
  it("should have defined goto function", function() {
    scope.$digest();
    
    expect(scope.goto).toBeDefined();
  });
  
  it("should query list of episodes", function() {
    scope.$digest();
    httpBackend.flush();
    
    expect(scope.object.paginate).toBeDefined();
    expect(scope.object.paginate.episodes).toBeDefined();
  });
  
  it("goto function should call Episode.index when first load", function() {
    spyOn(episode, "index");
    spyOn(episode, "search");
    
    scope.goto(2);
    scope.$digest();
    httpBackend.flush();
    
    expect(episode.index).toHaveBeenCalled();
    expect(episode.search).not.toHaveBeenCalled();
  });
  
  it("goto function should call Episode.search when in search mod", function() {
    spyOn(episode, "index");
    spyOn(episode, "search");
    
    scope.object.searchMode = true;
    scope.goto(2);
    scope.$digest();
    httpBackend.flush();
    
    expect(episode.search).toHaveBeenCalled();
    expect(episode.index).not.toHaveBeenCalled();
  });
});
