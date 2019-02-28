//
//  AppDelegate.h
//  MediaPlayer
//
//  Created by 위피아 on 28/02/2019.
//  Copyright © 2019 위피아. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

