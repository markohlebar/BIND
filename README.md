BIND
====

 [![Pod](http://img.shields.io/badge/pod-1.0.3-lightgrey.svg)](http://cocoapods.org/)
 [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
 [![Build Status](https://travis-ci.org/markohlebar/BIND.svg?branch=master)](https://travis-ci.org/markohlebar/BIND)

Data binding and MVVM for iOS

## History ##

This library emerged from my exploration of [different architectures](https://github.com/markohlebar/iOSArchitectures) for iOS apps. 
It draws some ideas from other similar projects like 
 - [KJSimpleBinding](https://github.com/kristopherjohnson/KJSimpleBinding)
 - [KeyPathBindings](https://github.com/dewind/KeyPathBindings)
 - [objc-simple-bindings](https://github.com/mruegenberg/objc-simple-bindings)

with a couple of major feature advantages.

## Features ##

- **data binding** from **XIBs** or **code** by using a custom **BIND DSL**
- **data transforms** by using subclasses of `NSValueTransformer`
- **protocols** and **abstract classes** to make your **MVVM**-ing easier
- **lightweight** (200ish lines of code)

## Why Use This? ##

Because your `View` implementation code will literally start looking like this:
```
@implementation MyTableViewCell
@end
```
That's one of the reasons anyways... 

## Integration ##
#### CocoaPods ####
- pod 'BIND'
- `#import "BIND.h"`

## BIND DSL ##

Bind offers a special [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) to build your bindings. 
You can use it either from code or from XIB-s. The language describes which keypaths are assigned from each binding,

### Examples ###

Let's say you are building a table view based app and you want to show names of different persons in the cells. 
Assume that the `PersonViewModel` **view model** has a property `name` which you want to display on you **cell's** `textLabel`. 

#### Binding From XIB ####

**BIND** lets you create your bindings from XIBs. The easiest way to do this is to use 
the `BNDTableViewCell` class or create it's subclass. `BNDTableViewCell` exposes an interface
for assigning the `viewModel`, which should happen on each `tableView:cellForRowAtIndexPath:` call, 
and `bindings` which is a xib collection outlet of bindings which will be updated with each subsequent `viewModel` assignment.

![](https://raw.githubusercontent.com/markohlebar/BIND/master/misc/bind_from_xib.gif)

In the gif above you can observe a simple procedure of adding a binding to a cell which is a subclass of `BNDTableViewCell`. The steps are as follows: 
- create an empty XIB and name it the same as your `BNDTableViewCell` subclass
- from Objects Library drag in a `Table View Cell` and change it's class to subclass you created.
- next, from Objects Library drag in an `Object` and change it's class to `BNDBinding`
- add a keypath, change it's "Type" to `String`, "Key Path" to `BIND`, and type a BIND expression as the "Value" (In the example above I'm connecting my viewmodel's `name` keypath to `textLabel.text` of the cell)
- right click on your table view cell and find the Outlet Collection called `bindings`
- connect the previously created Binding with the outlet collection. 
- in your table view delegate's 'tableView:cellForRowAtIndexPath:' you should set the `viewModel` property of the cell with your view model

#### Binding From Code ####

Similar to the binding from XIB example, what you need to do is bind the cell's `textLabel.text` key path with the `name` key path of your **view model**. 

```
@implementation PersonTableViewCell {
    BNDBinding *_binding;
}

- (instancetype)init {
    ...
    _binding = [BNDBinding new];
    _binding.BIND = @"name -> textLabel.text";
    ...
}

- (void)setViewModel:(id)viewModel {
    _viewModel = viewModel;
    [_binding bindLeft:viewModel withRight:self];
}
    
@end
``` 

#### Binding Direction ####
Observe the symbol `->` in the expression `name -> textLabel.text`. 
**BIND** syntax lets you configure the way that the binding is reflected on the bound objects values. 
It offers three different direction configurations:
```
  name -> textLabel.text /// changes on name reflect on textLabel.text, but not the other way around
  name <- textLabel.text /// changes on textLabel.text reflect on name, but not the other way around
  name <> textLabel.text /// changes on name reflect on textLabel.text and vice versa. 
```

#### Initial Value Assignment ####
Initial values are assigned by default. The direction of assignment is from left to right object 
in cases the binding directions are either `->` or `<>`,
and from right to left object when binding direction is `<-`.
You can disable initial value assignment by using `bindLeft:withRight:setInitialValues:` method. 


#### Transformers ####
**BIND** also lets you assign your own subclasses of `NSValueTransformer` to transform values coming from object
to other object and reverse. Let's take the previous example, and assume that there is a requirement that the names should be displayed capitalized in the cells. You could then build your subclass of `NSValueTransformer` and easily assign it to the binding.

```
@interface CapitalizeStringTransformer : NSValueTransformer
@end

@implementation CapitalizeStringTransformer 

///transformValue: is called when assigning from object to otherObject
- (NSString *)transformValue:(NSString *)string {
    return string.capitalizedString; 
}

///reverseTransformValue: is called when assigning from otherObject to object
- (NSString *)reverseTransformValue:(NSString *)string {
    return string;
}

@end 

...
- (instancetype)init {
    ...
    _binding = [BNDBinding new];
    _binding.BIND = @"name -> textLabel.text | CapitalizeStringTransformer";
    ...
}
...

```
Observe `| CapitalizeStringTransformer` syntax which tells the binding to use the `CapitalizeStringTransformer` subclass of `NSValueTransformer` to transform the values. 
You can reverse the transformation direction if you need to by adding a `!` modifier before transformer name like so `name -> textLabel.text | !CapitalizeStringTransformer`.

## Memory Management ##

**BIND** is built on `KVO`, so the rules for observing an object apply here as well. Each `BNDBinding` object holds weak references to 2 assigned objects, namely `leftObject` and `rightObject`. If any of those objects gets deallocated before you `unbind` the binding, an exception will occur `"NSInternalInconsistencyException", "An instance 0xF00B400 of class XYZ was deallocated while key value observers were still registered with it.` Therefore, keep that in mind while managing the objects you bind. Best practice would be to destroy the binding before bound objects get destroyed. You can also call `unbind` to destroy the references to bound objects. 

```
//Exception 
BNDBinding *binding = [BNDBinding new];
NSObject *leftObject = [NSObject new];
[binding bindLeft:leftObject withRight:...];
leftObject = nil; ///This will throw an exception. 

//All good
[binding bindLeft:leftObject withRight:...];
binding = nil;    ///OR [binding unbind];
leftObject = nil; ///Cool
```

## Sample Project ##

Check [iOSArchitectures project](https://github.com/markohlebar/iOSArchitectures).

## TBC ##
- more abstract classes like viewcontrollers, views etc. 
