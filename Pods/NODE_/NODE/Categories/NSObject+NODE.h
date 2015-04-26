//
//  NSObject+NODE.h
//  NODE
//
//  Created by Marko Hlebar on 28/03/2015.
//  Copyright (c) 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NODE)

/**
 *  A weak reference to a parent.
 */
@property (nonatomic, weak, readonly) id node_parent;

/**
 *  An array of node's children.
 */
@property (strong, readonly) NSArray *node_children;

/**
 *  Adds a child node.
 *
 *  @param node a node.
 */
- (void)node_addChild:(id)node;

/**
 *  Adds an array of child node.
 *
 *  @param node a node.
 */
- (void)node_addChildren:(NSArray *)nodes;

/**
 *  Removes a child node.
 *
 *  @param node a node.
 */
- (void)node_removeChild:(id)node;

/**
 *  Removes all children.
 */
- (void)node_removeAllChildren;

/**
 *  Returns the root of the tree.
 *  @discussion returns self if node is the root node.
 *
 *  @return a node or nil.
 */
- (id)node_root;

/**
 *  Returns an array of ancestors starting from parent going to root.
 *  @discussion returns an empty array if there are no ancestors.
 *
 *  @return an array.
 */
- (NSArray *)node_ancestors;

/**
 *  Returns an index path to the node, starting from root.
 *
 *  @return an index path.
 */
- (NSIndexPath *)node_indexPath;

/**
 *  Traverses the tree from root, and finds the child at wanted index path.
 *
 *  @param indexPath an indexPath
 *
 *  @return a node.
 */
- (id)node_nodeAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Outputs a debug description of the node with all it's children.
 *
 *  @return a description string.
 */
- (NSString *)node_debugDescription;

@end
