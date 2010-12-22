// V 0.1 of Calendar - Private Beta
// Apache GPL v2 by S.Telford
// UI based off of code by TinyFool - http://iphonecal.googlecode.com/svn/trunk/ 

// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});

// load the module
var Calendar = require('com.ti.calendar');
// Print out the debug message if you are unsure
//Ti.API.info("module is => " + Calendar);

//var ev = Calendar.createItem({title:"Stefs Event", startDate: new Date()});
var evEndDate = new Date();
evEndDate.setHours(evEndDate.getHours()+3);
var ev = Calendar.createItem({title:"Stefs Event", startDate: new Date(), 
                              endDate: evEndDate, location: "Bob's WareHouse"});

// events are NOT saved, until you invoke the saveEvent on them. 
// Until that point, they live solely in memory.
var p = ev.saveEvent();
// Be sure to check the status for true/false on save.
//Ti.API.info(p);


// Now, let's do a search and print to debug the results
var startDate = new Date();
startDate.setHours(startDate.getHours()-1);
var endDate = new Date();
endDate.setHours(endDate.getHours()+1);

var o = Calendar.findEvents({ start: startDate, end: endDate });

// because we can only pass back a dictionary, we lose the sort order
// we have to do this to get it back
var keys = [];
for (key in o) {
   keys.push(key);
}
keys.sort();

for (key in keys) {
  Ti.API.info(o[keys[key]].title+" starts at "+o[keys[key]].startDate+" and has id of "+o[keys[key]].eventIdentifier);
}



// Here we will delete all the events
/*
for (key in keys) {
  var g = o[keys[key]].deleteEvent();
  Ti.API.info("Deleted : "+o[keys[key]].eventIdentifier);
}
*/



// create the calendar display
var foo = Calendar.createView({color:"lightgray", events: o,
    eventsSelected: function(e) 
    {
      for (key in e.events) {
        alert(e.events[key].title+" starts at "+e.events[key].startDate+" ends at "+e.events[key].endDate+" at the location "+e.events[key].location+" and has id of "+e.events[key].eventIdentifier);
      }
    }
});

// Display the Calendar Widget/View now.
window.add(foo);
window.open();