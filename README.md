# Installation

Put your OpenWeatherAPI AppID in the Info.plist, in the `OpenWeatherAPPID` Key


# Architecture

![Clean architecture approach](Doc/AppArchitecturePrinciples.png)

# Dependencies

Every arrows in the graph describe a dependency from one object to another.
All of them are defined by an abstraction protocol, so the object pointed could be replaced by any other one respecting the same protocol.  This allows :
- Easy mocking for unit testing
- Changing the implementation details without changing the caller (So for ex: Changing a Storage Worker from UserDefault to SQLite) 

# Dependency inversion

Protocols are defined on the side where they are used : Object requiring a service defines what it needs from others, by a serie of protocols definitions. When one day, you'll want to separate your project in many independant swift module frameworks, you would be able to practice dependency inversion : The module implementing the service will import the module where it is declared. The import is done in counter-intuitive way : The dependency is inversed. By doing this, the modules are really cloisonated. You could even rebuild one without having to rebuild the other, as far as the protocols defining the service are unchanged. This is a really cumfortable situation : rebuilds could become really quick !

Dependency inversion is a fabulous idea, but it adds a bit more abstraction to be made properly. The question is : How to transmit object implementing protocol to object requiring it, since the requirer doesn't even know the module where the concrete implementation resides ? There must be a mediator for that and it's called an Abstract Factory.

Abstract Factory is a Factory, it builds object for others.
An Abstract Factory builds object but hide the real type of them behind an abstraction : returned types are protocols.

Now if we put such an Abstract Factory in a dedicated module that import concrete types (to be hiden behind Factory method protocol returned types), then this Factory module is importable by the requirer. The result is that the requirer use an object without even having access to is real concrete type because it declared in a module that is not even import by the requirer. This is magical stuff 

The Requirer object could


# Separation of responsibilities

The clear separation between UIKiT-Dependant / UIKit-Indepenpant objects leaves ViewControllers and Routers to be the only ones allowed to ìmport `UIKit`. This rule should insurred by carefull code reviews. The purpose of this constraint is to allow same interactors and workers to run on other platforms (iPads, watches, tvs) without any modifications. 
Interactor is the App Logic, tt should not depends on display issue.

In Many books, a Presenter object is also included. It's role is transforming datas given by the interactor, next to be presented by the view layer (by producing a viewModel structure). The presenter should also be on the UIKit agnostic side, and since it is so tighly coupled with his interactor outputs, it seems ok i think, at least temporarly, to fusionate Presenter in Interactor to have one object with both responsibilities (But i keep the notion of ViewModel structure as a way to transmit datas to View layer.

