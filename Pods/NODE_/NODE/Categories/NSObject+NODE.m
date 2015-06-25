//
//  NSObject+NODE.m
//  NODE
//
//  Created by Marko Hlebar on 28/03/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import "NSObject+NODE.h"
#import <objc/runtime.h>

@implementation NSObject (NODE)

#pragma mark - Parent-Child operations

- (void)node_addChild:(id)node {
    if (![self.node_mutableChildren containsObject:node]) {
        [self.node_mutableChildren addObject:node];
        [node setNode_parent:self];
    }
}

- (void)node_addChildren:(NSArray *)nodes {
    [nodes enumerateObjectsUsingBlock:^(id node, NSUInteger idx, BOOL *stop) {
        [self node_addChild:node];
    }];
}

- (void)node_removeChild:(id)node {
    [self.node_mutableChildren removeObject:node];
    [node setNode_parent:nil];
}

- (void)node_removeAllChildren {
    [self.node_mutableChildren makeObjectsPerformSelector:@selector(setNode_parent:)
                                              withObject:nil];
    [self.node_mutableChildren removeAllObjects];
}

- (void)node_setMutableChildren:(NSMutableArray *)mutableChildren {
    objc_setAssociatedObject(self, @selector(node_mutableChildren), mutableChildren, OBJC_ASSOCIATION_RETAIN);
}

- (id)node_root {
    NSObject *parent = self;
    while (parent.node_parent) {
        parent = parent.node_parent;
    }
    return parent;
}

- (NSArray *)node_ancestors {
    NSMutableArray *ancestors = [NSMutableArray new];
    NSObject *parent = self;
    while (parent.node_parent) {
        [ancestors addObject:parent.node_parent];
        parent = parent.node_parent;
    }
    return ancestors.copy;
}

- (id)node_parent {
    return objc_getAssociatedObject(self, @selector(node_parent));
}

- (void)setNode_parent:(id)parent {
    @synchronized(self) {
        objc_setAssociatedObject(self, @selector(node_parent), parent, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (NSArray *)node_children {
    /**
     *  For performance reasons, node_children is simply returning the mutable children instead of a copy.
     */
    return self.node_mutableChildren;
}

#pragma mark - Index Paths

- (NSIndexPath *)node_indexPath {
    NSUInteger *indexes = self.node_createIndexes;
    NSUInteger length = self.node_ancestors.count + 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes
                                                        length:length];
    free(indexes);
    return indexPath;
}

- (id)node_nodeAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger indexes[indexPath.length];
    [indexPath getIndexes:indexes];

    NSObject *node = self.node_root;
    for (int i = 1; i < indexPath.length; i++) {
        NSUInteger index = indexes[i];
        node = node.node_children[index];
    }

    return node;
}

#pragma mark - Private

- (NSUInteger *)node_createIndexes {
    NSUInteger depth = self.node_ancestors.count + 1;
    NSUInteger *indexes = calloc(depth, sizeof(NSUInteger));

    __block NSObject *child = self;
    NSArray *ancestors = self.node_ancestors;
    [ancestors enumerateObjectsUsingBlock:^(NSObject *object, NSUInteger index, BOOL *stop) {
        NSUInteger childIndex = [object.node_children indexOfObject:child];
        child = object;
        indexes[ancestors.count - index] = childIndex;
    }];

    return indexes;
}

- (NSMutableArray *)node_mutableChildren {
    NSMutableArray *children = nil;
    @synchronized(self) {
        children = objc_getAssociatedObject(self, @selector(node_mutableChildren));
        if (!children) {
            children = [NSMutableArray new];
            [self node_setMutableChildren:children];
        }
    }
    return children;
}

#pragma mark - Logging

- (NSString *)node_debugDescription {
    NSMutableString *mutableDescription = [NSMutableString new];
    [mutableDescription appendFormat:@"%@\n", self.debugDescription];
    for (NSObject *node in self.node_children) {
        [mutableDescription appendFormat:@"%*c%@",  (int)node.node_ancestors.count * 4, ' ', node.node_debugDescription];
    }
    return mutableDescription.copy;
}

@end
