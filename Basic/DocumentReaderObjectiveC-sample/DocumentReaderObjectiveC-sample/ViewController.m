//
//  ViewController.m
//  DocumentReaderObjectiveC-sample
//
//  Created by Dmitry Smolyakov on 3/19/18.
//  Copyright © 2018 Dmitry Smolyakov. All rights reserved.
//

#import "ViewController.h"
#import "RGRecognizeImageViewController.h"

@import DocumentReader;
@import Photos;

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, RGRecognizeImageViewController>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *documentImage;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *userRecognizeImage;
@property (weak, nonatomic) IBOutlet UIButton *useCameraViewControllerButton;
@property (weak, nonatomic) IBOutlet UIButton *customCamera;

@property (weak, nonatomic) IBOutlet UILabel *initializationLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) NSString *selectedScenario;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializationReader];
    self.imagePicker = [[UIImagePickerController alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initializationReader {
    //initialize license
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"regula.license" ofType:nil];
    NSData *licenseData = [NSData dataWithContentsOfFile:dataPath];

    self.initializationLabel.text = @"Initialization...";
    RGLConfig *config = [RGLConfig configWithLicenseData:licenseData];
    [RGLDocReader.shared initializeReaderWithConfig:config completion:^(BOOL successful, NSError * _Nullable error ) {
        if (successful) {
            [self.activityIndicator stopAnimating];
            [self.initializationLabel setHidden:YES];
            [self.userRecognizeImage setHidden:NO];
            [self.useCameraViewControllerButton setHidden:NO];
            [self.customCamera setHidden:NO];
            [self.pickerView setHidden:NO];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];

            RGLScenario *scenario = [RGLDocReader shared].availableScenarios.firstObject;
            if (scenario) {
                self.selectedScenario = scenario.identifier;
            }
            [RGLDocReader shared].functionality.singleResult = YES;

            for (RGLScenario *scenario in RGLDocReader.shared.availableScenarios) {
                NSLog(@"%@", scenario);
                NSLog(@"---------");
            }
        } else {
            [self.activityIndicator stopAnimating];
            self.initializationLabel.text = [NSString stringWithFormat:@"Initialization error: %@", error];
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)useCameraViewController:(UIButton *)sender {
    RGLScannerConfig *config = [[RGLScannerConfig alloc] initWithScenario:self.selectedScenario];
    
    [RGLDocReader.shared showScannerFromPresenter:self config:config completion:^(enum RGLDocReaderAction action, RGLDocumentReaderResults * _Nullable result, NSError * _Nullable error) {
        switch (action) {
            case RGLDocReaderActionCancel: {
                NSLog(@"Cancelled by user");
            }
            break;

            case RGLDocReaderActionProcessTimeout: {
                NSLog(@"Timeout");
                UILabel *timeoutLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
                timeoutLabel.text = @"Timeout!";
                timeoutLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
                timeoutLabel.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:timeoutLabel];
                [UIView animateWithDuration:2 animations:^{
                    timeoutLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    [timeoutLabel removeFromSuperview];
                    [self handleScanResults:result];
                }];                
            }
            break;
                
            case RGLDocReaderActionComplete: {
                NSLog(@"Completed");
                [self handleScanResults:result];
            }
            break;

            case RGLDocReaderActionError: {
                NSLog(@"Error string: %@", error);
            }
            break;

            case RGLDocReaderActionProcess: {
                NSLog(@"Scaning not finished. Result: %@", result);
            }
            break;

            default:
            break;
        }
    }];
}

- (IBAction)useRecognizeImageMethod:(UIButton *)sender {
    [self getImageFromGallery];
}

- (IBAction)actionCustomCamera:(UIButton *)sender {
    RGRecognizeImageViewController *vc = [[RGRecognizeImageViewController alloc] init];
    vc.selectedScenario = self.selectedScenario;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)getImageFromGallery {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized: {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imagePicker.delegate = self;
                        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        self.imagePicker.allowsEditing = NO;
                        self.imagePicker.navigationBar.tintColor = [UIColor blackColor];
                        [self presentViewController:self.imagePicker animated:YES completion:nil];
                    });
                }
            }
            break;

            case PHAuthorizationStatusDenied: {
                NSString *message = @"Application doesn't have permission to use the camera, please change privacy settings";
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Gallery Unavailable" message:message preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                                     options:@{}
                                           completionHandler:nil];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;

            case PHAuthorizationStatusNotDetermined: {
                NSLog(@"%@", @"PHPhotoLibrary status: notDetermined");
            }

            case PHAuthorizationStatusRestricted: {
                NSLog(@"%@", @"PHPhotoLibrary status: restricted");
            }

            default:
            break;
        }
    }];
}

- (void)handleScanResults:(RGLDocumentReaderResults *)result {
    // use fast getValue method
    NSString *name = [result getTextFieldValueByType:RGLFieldTypeFt_Surname_And_Given_Names];
    NSLog(@"%@", name);
    self.nameLabel.text = name;
    self.documentImage.image = [result getGraphicFieldImageByType:RGLGraphicFieldTypeGf_DocumentImage source:RGLResultTypeRawImage];
    self.portraitImageView.image = [result getGraphicFieldImageByType:RGLGraphicFieldTypeGf_Portrait];

    for (RGLDocumentReaderTextField *textField in result.textResult.fields) {
        NSString *value = [result getTextFieldValueByType:textField.fieldType lcid:textField.lcid];
        NSLog(@"Field type name: %@, value: %@", textField.fieldName, value);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{

        RGLRecognizeConfig *config = [[RGLRecognizeConfig alloc] initWithScenario:self.selectedScenario];
        config.image = image;

        [RGLDocReader.shared recognizeWithConfig:config completion:^(RGLDocReaderAction action, RGLDocumentReaderResults * _Nullable results, NSError * _Nullable error) {
            if (action == RGLDocReaderActionComplete) {
                if (results != nil) {
                    NSLog(@"Completed");
                    [self handleScanResults:results];
                }
            } else if (action == RGLDocReaderActionError) {
                [self dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"Something went wrong");
            }
        }];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return RGLDocReader.shared.availableScenarios.count;
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return RGLDocReader.shared.availableScenarios[row].identifier;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedScenario = RGLDocReader.shared.availableScenarios[row].identifier;
}

- (void)recognizeDidFinishedWith:(RGLDocumentReaderResults *)results viewController:(RGRecognizeImageViewController *)viewController {
    [self handleScanResults:results];
}

@end
