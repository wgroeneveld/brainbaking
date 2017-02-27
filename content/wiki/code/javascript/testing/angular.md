+++
title = "angular"
draft = false
tags = [
    "code",
    "javascript",
    "testing",
    "angular"
]
date = "2013-06-05"
+++
# AngularJS testing 

Voorbeeld voor angular app met mocks en testing en al: [angular-seed](https://github.com/angular/angular-seed)

### Mocking en zo 

Zie [angular.mock.module](http://docs.angularjs.org/api/angular.mock.module) - twee hoofdfuncties die belangrijk zijn: `module()` en `inject()`. Het eerste maakt de module aan en het tweede zorgt voor de mock dependency injectie. Bijvoorbeeld:

```javascript
angular
	.module('bla.services', [])
	
	.factory('$bla', ['$http', function($http) {
            // do stuff with $http, like a .get
            return { go: function() {} }
        }])
;
```

Je kan dus met `$bla.go()` een http call uitvoeren waarbij `$bla` een geïnjecteerde variabele kan zijn in een Angular controller. Je kan met [$httpBackend](http://docs.angularjs.org/api/ngMock.$httpBackend) een `$http` mock injecteren:

```javascript
describe("bla service test", function() {
  var $http, $inject;
  beforeEach(module('bla.services'));
  beforeEach(inject(function($injector) {
    $inject = $injector;
    $http = $injector.get('$httpBackend');
    $http.when('GET', 'rest/bla').respond({ 'obj': 1 });
  });
  
  it("should test stuff", function() {
    var $bla = $inject.get('$bla'); // at this moment, service function evaluates
    expect($bla.go().obj).toEqual(1);
  });
});
```

#### eigen mocks in het dependency systeem van angularjs steken 

```javascript
var myMock;
beforeEach(function() {
  myMock = function() { return { toMock: function() {} } };
  module('app.services', function($provide) {
    $provide.value('myMock', myMock);
  });
  
  // if you want, you can now use inject() to for instance mock $http
  it("should bla", inject(function($injector) {
    var App = $inject.get('App');
    // expect(); in here
  }));
});
```