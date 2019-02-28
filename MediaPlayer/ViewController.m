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

//가수이름으로 곡 찾기
-(void)quertArtist : (NSString *)artist {
    //초기화
    MPMediaQuery *artistQry = [[MPMediaQuery alloc]init];
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtist];
    [artistQry addFilterPredicate:artistNamePredicate];
    
    //null 체크
    for (MPMediaItem *item in [artistQry items]) {
        if (NULL == item) {
            NSLog(@"null 값이 존재합니다.");
            continue;
        }
        //정보 추출
        NSString *title = [item valueForKey:MPMediaItemPropertyTitle];
        NSURL  *url = [item valueForKey:MPMediaItemPropertyAssetURL];
        NSString *artist = [item valueForKey:MPMediaItemPropertyArtist];
        NSString *lyrics = [item valueForKey:MPMediaItemPropertyLyrics];
        MPMediaItemArtwork *artwork = [item valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize: CGSizeMake(200, 200)];
        
        NSLog(@"After search with sound: %@ with url %@ artist is %@", title, [item valueForKey:MPMediaItemPropertyAssetURL], [item valueForKey:MPMediaItemPropertyArtist]);
        
    }// forin -end
    
    
    _slctitems = [MPMediaItemCollection collectionWithItems:artistQry.items];
    [_previousBtn setEnabled:NO];
    //목록 업데이트
    [self updateList:_slctitems];
    [_appMusicPlayer setQueueWithItemCollection:_slctitems];
    
    
}


- (IBAction)onQuery:(id)sender {
     NSLog(@"%@", @"onQuery 버튼 작동");
    
    if (_artistaSearchBar.text == NULL || _artistaSearchBar.text.length == 0) {
        return;
    }
    
    //검색바의 텍스트를 쿼리아티스트 메소드에 넘겨줌
    [self quertArtist:_artistaSearchBar.text];
    
    
}

- (IBAction)onPrevious:(id)sender {
     NSLog(@"%@", @"onPrevious 버튼 클릭");
}




- (IBAction)onPlay:(id)sender {
    NSLog(@"%@", @"onPlay 버튼 클릭");
    NSLog(@"현재 재생되고 있는 노래 index : %lu", (unsigned long)_appMusicPlayer.indexOfNowPlayingItem);
    NSLog(@"queue에 존재하는 음악 목록 총 개수: %lu", (_slctitems.count));
    
    static BOOL isPlay = NO;
    if (NULL == _appMusicPlayer) {
         NSLog(@"%@", @"null이 존재합니다.");
        return;
    }
    

    
    /*
     //MPMusicPlayerController에 큐가 없을 경우 에러 발생
     2019-02-28 16:33:03.475540+0900 MediaPlayer[7370:1670897] [SDKPlayback] -[MPMusicPlayerController prepareToPlay] completed error: Error Domain=MPMusicPlayerControllerErrorDomain Code=1 "prepareToPlay without a queue" UserInfo={NSDebugDescription=prepareToPlay without a queue}
     */
    
    
    if (!isPlay) {
        isPlay = YES;
        [_playBtn setTitle:@"stop" forState:UIControlStateNormal];
        [_appMusicPlayer play];
    }else{
        isPlay = NO;
        [_playBtn setTitle:@"Play" forState:UIControlStateNormal];
        [_appMusicPlayer pause];
    }
    
}




- (IBAction)onNext:(id)sender {
     NSLog(@"%@", @"onNext 버튼 클릭");
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
