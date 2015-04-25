//
//  BNDParser.m
//  BIND
//
//  Created by Marko Hlebar on 22/11/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "BNDParser.h"
#import "BNDMacros.h"

static NSString *const BNDBindingArrowLeftToRight = @"~>";
static NSString *const BNDBindingArrowRightToLeft = @"<~";
static NSString *const BNDBindingArrowBidirectional = @"<>";
static NSString *const BNDBindingArrowLeftToRightNoIntialisation = @"!~>";
static NSString *const BNDBindingArrowRightToLeftNoIntialisation = @"<~!";
static NSString *const BNDBindingArrowBidirectionalNoIntialisation = @"<!>";

static NSString *const BNDBindingTransformerSeparator = @"|";
static NSString *const BNDBindingTransformerDirectionModifier = @"!";

#pragma mark - DEPRECATED OPERATORS
static NSString *const BNDBindingArrowLeftToRight_DEPRECATED = @"->";
static NSString *const BNDBindingArrowRightToLeft_DEPRECATED = @"<-";
static NSString *const BNDBindingArrowLeftToRightNoIntialisation_DEPRECATED = @"!->";
static NSString *const BNDBindingArrowRightToLeftNoIntialisation_DEPRECATED = @"<-!";

@implementation BNDBindingModel

@end

@implementation BNDParser

+ (BNDBindingModel *)parseBIND:(NSString *)BIND {
	NSString *bind = [BIND stringByReplacingOccurrencesOfString:@" "
	                                                 withString:@""];
	bind = [bind stringByReplacingOccurrencesOfString:@"\n"
	                                       withString:@""];

	NSString *separator = nil;
	BNDBindingModel *definition = [BNDBindingModel new];

	if ([bind rangeOfString:BNDBindingArrowLeftToRightNoIntialisation].location != NSNotFound) {
		separator = BNDBindingArrowLeftToRightNoIntialisation;
		definition.shouldSetInitialValues = NO;
		definition.direction = BNDBindingDirectionLeftToRight;
        definition.transformDirection = BNDBindingTransformDirectionLeftToRight;
	}
    else if ([bind rangeOfString:BNDBindingArrowLeftToRightNoIntialisation_DEPRECATED].location != NSNotFound) {
        BNDLogDeprecated(BNDBindingArrowLeftToRightNoIntialisation_DEPRECATED, BNDBindingArrowLeftToRightNoIntialisation);
        
        separator = BNDBindingArrowLeftToRightNoIntialisation_DEPRECATED;
        definition.shouldSetInitialValues = NO;
        definition.direction = BNDBindingDirectionLeftToRight;
        definition.transformDirection = BNDBindingTransformDirectionLeftToRight;
    }
	else if ([bind rangeOfString:BNDBindingArrowRightToLeftNoIntialisation].location != NSNotFound) {
		separator = BNDBindingArrowRightToLeftNoIntialisation;
		definition.shouldSetInitialValues = NO;
		definition.direction = BNDBindingDirectionRightToLeft;
        definition.transformDirection = BNDBindingTransformDirectionRightToLeft;
	}
    else if ([bind rangeOfString:BNDBindingArrowRightToLeftNoIntialisation_DEPRECATED].location != NSNotFound) {
        BNDLogDeprecated(BNDBindingArrowRightToLeftNoIntialisation_DEPRECATED, BNDBindingArrowRightToLeftNoIntialisation);

        separator = BNDBindingArrowRightToLeftNoIntialisation_DEPRECATED;
        definition.shouldSetInitialValues = NO;
        definition.direction = BNDBindingDirectionRightToLeft;
        definition.transformDirection = BNDBindingTransformDirectionRightToLeft;
    }
	else if ([bind rangeOfString:BNDBindingArrowBidirectionalNoIntialisation].location != NSNotFound) {
		separator = BNDBindingArrowBidirectionalNoIntialisation;
		definition.shouldSetInitialValues = NO;
		definition.direction = BNDBindingDirectionBoth;
        definition.transformDirection = BNDBindingTransformDirectionLeftToRight;
	}
	else if ([bind rangeOfString:BNDBindingArrowLeftToRight].location != NSNotFound) {
		separator = BNDBindingArrowLeftToRight;
		definition.shouldSetInitialValues = YES;
		definition.direction = BNDBindingDirectionLeftToRight;
        definition.transformDirection = BNDBindingTransformDirectionLeftToRight;
	}
    else if ([bind rangeOfString:BNDBindingArrowLeftToRight_DEPRECATED].location != NSNotFound) {
        BNDLogDeprecated(BNDBindingArrowLeftToRight_DEPRECATED, BNDBindingArrowLeftToRight);

        separator = BNDBindingArrowLeftToRight_DEPRECATED;
        definition.shouldSetInitialValues = YES;
        definition.direction = BNDBindingDirectionLeftToRight;
        definition.transformDirection = BNDBindingTransformDirectionLeftToRight;
    }
	else if ([bind rangeOfString:BNDBindingArrowRightToLeft].location != NSNotFound) {
		separator = BNDBindingArrowRightToLeft;
		definition.shouldSetInitialValues = YES;
		definition.direction = BNDBindingDirectionRightToLeft;
        definition.transformDirection = BNDBindingTransformDirectionRightToLeft;
	}
    else if ([bind rangeOfString:BNDBindingArrowRightToLeft_DEPRECATED].location != NSNotFound) {
        BNDLogDeprecated(BNDBindingArrowRightToLeft_DEPRECATED, BNDBindingArrowRightToLeft);

        separator = BNDBindingArrowRightToLeft_DEPRECATED;
        definition.shouldSetInitialValues = YES;
        definition.direction = BNDBindingDirectionRightToLeft;
        definition.transformDirection = BNDBindingTransformDirectionRightToLeft;
    }
	else if ([bind rangeOfString:BNDBindingArrowBidirectional].location != NSNotFound) {
		separator = BNDBindingArrowBidirectional;
		definition.shouldSetInitialValues = YES;
		definition.direction = BNDBindingDirectionBoth;
        definition.transformDirection = BNDBindingTransformDirectionLeftToRight;
	}
	else {
		NSAssert(NO, @"Couldn't find initial assignment direction. Check the BIND syntax manual for more info.");
	}
    
    definition.operator = separator;

	NSArray *keyPaths = [bind componentsSeparatedByString:separator];
	NSAssert(keyPaths.count == 2, @"Couldn't find keyPaths. Check the BIND syntax manual for more info.");

	NSArray *keyPathAndTransformer = [keyPaths[1] componentsSeparatedByString:BNDBindingTransformerSeparator];
	definition.leftKeyPath = keyPaths[0];
	definition.rightKeyPath = keyPathAndTransformer[0];

	NSAssert(definition.leftKeyPath.length > 0, @"Provide a valid keyPath. Check the BIND syntax manual for more info.");
	NSAssert(definition.rightKeyPath.length > 0, @"Provide a valid otherKeyPath. Check the BIND syntax manual for more info.");

	[self parseTransformer:keyPathAndTransformer
	         forDefinition:definition];

	return definition;
}

+ (void)parseTransformer:(NSArray *)keyPathAndTransformer
           forDefinition:(BNDBindingModel *)definition {
	if (keyPathAndTransformer.count == 2) {
		NSString *modifierAndTransformer = keyPathAndTransformer[1];
		NSString *transformerClassName = nil;
		NSRange modifierRange = [modifierAndTransformer rangeOfString:BNDBindingTransformerDirectionModifier];
		if (modifierRange.location != NSNotFound) {
			transformerClassName = [modifierAndTransformer stringByReplacingCharactersInRange:modifierRange
			                                                                       withString:@""];
			definition.transformDirection = !definition.transformDirection;
		}
		else {
			transformerClassName = modifierAndTransformer;
		}

		definition.valueTransformer = [NSValueTransformer valueTransformerForName:transformerClassName];

		if (!definition.valueTransformer) {
			Class transformerClass = NSClassFromString(transformerClassName);
			definition.valueTransformer = [transformerClass new];
            
            [NSValueTransformer setValueTransformer:definition.valueTransformer
                                            forName:transformerClassName];
		}

		NSAssert1(definition.valueTransformer != nil, @"Non existing transformer class %@", transformerClassName);
	}
	else {
		definition.valueTransformer = [NSValueTransformer new];
	}
}

@end
