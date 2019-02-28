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
    _mpPickerVC = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    _mpPickerVC.prompt = @"음악을 선택해 주세요";
    _mpPickerVC.allowsPickingMultipleItems = YES;
    _mpPickerVC.showsCloudItems = YES;
    _mpPickerVC.delegate = self;
    _appMusicPlayer = [MPMusicPlayerController systemMusicPlayer];
}


//미디어 픽커에서 곡이 선택될때 - 업데이트
-(void)updateList:(MPMediaItemCollection *) collection {
    
    NSString *txt = @"";
    NSString *tag = @"";
    for (MPMediaItem *item in [collection items]) {
        if(NULL == item){
            NSLog(@"null이 존재합니다.");
            continue;
        }
        
        NSString *title = [item valueForKey:MPMediaItemPropertyTitle];
        NSString *artist = [item valueForKey:MPMediaItemPropertyArtist];
        txt = [NSString stringWithFormat:@"%@ %@ %@ - %@",txt,tag,title,artist];
        tag = @"\n";
    }
    
    _soundsTV.text = txt;
    
}


//미디어 픽커 선택
- (IBAction)onPick:(id)sender {
    NSLog(@"%@", @"onPick 작동");
    
//     _mpPickerVC = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
//    _mpPickerVC.prompt = @"음악을 선택해 주세요";
//    _mpPickerVC.allowsPickingMultipleItems = YES;
//    _mpPickerVC.showsCloudItems = YES;
//    _mpPickerVC.delegate = self;
    
    [self presentViewController:_mpPickerVC animated:YES completion:^{
       NSLog(@"%@", @"미디어 픽커 라이브러리를 선택했습니다.");
    }];
    
}

- (IBAction)onQuery:(id)sender {
     NSLog(@"%@", @"onQuery");
}

- (IBAction)onPrevious:(id)sender {
     NSLog(@"%@", @"onPrevious");
}
- (IBAction)onPlay:(id)sender {
     NSLog(@"%@", @"onPlay");
}
- (IBAction)onNext:(id)sender {
     NSLog(@"%@", @"onNext");
}






#pragma mark  MPMediaPickerControllerDelegate

//미디어 픽커 선택
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
     NSLog(@"%@", @"didPickMediaItems - 선택되었습니다.");
    
    //선택한 음원 개수
    NSLog(@"picked with %lu items", (unsigned long)[mediaItemCollection count]);
    
    //null 값 체크
    if (NULL == mediaItemCollection) {
        NSLog(@"mediaItemCollection이 null 입니다.");
        return;
    }
    
    //선택한 음원들 하나하나 null 값 체크
    for (MPMediaItem *item in [mediaItemCollection items]) {
        if (NULL == item) {
            NSLog(@"item이 null 입니다.");
            continue;
        }
        
        NSString *title = [item valueForKey:MPMediaItemPropertyTitle];
        NSString *url = [item valueForKey:MPMediaItemPropertyAssetURL];
        NSString *artist = [item valueForKey:MPMediaItemPropertyArtist];
        
        NSLog(@"title : %@" , title);
        NSLog(@"url : %@" , url);
        NSLog(@"artist : %@" , artist);
    } //for - end
    
    _slctitems = mediaItemCollection;
    [_appMusicPlayer setQueueWithItemCollection:_slctitems];
    [self updateList:_slctitems];
    [_previousBtn setEnabled:NO];
    [_mpPickerVC dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


//미디어 픽커 취소 델리게이트 메소드
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
     NSLog(@"%@", @"mediaPickerDidCancel -  취소클릭");
    [_mpPickerVC dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", @"mediaPickerDidCancel -  닫혔습니다.");
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
