BIND
====

 [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

Lightweight MVVM framework for iOS

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
    _binding.BIND = @"textLabel.text <- name";
    ...
}

- (void)updateWithViewModel:(id)viewModel {
    [_binding bindObject:self otherObject:viewModel];
}
    
@end
``` 

#### Initial value assignment ####
Observe the symbol `<-` in the expression `textLabel.text <- name`. 
**BIND** syntax lets you configure the way that the initial assignment of the value at key path is executed.
Supported symbols are

```
  textLabel.text <- name /// name is initally assigned to textLabel.text
  textLabel.text -> name /// textLabel.text is initally assigned to name
  textLabel.text <> name /// no values are initially assigned
```

#### Transformers ####
**BIND** also lets you assign your own subclasses of `NSValueTransformer` to transform values coming from object
to other object and reverse. Let's take the previous example, and assume that there is a requirement that the names should be displayed capitalized in the cells. You could then build your subclass of `NSValueTransformer` and easily assign it to the binding.

```
@interface CapitalizeStringTransformer : NSValueTransformer
@end

@implementation CapitalizeStringTransformer 

///transformValue: is called when assigning from object to otherObject
- (NSString *)transformValue:(NSString *)string {
    return string;
}

///reverseTransformValue: is called when assigning from otherObject to object
- (NSString *)reverseTransformValue:(NSString *)string {
    return string.capitalizedString; 
}

@end 

...
- (instancetype)init {
    ...
    _binding = [BNDBinding new];
    _binding.BIND = @"textLabel.text <- name | CapitalizeStringTransformer";
    ...
}
...

```
Observe that `| CapitalizeStringTransformer` syntax which tells the binding to use the `CapitalizeStringTransformer` subclass of `NSValueTransformer` to transform the values. 

## TBC ##
- XIBS EXAMPLES (look at https://github.com/markohlebar/iOSArchitectures for now)
- Transformer direction is somewhat confusing, perhaps introduce something like this 
```
@"textLabel.text <- name | CapitalizeStringTransformer" ///transformValue: is called coming from otherObject to object
@"CapitalizeStringTransformer | textLabel.text <- name" ///transformValue: is called coming from object to otherObject
```
- more abstract classes like viewcontrollers, views etc. 


