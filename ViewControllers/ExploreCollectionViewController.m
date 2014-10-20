//
//  ExploreCollectionViewController.m
//  Marble
//
//  Created by Iru on 10/16/14.
//  Copyright (c) 2014 Orrzs Inc. All rights reserved.
//

#import "ExploreCollectionViewController.h"
#import "ExploreCollectionViewCell.h"
#import "User+MBUser.h"
#import "ProfileViewController.h"

@interface ExploreCollectionViewController()
@property (strong, nonatomic) UITextField *searchTextField;
@property(strong, nonatomic) NSMutableArray *searchResults;
//@property (nonatomic) BOOL isLoadingMore;
@end

@implementation ExploreCollectionViewController

-(void) viewDidLoad{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[ExploreCollectionViewCell class] forCellWithReuseIdentifier:exploreCollectionViewCellIdentifier];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, LEFT_ALIGNMENT, 0, LEFT_ALIGNMENT)];
    [self.collectionView setFrame:CGRectMake(0, 50, 320, self.view.frame.size.height - 50)];
    [self setNavbarTitle];
    [self initSearchTextField];
    [self initSearchResults];
    
//    _isLoadingMore = FALSE;
}

-(void)viewDidAppear:(BOOL)animated{
    [_searchTextField resignFirstResponder];
}


-(void) initSearchResults{
    _searchResults = nil;
    NSArray *results;
    [User getRandomUsersThisMany:-1 // -1 means no limit
                     inThisArray:&results inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext existingUsers:nil];
    for(User * user in results){
        NSLog(@"%@", user.name);
    }
    _searchResults = [NSMutableArray arrayWithArray:results];

    [self.collectionView reloadData];
}


-(void) reInitSearchResults:(NSArray *)results{
//    _isLoadingMore = FALSE;
    
    _searchResults = [NSMutableArray arrayWithArray:results];
    [self.collectionView reloadData];
}


//#TODO: loading more is called more often than thought. Maybe check duplication here too.
//-(void) addSearchResults:(NSArray *)results{
//    if (_isLoadingMore) {
//        [_searchResults addObjectsFromArray:results];
//        [self.collectionView reloadData];
//        _isLoadingMore = FALSE;
//    }
//}

-(void) initSearchTextField{
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_ALIGNMENT, 12, self.view.frame.size.width - 2*LEFT_ALIGNMENT, 26)];
    [_searchTextField setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    _searchTextField.delegate = self;
    
    [_searchTextField addTarget:self
                          action:@selector(textFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_searchTextField];
}

-(void) setNavbarTitle{
    UINavigationBar *myNavBar =[self.navigationController navigationBar];
    [myNavBar setTitleTextAttributes:[Utility getNavigationBarTitleFontDictionary]];
    [[myNavBar topItem] setTitle:@"Explore"];
    [myNavBar setTranslucent:NO];
    [myNavBar setBarTintColor:[UIColor marbleOrange]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    [[self.navigationController navigationBar] setBackgroundColor:[UIColor marbleOrange]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_searchResults count];
    NSLog(@"there are %d elements", [_searchResults count]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ExploreCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:exploreCollectionViewCellIdentifier forIndexPath:indexPath];
    
    User *user = [_searchResults objectAtIndex:indexPath.row];
    [cell setCellUser:user];
    NSLog(@"%@", user.name);
    [cell setBackgroundColor:[UIColor grayColor]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 2*LEFT_ALIGNMENT)/2.0, (self.view.frame.size.width - 2*LEFT_ALIGNMENT)/2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    User *user = [_searchResults objectAtIndex:indexPath.row];
    [self gotoProfileWithName:user.name andID:user.fbID];
}

-(void) gotoProfileWithName:(NSString *)name andID:(NSString *)fbid{
    [_searchTextField resignFirstResponder];
    NSArray *infoBundle = [NSArray arrayWithObjects:name,fbid, nil];
    [self performSegueWithIdentifier:@"ProfileViewControllerSegue" sender:infoBundle];
}

#pragma mark -
#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


-(void)textFieldDidChange :(UITextField *)textField{
    MBDebug(@"text changed %@", [textField text]);
//    _isLoadingMore = FALSE;
//    [self.collectionView setContentOffset:CGPointZero animated:NO];

    NSArray *arrayOfUsers;
    [User searchUserThatContains:[textField text]
             returnThisManyUsers:-1 // -1 means no limit on number of returned users
                     inThisArray:&arrayOfUsers
          inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
                   existingUsers:nil];
    [self reInitSearchResults:arrayOfUsers];
}

//-(void)startLoadingMore{
//    _isLoadingMore = TRUE;
//    NSArray *arrayOfUsers;
//    MBDebug(@"start leading more");
//    [User searchUserThatContains:[_searchTextField text]
//             returnThisManyUsers:10
//                     inThisArray:&arrayOfUsers
//          inManagedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext
//                   existingUsers:_searchResults];
//    if([arrayOfUsers count] == 0){
//        _isLoadingMore = false;
//        return;
//    }
//    [self addSearchResults:arrayOfUsers];
//}


#pragma mark -
#pragma mark UIScrollView Delegate Methods

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentSize.height < scrollView.frame.size.height) return;
//    
//    if(!_isLoadingMore) {
//    
//        CGFloat height = scrollView.frame.size.height;
//        
//        CGFloat contentYoffset = scrollView.contentOffset.y;
//        
//        CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
//        
//        //TODO: grab more data from server
//        if(distanceFromBottom < height)
//        {
//            [self startLoadingMore];
//            //[self.tableView reloadData];
//        }
//    }
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @" "
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue destinationViewController] isKindOfClass:[ProfileViewController class]]){
        if([sender isKindOfClass:[NSArray class]]){
            ProfileViewController *viewController =[segue destinationViewController];
            [viewController setName:(NSString *)[sender firstObject] andID:[sender objectAtIndex:1] sentFromTabbar:NO];
        }
    }
}

                
@end
