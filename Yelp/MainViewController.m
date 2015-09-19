//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessesTableViewCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <FiltersViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray* allBusinesses;
@property (nonatomic, strong) NSArray* businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredBusinesses;

- (void) fetchBusinessesWithQuery:(NSString*)query params:(NSDictionary*)params;

@end

@implementation MainViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.filteredBusinesses = [NSMutableArray array];
    
    [self.tableView registerNib: [UINib nibWithNibName:@"BusinessesTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessesTableViewCell"];
    
    self.title = @"Yelp";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 86;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessesTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"BusinessesTableViewCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

#pragma mark - Filter delegate methods
- (void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    //fire network event
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
    
    NSLog(@"Fire network event, %@", filters);
}

#pragma mark - private methods

- (void) onFilterButton {
    FiltersViewController *filterController = [[FiltersViewController alloc] init];
    UINavigationController *filterNavController = [[UINavigationController alloc] initWithRootViewController:filterController];
    
    filterController.delegate = self;
    
    [self presentViewController:filterNavController animated:YES completion:nil];
}

- (void) fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray* businessesDictionary = response[@"businesses"];
        
        self.businesses = [Business businessesWithDictionaries:businessesDictionary];
        
        self.allBusinesses = [NSArray arrayWithArray:self.businesses];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

#pragma mark - UISearchBarDelegate
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Search: %@", searchText);
    
    [self.filteredBusinesses removeAllObjects];
    
    if ([searchText isEqualToString:@""]) {
        self.businesses = [NSArray arrayWithArray:self.allBusinesses];
        [self.tableView reloadData];
        return;
    }
    
    for (Business* business in self.businesses) {
        if ([business.name containsString:searchText]  && ![self.filteredBusinesses containsObject:business]) {
            [self.filteredBusinesses addObject:business];
        }
    }
    
    self.businesses = [NSArray arrayWithArray:self.filteredBusinesses];
    
    [self.tableView reloadData];
    
    NSLog(@"Search bar changed: %@", self.filteredBusinesses);
    
    
}


@end
