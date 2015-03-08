(function() {
	var app = angular.module('miawalk', ['chart.js']);
	//Parse.initialize("AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz", "y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y");
	var apiurl = 'https://AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz:javascript-key=y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y@api.parse.com/1/classes/';
	var applicationId = 'AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz';
	var restApiKey = 'u2WHb3eAIWcUylGDpdN1Koif5wtsGXOFBEMQrIfW';

	//var TestObject = Parse.Object.extend("TestObject");
	// var testObject = new TestObject();
	// testObject.save({foo: "bar2"}).then(function(object) {
	//   console.log(object);
	// });

	function monthName(index) {
      	switch (index) {
	    case 0:
	        month = "January";
	        break;
	    case 1:
	        month = "February";
	        break;
	    case 2:
	        month = "March";
	        break;
	    case 3:
	        month = "April";
	        break;
	    case 4:
	        month = "May";
	        break;
	    case 5:
	        month = "June";
	        break;
	    case 6:
	        month = "July";
	        break;
	    case 7:
	        month = "August";
	        break;
	    case 8:
	        month = "September";
	        break;
	    case 9:
	        month = "October";
	        break;
	    case 10:
	        month = "November";
	        break;
	    case 11:
	        month = "December";
	        break;
		};
		return month;			 
    };

    function formatDate(date) {
    	var month = date.getMonth() + 1;
    	var day = date.getDate().toString();
    	var year = date.getFullYear().toString();

    	var formattedDate = month.toString() + "/" + day + "/" + year;
    	return formattedDate;
    };

    function chartData(apiData) {
      	var labels = [];
      	var data = [];

      	for (var property in apiData) 
      	{
          if (apiData.hasOwnProperty(property)) {
          	labels.push(property);
          	data.push(apiData[property]);
          }
      	}

      	return {
      		labels: labels,
      		data: [data]
      	};
      };

	app.controller('DashboardSelectorController', function() {
		this.tab = 1;
		this.selectTab = function(setTab) {
			this.tab = setTab;
		};

		this.isSelected = function(checkTab) {
			return this.tab === checkTab;
		};
	});

	app.controller('MoneyController', function($scope, $http) {
	      var config = {'url': 'https://AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz:javascript-key=y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y@api.parse.com/1/classes/Trip/?where={"user":"tester"}', 'method': 'GET', 'headers': {'X-Parse-Application-Id': 'AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz', 'X-Parse-REST-API-Key': 'u2WHb3eAIWcUylGDpdN1Koif5wtsGXOFBEMQrIfW'}};
	      var dayData = {};
	      var monthData = {};
	      var yearData = {};

	  //     	$scope.labels = ["January", "February", "March", "April", "May", "June", "July"];
			// $scope.series = ['Series A'];
			// $scope.data = [[65, 59, 80, 81, 56, 55, 40]];

		  $scope.daySeries = ['Money Saved'];
	      $scope.dayLabels = ["3/7/2015", "3/8/2015"];
	      $scope.dayData = [[0.0125, 0.09]];

		  $scope.monthSeries = ['Money Saved'];
	      $scope.monthLabels = [];
          $scope.monthData = [[]];

		  $scope.yearSeries = ['Money Saved'];
          $scope.yearLabels = [];
          $scope.yearData = [[]];

	    $http(config).success(function(data) {
			for (var i = 0; i < data.results.length; i++) 
			{
				var result = data.results[i];
				var dailySaving = calcDailySaving(result.distanceTraveled);
				var date = new Date(result.updatedAt);
				var formattedDate = formatDate(date);
 
				if (dayData.hasOwnProperty(formattedDate)) {
					dayData[formattedDate] = dayData[formattedDate] + dailySaving;
				}
				else {
					dayData[formattedDate] = 0.0;
				}				

				var month = monthName(date.getMonth());
				if (monthData.hasOwnProperty(month)) {
					monthData[month] = monthData[month] + dailySaving;
				}
				else {
					monthData[month] = 0.0
				}

			    var year = date.getFullYear().toString();
			    if (yearData.hasOwnProperty(year)) {
			    	yearData[year] = yearData[year] + dailySaving;
			    }
			    else {
			    	yearData[year] = 0.0
			    }
			}
          
		    // var dayChart = chartData(dayData);
      //       $scope.dayLabels = dayChart.labels;
      //       $scope.dayData = dayChart.data;
          
            var monthChart = chartData(monthData);
            $scope.monthLabels = monthChart.labels;
            $scope.monthData = monthChart.data;

            var yearChart = chartData(yearData);
            $scope.yearLabels = yearChart.labels;
            $scope.yearData = yearChart.data;
		});

	      function calcDailySaving(distanceTraveled) {
	      	  var avgGasPrice = 2.5;
	      	  var avgMPG = 20;
	      	  var milesTraveled = distanceTraveled / 2000;

	      	  return (milesTraveled * avgGasPrice) / avgMPG;
	      }

	      

		  $scope.selector = 1;
		  $scope.periodSelector = 0;
	});

	app.controller('HeartController', function($scope) {
		//     	$scope.labels = ["January", "February", "March", "April", "May", "June", "July"];
			// $scope.series = ['Series A'];
			// $scope.data = [[65, 59, 80, 81, 56, 55, 40]];
		$scope.stepSeries = ['Series A'];
		$scope.stepLabels = ["3/1/2015", "3/2/2015", "3/3/2015", "3/4/2015", "3/5/2015", "3/6/2015", "3/7/2015", "3/8/2015"];
		$scope.stepData = [[19, 54, 37, 82, 92, 123, 174, 45]];
	});

	app.controller('TreeController', function($scope, $http) {
		var config = {'url': 'https://AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz:javascript-key=y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y@api.parse.com/1/classes/Trip/?where={"user":"tester"}', 'method': 'GET', 'headers': {'X-Parse-Application-Id': 'AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz', 'X-Parse-REST-API-Key': 'u2WHb3eAIWcUylGDpdN1Koif5wtsGXOFBEMQrIfW'}};
		var dayData = {};

		$scope.treeSeries = ['Series A'];
		$scope.treeLabels = ["3/7/2015", "3/8/2015"];
		$scope.treeData = [[0, 0]];

		$http(config).success(function(data) {
			for (var i = 0; i < data.results.length; i++) 
			{
				var result = data.results[i];
				var date = new Date(result.updatedAt);
				var CO2Saved = calcStepToEmissionSaved(result.StepsCompleted);
				var formattedDate = formatDate(date);
 
				if (dayData.hasOwnProperty(formattedDate)) {
					dayData[formattedDate] = dayData[formattedDate] + CO2Saved;
				}
				else {
					dayData[formattedDate] = 0.0;
				}	
			}

			var treeChart = chartData(dayData);
            //$scope.treeLabels = treeChart.labels;
            $scope.treeData = treeChart.data;
		});

		function calcStepToEmissionSaved(stepsCompleted) {
			return stepsCompleted * 0.0128; 
		}
	});

	app.controller('HistoryController', function($scope, $http) { 
		var config = {'url': 'https://AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz:javascript-key=y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y@api.parse.com/1/classes/Trip/?where={"user":"tester"}', 'method': 'GET', 'headers': {'X-Parse-Application-Id': 'AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz', 'X-Parse-REST-API-Key': 'u2WHb3eAIWcUylGDpdN1Koif5wtsGXOFBEMQrIfW'}};
	    $scope.records = [];
		$http(config).success(function(data) { 
			for (var i = 0; i < data.results.length; i++) 
			{
				var result = data.results[i];
				var tripNumber = i + 1;
				var record = {"trip": "Trip " + tripNumber, "steps": "Steps: " + result.StepsCompleted};
				$scope.records.push(record);
			}
		});
	});

	// app.controller('WalkController', function($http) {
	//     var walk = this;
	//     walk.products = [];

	//     var config = {'url': apiurl, 'method': 'GET', 'headers': {'X-Parse-Application-Id': 'AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz', 'X-Parse-REST-API-Key': 'u2WHb3eAIWcUylGDpdN1Koif5wtsGXOFBEMQrIfW'}}
	// 	$http(config).success(function(data) {
	// 		walk.products = data.results;
	// 	});
	// });
})();