//
//  FiltersViewController.m
//  Yelp
//
//  Created by Jagtej Sodhi on 9/18/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (nonatomic, readonly) NSDictionary* filters;
@property (weak, nonatomic) IBOutlet UITableView *filtersTableView;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *distances;

@property (strong, nonatomic) NSMutableSet *selectedCategories;

- (void) initCategories;

@end

@implementation FiltersViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.filtersTableView.dataSource = self;
    self.filtersTableView.delegate = self;
    
    [self.filtersTableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil]
                forCellReuseIdentifier:@"SwitchCell"];
    
    [self.filtersTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private methods
- (NSDictionary *) filters {
    NSMutableDictionary* filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary* category in self.selectedCategories) {
            [names addObject:category];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    return filters;
}

- (void) onCancelButton {
    [self.delegate filtersViewController:self didChangeFilters:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) initCategories {
//    self.categories = @[@"afghani", @"african", @"newamerican", @"arabian", @"argentine", @"armenian",
//                        @"asianfusion", @"asturian", @"australian", @"bangladeshi", @"bbq", @"brazilian",
//                        @"breakfast_brunch", @"buffets", @"burgers", @"cafes", @"chinese", @"delis"];
    
    self.categories = @[@"afghani", @"african", @"newamerican"];
    self.distances = @[@"0.5 miles", @"1 mile", @"5 miles", @"10 miles"];

}

#pragma mark - table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.categories.count;
    }
    else if (section == 1) {
        return self.distances.count;
    }
    
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell* switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    
    if (indexPath.section == 0) {
        switchCell.titleLabel.text = self.categories[indexPath.row];
        switchCell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    }
    else if (indexPath.section == 1) {
        switchCell.titleLabel.text = self.distances[indexPath.row];
        switchCell.on = NO;
    }
    
    switchCell.delegate = self;
    
    return switchCell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sectionHeaders = [NSArray arrayWithObjects:@"Categories", @"Distance", @"Deals", @"Sort By", nil];
    
    return sectionHeaders[section];
}


#pragma mark - Switch cell delegate method
- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.filtersTableView indexPathForCell:cell];
    
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    }
    else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

@end
