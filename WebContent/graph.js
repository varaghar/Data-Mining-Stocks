$("#graph").on('click',function(){
	var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width = 600 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

    var w = 500;
    var h = 300;
    var padding = 50;
    
	var parseDate = d3.time.format("%Y%m%d").parse;
	
	var x = d3.time.scale()
	    .range([0, width]);
	
	var y = d3.scale.linear()
	    .range([height, 0]);
	
	var xAxis = d3.svg.axis()
	    .scale(x)
	    .orient("bottom");
	
	var yAxis = d3.svg.axis()
	    .scale(y)
	    .orient("left");

	var $cells = $(".similar");
    
	$.each($cells,function() {
		var $this = $(this);
		var data = JSON.parse($this.attr("data-graph"));
		var svg = d3.select("body").append("svg")
	    .attr("width", width + margin.left + margin.right)
	    .attr("height", height + margin.top + margin.bottom)
	    .append("g")
	    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
		
		for(var attr in data) {
		//Add line for each attribute 
			data[attr].forEach(function(d) {
			    d.date = parseDate(d.date); 
			});
		
			 var line = d3.svg.line()
			    .x(function(d) { return x(d.date); })
			    .y(function(d) { return y(d.value); });	
				
			  x.domain(d3.extent(data[attr], function(d) { return d.date; }));
			  y.domain(d3.extent(data[attr], function(d) { return d.value; }));
			
			  svg.append("g")
			      .attr("class", "x axis")
			      .attr("transform", "translate(0," + height + ")")
			      .call(xAxis);
			
			  svg.append("g")
			      .attr("class", "y axis")
			      .call(yAxis)
			    .append("text")
			      .attr("transform", "rotate(-90)")
			      .attr("y", 6)
			      .attr("dy", ".71em")
			      .style("text-anchor", "end");
			
			  svg.append("path")
			      .datum(data[attr])
			      .attr("class", attr)
			      .attr("d", line);
			  
		}
		
		//Add title to graph
		svg.append("text")
        .attr("x", (width / 2))             
        .attr("y", 5 - (margin.top / 2))
        .attr("text-anchor", "middle")  
        .style("font-size", "16px") 
        .style("text-decoration", "underline")  
        .text($this.text());
		
		//Add legend to graph

	});

	
	
});