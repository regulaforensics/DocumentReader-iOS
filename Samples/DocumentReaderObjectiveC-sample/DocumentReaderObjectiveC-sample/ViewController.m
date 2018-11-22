//
//  ViewController.m
//  DocumentReaderObjectiveC-sample
//
//  Created by Dmitry Smolyakov on 3/19/18.
//  Copyright © 2018 Dmitry Smolyakov. All rights reserved.
//

#import "ViewController.h"
@import DocumentReader;
@import Photos;

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

    @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *documentImage;
    @property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
    @property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
    @property (weak, nonatomic) IBOutlet UIButton *userRecognizeImage;
    @property (weak, nonatomic) IBOutlet UIButton *useCameraViewControllerButton;

    @property (weak, nonatomic) IBOutlet UILabel *initializationLabel;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

    @property (strong, nonatomic) DocReader *docReader;

    @property (strong, nonatomic) UIImagePickerController *imagePicker;

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

        ProcessParams *params = [[ProcessParams alloc] init];
        DocReader *docReader = [[DocReader alloc] initWithProcessParams:params];
        
        [docReader prepareDatabaseWithDatabaseID:@"Full" progressHandler:^(NSProgress * _Nonnull progress) {
            self.initializationLabel.text = [NSString stringWithFormat:@"%.1f", progress.fractionCompleted * 100];
        } completion:^(BOOL successful, NSString * _Nullable error) {
            if (successful) {
                self.initializationLabel.text = @"Initialization...";
                [docReader initilizeReaderWithLicense:licenseData completion:^(BOOL successful, NSString * _Nullable error ) {
                    if (successful) {
                        [self.activityIndicator stopAnimating];
                        [self.initializationLabel setHidden:YES];
                        [self.userRecognizeImage setHidden:NO];
                        [self.useCameraViewControllerButton setHidden:NO];
                        [self.pickerView setHidden:NO];
                        [self.pickerView reloadAllComponents];
                        [self.pickerView selectRow:0 inComponent:0 animated:NO];

                        for (Scenario *scenario in docReader.availableScenarios) {
                            NSLog(@"%@", scenario);
                            NSLog(@"---------");
                        }
                    } else {
                        [self.activityIndicator stopAnimating];
                        self.initializationLabel.text = [NSString stringWithFormat:@"Initialization error: %@", error];
                        NSLog(@"%@", error);
                    }
                }];
            } else {
                self.initializationLabel.text = [NSString stringWithFormat:@"Downloading database error: %@", error];
                NSLog(@"%@", error);
            }
        }];

        docReader.processParams.scenario = @"Ocr";
        self.docReader = docReader;
    }

    - (IBAction)useCameraViewController:(UIButton *)sender {
        [self.docReader showScanner:self completion:^(enum DocReaderAction action, DocumentReaderResults * _Nullable result, NSString * _Nullable error) {
            switch (action) {
                case DocReaderActionCancel: {
                    NSLog(@"Cancelled by user");
                }
                break;

                case DocReaderActionComplete: {
                    NSLog(@"Completed");
                    [self handleScanResults:result];
                }
                break;

                case DocReaderActionError: {
                    NSLog(@"Error string: %@", error);
                }
                break;

                case DocReaderActionProcess: {
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

    - (void)getImageFromGallery {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                        self.imagePicker.delegate = self;
                        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        self.imagePicker.allowsEditing = NO;
                        dispatch_async(dispatch_get_main_queue(), ^{
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
                        [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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

    - (void)handleScanResults:(DocumentReaderResults *)result {
        // use fast getValue method
        NSString *name = [result getTextFieldValueByTypeWithFieldType:FieldTypeFt_Surname_And_Given_Names];
        NSLog(@"%@", name);
        self.nameLabel.text = name;
        self.documentImage.image = [result getGraphicFieldImageByTypeWithFieldType:GraphicFieldTypeGf_DocumentFront source:ResultTypeRawImage];
        self.portraitImageView.image = [result getGraphicFieldImageByTypeWithFieldType:GraphicFieldTypeGf_Portrait];

        for (DocumentReaderTextField *textField in result.textResult.fields) {
            NSString *value = [result getTextFieldValueByTypeWithFieldType:textField.fieldType lcid:textField.lcid];
            NSLog(@"Field type name: %@, value: %@", textField.fieldName, value);
        }
    }

    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:^{

            [self.docReader recognizeImage:image cameraMode:NO completion:^(enum DocReaderAction action, DocumentReaderResults * _Nullable result, NSString * _Nullable error) {
                if (action == DocReaderActionComplete) {
                    if (result != nil) {
                        NSLog(@"Completed");
                        [self handleScanResults:result];
                    }
                } else if (action == DocReaderActionError) {
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
        return self.docReader.availableScenarios.count;
    }


    - (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return self.docReader.availableScenarios[row].identifier;
    }

    - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        self.docReader.processParams.scenario = self.docReader.availableScenarios[row].identifier;
    }
@end
