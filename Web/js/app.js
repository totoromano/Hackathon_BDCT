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
    	var date = date.getDate().toString();
    	var year = date.getFullYear().toString();

    	var formattedDate = month.toString() + date + year;
    	return formattedDate;
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
	      var config = {'url': 'https://AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz:javascript-key=y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y@api.parse.com/1/classes/Trip/', 'method': 'GET', 'headers': {'X-Parse-Application-Id': 'AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz', 'X-Parse-REST-API-Key': 'u2WHb3eAIWcUylGDpdN1Koif5wtsGXOFBEMQrIfW'}};
	      var dayData = {};
	      var monthData = {};
	      var yearData = {};

	    $http(config).success(function(data) {
			for (var result in data.results) 
			{
				if (result['user'] == 'bgarb') {
					var dailySaving = calcDailySaving(result.distanceTraveled);
					var date = new Date(result.updatedAt);

					dayData[formatDate(date)] = dailySaving;

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
			}


		});

	      function calcDailySaving(distanceTraveled) {
	      	  var avgGasPrice = 2.5;
	      	  var avgMPG = 20;

	      	  return (distanceTraveled * avgGasPrice) / avgMPG;
	      }

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
          		data: data
          	};
	      }          

		  $scope.series = ['Money Saved'];
          
		  var dayChart = chartData(dayData);
          $scope.dayLabels = dayChart.labels;
          $scope.dayData = dayChart.data;
          
          var monthChart = chartData(monthData);
          $scope.monthLabels = monthChart.labels;
          $scope.monthData = monthChart.data;

          var yearChart = chartData(yearData);
          $scope.yearLabels = yearChart.labels;
          $scope.yearData = yearChart.data;

		  $scope.selector = 1;
		  $scope.periodSelector = 1;
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