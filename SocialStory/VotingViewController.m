//
//  VotingViewController.m
//  SocialStory
//
//  Created by Ingrid Funie on 04/10/2014.
//  Copyright (c) 2014 Colibri Ltd. All rights reserved.
//

#import "VotingViewController.h"
#import "SuggestingViewController.h"
#import "AppDelegate.h"

@interface VotingViewController ()

@end

@implementation VotingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.votingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    
    [self.votingProgress setProgress:0.0 animated:NO];
    
     [self startCount];
        
    NSString* firebasePhaseURL = [NSString stringWithFormat:@"%@/%@/phase", kFirechatNSStories, self.storyID];
    
    self.firebasePhase = [[Firebase alloc] initWithUrl:firebasePhaseURL];
    
    [self.firebasePhase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot value %@", snapshot.value);
        
        self.phase = snapshot.value;
        
        [self.myTimer invalidate];
        self.myTimer = nil;
        
        if ([self.phase isEqualToString:@"SUGGEST"]) {
            SuggestingViewController *suggestingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuggestingViewController"];
            
            suggestingViewController.storyID = self.storyID;
            
            [self presentViewController:suggestingViewController animated:YES completion:nil];
        }
        
    }];

    [self.sixthWord setTitle:@"End." forState:UIControlStateNormal];
    
    NSString* storyURL = [NSString stringWithFormat:@"%@/%@/story", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:storyURL];
    
    [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        self.storyLine.text = snapshot.value;
        
    }];
    
    NSString* storyTitleURL = [NSString stringWithFormat:@"%@/%@/title", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:storyTitleURL];
    
    [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        self.storyTitle.text = snapshot.value;
        
    }];

    
    [self setWords];
    
    NSLog(@"words counter : %lu", (unsigned long)[self.words count]);
    
    
    
}



- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    NSLog(@"show main view");
    
    [self.votingProgress setProgress:0.0 animated:NO];
    
    [self startCount];
    
    NSString* firebasePhaseURL = [NSString stringWithFormat:@"%@/%@/phase", kFirechatNSStories, self.storyID];
    
    self.firebasePhase = [[Firebase alloc] initWithUrl:firebasePhaseURL];
    
    [self.firebasePhase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot value %@", snapshot.value);
        
        self.phase = snapshot.value;
        
        if ([self.phase isEqualToString:@"SUGGEST"]) {
            SuggestingViewController *suggestingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SuggestingViewController"];
            
            suggestingViewController.storyID = self.storyID;
            
            [self presentViewController:suggestingViewController animated:YES completion:nil];
        }
        
    }];
    
    [self.sixthWord setTitle:@"End." forState:UIControlStateNormal];

    
    NSString* storyURL = [NSString stringWithFormat:@"%@/%@/story", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:storyURL];
    
    [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        self.storyLine.text = snapshot.value;
        
    }];
    
    NSString* storyTitleURL = [NSString stringWithFormat:@"%@/%@/title", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:storyTitleURL];
    
    [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        self.storyTitle.text = snapshot.value;
        
    }];

    
    [self setWords];
   
    
    
}

-(void)setWords {
    
    NSString* firebaseWordsURL = [NSString stringWithFormat:@"%@/%@/words", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:firebaseWordsURL];
    
    // Initialize array that will store chat messages.
    self.words = nil;
     self.words = [[NSMutableArray alloc] init];
    
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
    
        if (![self.words containsObject:snapshot.name]) {
            [self.words addObject:snapshot.name];
        }
        
        NSLog(@"snapshot %@", snapshot.name);
        
        NSLog(@"words number: %lu", (unsigned long)[self.words count]);
        
        if ([self.words count] > 0 && [self.words count] < 2) {
            [self.firstWord setTitle:[self.words objectAtIndex:0] forState:UIControlStateNormal];
        } else if ([self.words count] > 1 && [self.words count] < 3) {
            [self.firstWord setTitle:[self.words objectAtIndex:0] forState:UIControlStateNormal];
            
            [self.secondWord setTitle:[self.words objectAtIndex:1] forState:UIControlStateNormal];
        } else if ([self.words count] > 2 && [self.words count] < 4) {
            [self.firstWord setTitle:[self.words objectAtIndex:0] forState:UIControlStateNormal];
            
            [self.secondWord setTitle:[self.words objectAtIndex:1] forState:UIControlStateNormal];
            
            [self.thirdWord setTitle:[self.words objectAtIndex:2] forState:UIControlStateNormal];
        } else if ([self.words count] > 3 && [self.words count] < 5) {
            [self.firstWord setTitle:[self.words objectAtIndex:0] forState:UIControlStateNormal];
            
            [self.secondWord setTitle:[self.words objectAtIndex:1] forState:UIControlStateNormal];
            
            [self.thirdWord setTitle:[self.words objectAtIndex:2] forState:UIControlStateNormal];
            
            [self.forthWord setTitle:[self.words objectAtIndex:3] forState:UIControlStateNormal];

        } else if ([self.words count] > 4 && [self.words count] < 6) {
            [self.firstWord setTitle:[self.words objectAtIndex:0] forState:UIControlStateNormal];
            
            [self.secondWord setTitle:[self.words objectAtIndex:1] forState:UIControlStateNormal];
            
            [self.thirdWord setTitle:[self.words objectAtIndex:2] forState:UIControlStateNormal];
            
            [self.forthWord setTitle:[self.words objectAtIndex:3] forState:UIControlStateNormal];
            
            [self.fifthWord setTitle:[self.words objectAtIndex:4] forState:UIControlStateNormal];

        }
      
        
    }];

    
}

- (void)startCount
{
    
     NSString* firebaseVoteTime = [NSString stringWithFormat:@"%@/%@/voteTime", kFirechatNSStories, self.storyID];
    
    NSString* firebasePhaseStartedTime = [NSString stringWithFormat:@"%@/%@/phaseStarted", kFirechatNSStories, self.storyID];
    
    self.firebasePhase = [[Firebase alloc] initWithUrl:firebaseVoteTime];
    
    [self.firebasePhase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"voteTime value %@", snapshot.value);
        
        self.voteTime = snapshot.value; //string
        
    }];
    
    self.firebasePhase = [[Firebase alloc] initWithUrl:firebasePhaseStartedTime];
    
    [self.firebasePhase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"phaseStarted value %@", snapshot.value);
        
        self.phaseStartedTime = snapshot.value; //string
        
    }];
    
    
    double time = [[NSDate date] timeIntervalSince1970]*1000;
    
    double phaseTime = [self.phaseStartedTime doubleValue];
    
    double remainingTime = (time - phaseTime);
    
    NSLog(@"time: %f, phaseTime: %f, remaining time : %f", time, phaseTime, remainingTime);
    
    double roundTime = ([self.voteTime doubleValue] - remainingTime);
    
    NSLog(@"remaining time : %f, roundTime in double: %f, roundTime :%i", remainingTime, roundTime, (int)roundTime);
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:(int)roundTime target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
}

- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=10)
    {
        NSLog(@"%i", count);
        
        [self.votingProgress setProgress:(float)count/10.0f animated:YES];
        
        //self.votingProgress.progress = (float)count/10.0f;
    } else
    {
        
        [self.myTimer invalidate];
        self.myTimer = nil;
        
    } 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)vote1:(id)sender {
    
    NSString* firebaseVotesURL = [NSString stringWithFormat:@"%@/%@/votes", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:firebaseVotesURL];
    
    [[self.firebase childByAppendingPath:@"/ingrid"] setValue: self.firstWord.titleLabel.text];
    
    NSLog(@"voted %@", self.firstWord.titleLabel.text);
}

- (IBAction)vote2:(id)sender {
   NSString* firebaseVotesURL = [NSString stringWithFormat:@"%@/%@/votes", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:firebaseVotesURL];
    [[self.firebase childByAppendingPath:@"/ingrid"] setValue: self.secondWord.titleLabel.text];
    
    NSLog(@"voted %@", self.secondWord.titleLabel.text);
  

}

- (IBAction)vote3:(id)sender {
   NSString* firebaseVotesURL = [NSString stringWithFormat:@"%@/%@/votes", kFirechatNSStories, self.storyID];
    self.firebase = [[Firebase alloc] initWithUrl:firebaseVotesURL];
    [[self.firebase childByAppendingPath:@"/ingrid"] setValue: self.thirdWord.titleLabel.text];
    
    NSLog(@"voted %@", self.thirdWord.titleLabel.text);
    
   }

- (IBAction)vote4:(id)sender {
    NSString* firebaseVotesURL = [NSString stringWithFormat:@"%@/%@/votes", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:firebaseVotesURL];
    [[self.firebase childByAppendingPath:@"/ingrid"] setValue: self.forthWord.titleLabel.text];
    
    NSLog(@"voted %@", self.forthWord.titleLabel.text);
   

}

- (IBAction)vote5:(id)sender {
    NSString* firebaseVotesURL = [NSString stringWithFormat:@"%@/%@/votes", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:firebaseVotesURL];
    [[self.firebase childByAppendingPath:@"/ingrid"] setValue: self.fifthWord.titleLabel.text];
    
    NSLog(@"voted %@", self.fifthWord.titleLabel.text);
  
}

- (IBAction)vote6:(id)sender {
    NSString* firebaseVotesURL = [NSString stringWithFormat:@"%@/%@/votes", kFirechatNSStories, self.storyID];
    
    self.firebase = [[Firebase alloc] initWithUrl:firebaseVotesURL];
    [[self.firebase childByAppendingPath:@"/ingrid"] setValue: self.sixthWord.titleLabel.text];
    
    NSLog(@"voted %@", self.sixthWord.titleLabel.text);

}

- (IBAction)goBackToMainView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)shareStory:(id)sender {
    NSString *textToShare = [NSString stringWithFormat:@"Looking forward to meet you at %@",self.storyTitle.text];
    
    NSArray *activityItems = [[NSArray alloc]  initWithObjects:textToShare, nil];
    
    UIActivity *activity = [[UIActivity alloc] init];
    NSArray *applicationActivities = [[NSArray alloc] initWithObjects:activity, nil];
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
@end
