//
//  SuggestingViewController.m
//  SocialStory
//
//  Created by Ingrid Funie on 04/10/2014.
//  Copyright (c) 2014 Colibri Ltd. All rights reserved.
//

#import "SuggestingViewController.h"
#import "VotingViewController.h"
#import "AppDelegate.h"


@interface SuggestingViewController ()

@end

@implementation SuggestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.firebasePhase = [[Firebase alloc] initWithUrl:kFirechatNSPhase];
    
    [self.firebasePhase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        self.phase = snapshot.value;
        
        if ([self.phase isEqualToString:@"vote"]) {
            VotingViewController *votingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VotingViewController"];
            
            [self presentViewController:votingViewController animated:YES completion:nil];
        }
        
    }];
    
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNSStory];
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot value %@", snapshot.value);
        
        self.storyLine.text = snapshot.value;
        
    }];

    
   // [self.suggestingProgress setProgress:0.0 animated:NO];
    
    //[self startCount];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    NSLog(@"show suggestions view");
    
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNSStory];
    
    NSLog(@"showing story...");
    
    [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot value %@", snapshot.value);
        
        self.storyLine.text = snapshot.value;
        
    }];
    
    self.firebasePhase = [[Firebase alloc] initWithUrl:kFirechatNSPhase];
    
    [self.firebasePhase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot value %@", snapshot.value);
        
        self.phase = snapshot.value;
        
        if ([self.phase isEqualToString:@"vote"]) {
            VotingViewController *votingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VotingViewController"];
            
            [self presentViewController:votingViewController animated:YES completion:nil];
        }
        
    }];
    
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNSStory];
    
    NSLog(@"showing story...");
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot value %@", snapshot.value);
        
        self.storyLine.text = snapshot.value;
        
    }];

    
    
   // [self.suggestingProgress setProgress:0.0 animated:NO];
    
   // [self startCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCount
{
    self.myOtherTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
}

- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=10)
    {
        NSLog(@"suggesting count %i", count);
        
        [self.suggestingProgress setProgress:(float)count/10.0f animated:YES];
        
        //self.votingProgress.progress = (float)count/10.0f;
    } else
    {
        
        [self.myOtherTimer invalidate];
        self.myOtherTimer = nil;
        
       /* MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        
        [self presentViewController:mainViewController animated:YES completion:nil];*/
        
       // [self performSegueWithIdentifier:@"MainViewController" sender:self];
        
       /* [self addChildViewController:mainViewController];
        [self.view addSubview:mainViewController.view];
        [mainViewController didMoveToParentViewController:self];*/
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)suggestWord:(id)sender {
    
    NSString *word = self.suggestingWord.text;
    
    //add the user here
    
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNSSugestions];
    
    [[self.firebase childByAppendingPath:[NSString stringWithFormat:@"/%@", @"ingrid"]] setValue: word];
    
    NSLog(@"suggested %@", word);
    
}
@end
