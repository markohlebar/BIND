//
//  MHModel.h
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MHModel <NSObject>
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
@end
