//
//  ViewController.m
//  MVVM
//
//  Created by Marko Hlebar on 25/10/2014.
//  Copyright (c) 2014 Marko Hlebar. All rights reserved.
//

#import "MHRootViewController.h"
#import "MHPersonListViewController.h"
#import "MHPersonListViewModel.h"
#import "MHPersonCreator.h"

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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController = nil;
    switch (indexPath.row) {
        case 0:
            viewController = [self personListViewController];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (MHPersonListViewController *)personListViewController {
    MHPersonListViewController *viewController = [[MHPersonListViewController alloc] initWithNibName:nil bundle:nil];
    MHPersonCreator *creator = [MHPersonCreator new];
    viewController.viewModel = [MHPersonListViewModel viewModelWithModel:creator];
    return viewController;
}

@end
