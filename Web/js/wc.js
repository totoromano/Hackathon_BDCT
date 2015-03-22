Parse.initialize("AQxY526I5fcCPVkniY6ONnaBqU5qh1qDMqcOCORz", "y0cZ5QAGDU1SN1o1DtsQA8mHAKL3TKetrRvGwv3Y");
calculateSteps();

function calculateSteps(){
	var count = 0;
	var Trips = Parse.Object.extend("Trip");
	var query = new Parse.Query(Trips);
	 query.greaterThan("StepsCompleted", 0);
	query.find({
	  success: function(results) {
	    for (var i = 0; i < results.length; i++) { 
	      var object = results[i];
	      var stepsTaken = object.get("StepsCompleted");
	   	  count += stepsTaken;
	      document.getElementById('stepsContainer').innerHTML = count.toLocaleString();
	      var dollarsSaved = (count / 2000) * 2.5;
	      document.getElementById('moneyContainer').innerHTML = dollarsSaved.toFixed(2);
	      var co2Emissions = count * 0.0128;
	      document.getElementById('co2EmissionsContainer').innerHTML = co2Emissions.toFixed(2);
	    }
	   },
	  error: function(error) {
	    console.log("Error: " + error.code + " " + error.message);
	  }
	});	
	//var timer = setInterval(refresh, 3000);
}
var myVar = setInterval(function(){ refresh() }, 1000);

function refresh(){
	calculateSteps();
}