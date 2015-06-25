# NODE
Create a tree from any objects

### Why? 
Sometimes it is useful to create tree like structures with your 
objects.
A simple example would be a relationship between sections and rows in a table
view. Let's say we have an object that represents the table view, 
and I would like to add some sections and rows. 
We could naively create 
a couple of arrays or dictionaries to store that structure, but wouldn't it be easier
if the structure is exactly represented as the tree we are trying to build? 

```
- TableView
  - Section[0] 
    - Row[0]
    - Row[1]
  - Section[1]
    - Row[2]
```

### How? 
Let's build that tree that we were mentioning in the `Why?` section. 
Say we have a `TableView`, `Section` and `Row` classes, all `PONSO`'s.
As mentioned in the title, `NODE` lets you build that structure from any ol' objects.
```
Row *row0 = [Row new]; 
Row *row1 = [Row new]; 
Section *section0 = [Section new]; 
[section0 node_addChildren:@[row0, row1]];

Row *row2 = [Row new];
Section *section1 = [Section new]; 
[section1 node_addChild:row2];

TableView *tableView = [TableView new];
[tableView node_addChildren:@[section0, section1]];
```

### Now what? 
OK, now that you have your tree what can you do with it? 
```
///Gets section0
Section *section = row0.node_parent;

///Gets an array @[row0, row1] 
NSArray *rows = section.node_children; 

///Gets the tableView object
TableView *tableView = [rows[0] node_root];

///Gets an array @[section0, tableView]
NSArray *ancestors = [rows[0] node_ancestors];

///Returns an index path of the row 
NSIndexPath *indexPath = [row[0] node_indexPath];

///Returns row0
Row *row = [section0 node_nodeAtIndexPath:indexPath];

///And last but not least, you can print out the tree
[tableView node_debugDescription];
```

### How does it work?
`NODE` is just a simple category on `NSObject`. 
When you call `node_addChild:` on any object, it creates two associated objects;
a `node_parent` is created on the object we are passing in the `node_addChild:` method, and 
a `node_mutableChildren` array is created on the caller. 

### Is it safe? 
That's up to you. This is a category on an `NSObject` adding associated objects, so it's 
as dangerous as it gets, but if you use it properly you should be fine. A prefix `node_` 
was added so that name collision risk with other libraries would be minimized, but you still
need to keep an eye on that. 

### Installation 

`pod 'NODE_'`

### Contributing
Pull requests, issues and comments are very welcome. 

### LICENSE
MIT, check LICENSE file. 
