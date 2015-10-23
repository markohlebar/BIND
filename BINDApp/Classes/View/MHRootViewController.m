//
//  ViewController.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHRootViewController.h"
#import "MHPersonSectionsDataController.h"

@interface MHRootViewController ()
@property (nonatomic, strong, readonly) NSArray *controllerNames;
@end

@implementation MHRootViewController
@synthesize controllerNames = _controllerNames;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)controllerNames {
    if (!_controllerNames) {
        _controllerNames = @[
                             @"Table View",
                             @"Section Table View"
                             ];
    }
    return _controllerNames;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.controllerNames[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controllerNames.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"MHTableViewControllerSegue"
                              sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    id <BNDDataController> dataController = [self dataControllerForIndexPath:indexPath];
    id <BNDViewController> viewController = segue.destinationViewController;
    viewController.dataController = dataController;
}

- (id <BNDDataController> )dataControllerForIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return [MHPersonDataController new];
            break;
        case 1:
            return [MHPersonSectionsDataController new];
            break;
        default:
            break;
    }
    return nil;
}

@end
