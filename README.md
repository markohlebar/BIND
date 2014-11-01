BIND
====

 [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

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

## BIND DSL ##

Bind offers a special [DSL](http://en.wikipedia.org/wiki/Domain-specific_language) to build your bindings. 
You can use it either from code or from XIB-s. The language describes which keypaths are assigned from each binding,

### Examples ###

Let's say you are building a table view based app and you want to show names of different persons in the cells. 
Assume that the `PersonViewModel` **view model** has a property `name` which you want to display on you **cell's** `textLabel`. 
What you need to do is bind the cell's `textLabel.text` key path with the `name` key path of your **view model**. 

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

- (void)updateWithViewModel:(id)viewModel {
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

## TBC ##
- XIBS EXAMPLES (look at https://github.com/markohlebar/iOSArchitectures for now)
- more abstract classes like viewcontrollers, views etc. 
- universal library and CocoaPods
