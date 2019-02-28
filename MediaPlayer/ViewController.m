//
//  ViewController.m
//  MediaPlayer
//
//  Created by 위피아 on 28/02/2019.
//  Copyright © 2019 위피아. All rights reserved.


//MediaPlayer 임포트!
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"

@interface ViewController ()

@property (strong,nonatomic) MPMediaPickerController *mpPickerVC;                       //픽커 컨트롤러
@property (strong,nonatomic) MPMediaItemCollection *slctitems;                              //선택된 아이템
@property (strong,nonatomic) MPMusicPlayerController *appMusicPlayer;               //플레이어


@property (weak, nonatomic) IBOutlet UITextField *artistaSearchBar;
@property (weak, nonatomic) IBOutlet UITextView *soundsTV;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}




- (IBAction)onPick:(id)sender {
}

- (IBAction)onQuery:(id)sender {
}

- (IBAction)onPrevious:(id)sender {
}
- (IBAction)onPlay:(id)sender {
}
- (IBAction)onNext:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
