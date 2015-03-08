(function() {
	var app = angular.module('miawalk', ['chart.js']);
	Parse.initialize("AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz", "y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y");
	var apiurl = 'https://AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz:javascript-key=y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y@api.parse.com/1/classes/TestObject/';

	var TestObject = Parse.Object.extend("TestObject");
	// var testObject = new TestObject();
	// testObject.save({foo: "bar2"}).then(function(object) {
	//   console.log(object);
	// });

	app.controller('DashboardSelectorController', function() {
		this.tab = 1;
		this.selectTab = function(setTab) {
			this.tab = setTab;
		};

		this.isSelected = function(checkTab) {
			return this.tab === checkTab;
		};
	});

	app.controller('MoneyController', function($scope) {
          var apiData = {"January": 20.00, "February": 10.00, "March": 2.00};
          var labels = [];
          var data = [];

          for (var property in apiData) 
          {
              if (apiData.hasOwnProperty(property)) {
              	labels.push(property);
              	data.push(apiData[property]);
              }
          }

          $scope.labels = labels;
          $scope.series = ['Money Saved'];
          $scope.data = [data];

		  $scope.selector = 1;
	});

	app.controller('WalkController', function($http) {
	    var walk = this;
	    walk.products = [];

	    var config = {'url': apiurl, 'method': 'GET', 'headers': {'X-Parse-Application-Id': 'AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz', 'X-Parse-REST-API-Key': 'u2WHb3eAIWcUylGDpdN1Koif5wtsGXOFBEMQrIfW'}}
		$http(config).success(function(data) {
			walk.products = data.results;
		});
	});
})();