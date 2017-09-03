//
//  AppDelegate.m
//  XiMaLaYa
//
//  Created by soulghost on 3/9/2017.
//  Copyright © 2017 soulghost. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

//用于保存快捷键事件回调的引用，以便于可以注销
static EventHandlerRef g_EventHandlerRef = NULL;
//用于保存快捷键注册的引用，便于可以注销该快捷键
static EventHotKeyRef a_HotKeyRef = NULL;
//快捷键注册使用的信息，用在回调中判断是哪个快捷键被触发
static EventHotKeyID a_HotKeyID = {'keyA',1};

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //先注册快捷键的事件回调
    EventTypeSpec eventSpecs[] = {{kEventClassKeyboard,kEventHotKeyPressed}};
    InstallApplicationEventHandler(NewEventHandlerUPP(myHotKeyHandler),
                                   GetEventTypeCount(eventSpecs),
                                   eventSpecs,
                                   NULL,
                                   &g_EventHandlerRef);
    //注册快捷键: option + a
    RegisterEventHotKey(kVK_ANSI_A,
                        optionKey,
                        a_HotKeyID,
                        GetApplicationEventTarget(),
                        0,
                        &a_HotKeyRef);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    //注销快捷键
    if (a_HotKeyRef)
    {
        UnregisterEventHotKey(a_HotKeyRef);
        a_HotKeyRef = NULL;
    }
    if (g_EventHandlerRef)
    {
        RemoveEventHandler(g_EventHandlerRef);
        g_EventHandlerRef = NULL;
    }
}

- (IBAction)onClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"play" object:nil];
}

//快捷键的回调方法
OSStatus myHotKeyHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData)
{
    //判定事件的类型是否与所注册的一致
    if (GetEventClass(inEvent) == kEventClassKeyboard && GetEventKind(inEvent) == kEventHotKeyPressed)
    {
        //获取快捷键信息，以判定是哪个快捷键被触发
        EventHotKeyID keyID;
        GetEventParameter(inEvent,
                          kEventParamDirectObject,
                          typeEventHotKeyID,
                          NULL,
                          sizeof(keyID),
                          NULL,
                          &keyID);
        if (keyID.id == a_HotKeyID.id) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"play" object:nil];
        }
    }
    return noErr;
}

@end
