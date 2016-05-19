Tolo
====

To&middot;lo | t&#333;  - l&#333; | <br>
_adverb_ <br>
Amharic for "hurry up"

----

Tolo is an event publish/subscribe framework inspired by Otto and designed to decouple different parts of your iOS application while still allowing them to communicate efficiently. Traditional ways of subscribing for and triggering notifications are both cumbersome and error prone with minimal compile time checking.

For latest usage instructions please see <a href="http://genzeb.github.io/tolo">the website</a>.

Tolo is intended for use as a singleton (though that is not required). The macros utilized in the examples below use the shared instance Tolo.sharedInstance. The use of these macros is optional, but it's highly recommended that you do use them.

### PUBLISHING

Event publishing is straightforward using the macro PUBLISH(). This allows you to tell subscribers an action has occurred. An instance of any class may be published an event and it will only be dispatched to subscribers of that type.

To publish an event, create an instance of the event you wish to publish (for example: EventProgressUpdated) and use the macro PUBLISH() as follows:

	PUBLISH(event);

where event is an instance of the event (for example: EventProgressUpdated *event = ...).

### SUBSCRIBING

Subscription is the complement to event publishing—-it lets you receive notification that an event has occurred. To subscribe to an event, use the macro SUBSCRIBE() passing in the event type you wish to subscribe to as follows:

	SUBSCRIBE(EventProgressUpdated)
 	{
 		// use the variable event -- for example: self.progressView.progress = event.progress
 	}

In order to receive events, a class instance needs to register with Tolo. To register, simply use the macro REGISTER() passing in an instance of the class:

	REGISTER(self);

### PRODUCING

When subscribing to events it is often desired to also fetch the current known value for specific events (e.g., current location, active user, etc.). To address this common paradigm, Tolo adds the concept of 'Producers' which provide an immediate callback to any subscribers upon their registration.

To create a producer, use the macro PUBLISHER():


 	PUBLISHER(EventProgressUpdated)
 	{
 		return instance-of-EventProgressUpdated;
 	}

Producers, like subscribers, must also be registered:

	REGISTER(self);

When registering, the producer method will be called only once for any number of subscriber previously registered for the same type. However, the producer method will also be called once for each new method that subscribes to an event of the same type.

You may only have one producer per event type registered at a time -- the last producer to subscribe is used.

### THREAD ENFORCEMENT

Since at times it may be ambiguous on which thread you are receiving callbacks, Tolo provides an enforcement mechanism to ensure you are always called on the main thread. By default, all interaction with an instance is confined to the main thread (this can be changes using the public property Tolo.forceMainThread -- YES by default).

----

INSTALLATION
----

There are three easy ways of installing Tolo:

* Use cocoapods like: `pod 'tolo', '~>1.0'`
* Drag-and-drop the files Tolo.h and Tolo.m into your project and import Tolo.h as needed, or
* Drag-and-drop the project file, Tolo.xcodeproj, into your project and add it as Target Dependencies in your project's Build Phases setting

