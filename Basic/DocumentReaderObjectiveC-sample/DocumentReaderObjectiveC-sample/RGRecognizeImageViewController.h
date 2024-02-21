//
//  RGRecognizeImageViewController.h
//  DocumentReaderExample
//
//  Created by Dmitry Smolyakov on 7/20/20.
//  Copyright © 2020 Regula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGPreviewView.h"
@import DocumentReader;

typedef NS_ENUM(NSInteger, RGSessionSetupResult) {
    RGSessionSetupResultSuccess,
    RGSessionSetupResultNotAuthorized,
    RGSessionSetupResultConfigurationFailed
} NS_SWIFT_NAME(SessionSetupResult);

@class RGRecognizeImageViewController;

@protocol RGRecognizeImageViewController <NSObject>

- (void)recognizeDidFinishedWith:(RGLDocumentReaderResults * _Nullable)results
                  viewController:(RGRecognizeImageViewController * _Nonnull)viewController;

@end

@interface RGRecognizeImageViewController : UIViewController

@property(nonatomic, weak, nullable) id<RGRecognizeImageViewController> delegate;

@property(nonatomic, strong, nullable) NSString *selectedScenario;

@end

