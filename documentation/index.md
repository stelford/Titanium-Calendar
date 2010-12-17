# ticalendar Module

## Description

The Calendar and Event module allows you to display a Calendar, along with
create, search and destroy events from the iphone's calendar. 

## Accessing the ticalendar Module

To access this module from JavaScript, you would do the following:

	var ticalendar = require("com.ti.calendar");

The ticalendar variable is a reference to the Module object.	

## Reference

### Com.Ti.Calendar.createItem

This is the function that is called to create a new event. Currently, only
title and startDate are accepted. The events default to a duration of 20
minutes. The item is in MEMORY only at this point, to save it into the 
iphone's calendar, you will need to call saveEvent()

Ex: var ev = Calendar.createItem({title:"Stefs Event", startDate: new Date()});

### Com.Ti.Calendar.saveEvent

Invoking this function on a previously created calendar event will save it.
A dictionary will be passed back, with status and any error message if 
appropriate.

Ex: var p = ev.saveEvent();

### Com.Ti.Calendar.findEvents

Calling this function, and passing in a start and end date will return a 
dictionary of event items from the calendar (upto 9999). 

Ex: var o = Calendar.findEvents({ start: startDate, end: endDate });

### Com.Ti.Calendar.deleteEvent();

This will cause the event to be deleted from the iphone's calendar. A
dictionary will be passed back, with status and any error message.

Ex: var g = ev.deleteEvent();

### Com.Ti.Calendar.createView();

This will display the calendar widget/view. This is not required for
any of the other functions to work. It currently can take a color for
background, a dictionary of events (from the findEvents call), and 
you can also register a callback function for whenever a date is clicked.
In the case of a date being clicked that has events, a structure similiar
to findEvents will be passed back.

Ex: var foo = Calendar.createView({color:"lightgray", events: o,
        eventsSelected: function(e) {
              for (key in e.events) {
                  alert(e.events[key].title+" starts at "+e.events[key].startDate+" and has id of "+e.events[key].eventIdentifier);
              }
        }
    });


## Author

Author: Stef Telford
Email: stef@ummon.com
Irc: zodiak on freenode.net

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0
