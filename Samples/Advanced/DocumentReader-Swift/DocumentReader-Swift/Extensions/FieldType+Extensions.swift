//
//  FieldType+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 2/5/21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension FieldType {    
    var stringValue: String {
        switch self {
        case .ft_Document_Class_Code:
            return ".ft_Document_Class_Code"
        case .ft_Issuing_State_Code:
            return ".ft_Issuing_State_Code"
        case .ft_Document_Number:
            return ".ft_Document_Number"
        case .ft_Date_of_Expiry:
            return ".ft_Date_of_Expiry"
        case .ft_Date_of_Issue:
            return ".ft_Date_of_Issue"
        case .ft_Date_of_Birth:
            return ".ft_Date_of_Birth"
        case .ft_Place_of_Birth:
            return ".ft_Place_of_Birth"
        case .ft_Personal_Number:
            return ".ft_Personal_Number"
        case .ft_Surname:
            return ".ft_Surname"
        case .ft_Given_Names:
            return ".ft_Given_Names"
        case .ft_Mothers_Name:
            return ".ft_Mothers_Name"
        case .ft_Nationality:
            return ".ft_Nationality"
        case .ft_Sex:
            return ".ft_Sex"
        case .ft_Height:
            return ".ft_Height"
        case .ft_Weight:
            return ".ft_Weight"
        case .ft_Eyes_Color:
            return ".ft_Eyes_Color"
        case .ft_Hair_Color:
            return ".ft_Hair_Color"
        case .ft_Address:
            return ".ft_Address"
        case .ft_Donor:
            return ".ft_Donor"
        case .ft_Social_Security_Number:
            return ".ft_Social_Security_Number"
        case .ft_DL_Class:
            return ".ft_DL_Class"
        case .ft_DL_Endorsed:
            return ".ft_DL_Endorsed"
        case .ft_DL_Restriction_Code:
            return ".ft_DL_Restriction_Code"
        case .ft_DL_Under_21_Date:
            return ".ft_DL_Under_21_Date"
        case .ft_Authority:
            return ".ft_Authority"
        case .ft_Surname_And_Given_Names:
            return ".ft_Surname_And_Given_Names"
        case .ft_Nationality_Code:
            return ".ft_Nationality_Code"
        case .ft_Passport_Number:
            return ".ft_Passport_Number"
        case .ft_Invitation_Number:
            return ".ft_Invitation_Number"
        case .ft_Visa_ID:
            return ".ft_Visa_ID"
        case .ft_Visa_Class:
            return ".ft_Visa_Class"
        case .ft_Visa_SubClass:
            return ".ft_Visa_SubClass"
        case .ft_MRZ_String1:
            return ".ft_MRZ_String1"
        case .ft_MRZ_String2:
            return ".ft_MRZ_String2"
        case .ft_MRZ_String3:
            return ".ft_MRZ_String3"
        case .ft_MRZ_Type:
            return ".ft_MRZ_Type"
        case .ft_Optional_Data:
            return ".ft_Optional_Data"
        case .ft_Document_Class_Name:
            return ".ft_Document_Class_Name"
        case .ft_Issuing_State_Name:
            return ".ft_Issuing_State_Name"
        case .ft_Place_of_Issue:
            return ".ft_Place_of_Issue"
        case .ft_Document_Number_Checksum:
            return ".ft_Document_Number_Checksum"
        case .ft_Date_of_Birth_Checksum:
            return ".ft_Date_of_Birth_Checksum"
        case .ft_Date_of_Expiry_Checksum:
            return ".ft_Date_of_Expiry_Checksum"
        case .ft_Personal_Number_Checksum:
            return ".ft_Personal_Number_Checksum"
        case .ft_FinalChecksum:
            return ".ft_FinalChecksum"
        case .ft_Passport_Number_Checksum:
            return ".ft_Passport_Number_Checksum"
        case .ft_Invitation_Number_Checksum:
            return ".ft_Invitation_Number_Checksum"
        case .ft_Visa_ID_Checksum:
            return ".ft_Visa_ID_Checksum"
        case .ft_Surname_And_Given_Names_Checksum:
            return ".ft_Surname_And_Given_Names_Checksum"
        case .ft_Visa_Valid_Until_Checksum:
            return ".ft_Visa_Valid_Until_Checksum"
        case .ft_Other:
            return ".ft_Other"
        case .ft_MRZ_Strings:
            return ".ft_MRZ_Strings"
        case .ft_Name_Suffix:
            return ".ft_Name_Suffix"
        case .ft_Name_Prefix:
            return ".ft_Name_Prefix"
        case .ft_Date_of_Issue_Checksum:
            return ".ft_Date_of_Issue_Checksum"
        case .ft_Date_of_Issue_CheckDigit:
            return ".ft_Date_of_Issue_CheckDigit"
        case .ft_Document_Series:
            return ".ft_Document_Series"
        case .ft_RegCert_RegNumber:
            return ".ft_RegCert_RegNumber"
        case .ft_RegCert_CarModel:
            return ".ft_RegCert_CarModel"
        case .ft_RegCert_CarColor:
            return ".ft_RegCert_CarColor"
        case .ft_RegCert_BodyNumber:
            return ".ft_RegCert_BodyNumber"
        case .ft_RegCert_CarType:
            return ".ft_RegCert_CarType"
        case .ft_RegCert_MaxWeight:
            return ".ft_RegCert_MaxWeight"
        case .ft_Reg_Cert_Weight:
            return ".ft_Reg_Cert_Weight"
        case .ft_Address_Area:
            return ".ft_Address_Area"
        case .ft_Address_State:
            return ".ft_Address_State"
        case .ft_Address_Building:
            return ".ft_Address_Building"
        case .ft_Address_House:
            return ".ft_Address_House"
        case .ft_Address_Flat:
            return ".ft_Address_Flat"
        case .ft_Place_of_Registration:
            return ".ft_Place_of_Registration"
        case .ft_Date_of_Registration:
            return ".ft_Date_of_Registration"
        case .ft_Resident_From:
            return ".ft_Resident_From"
        case .ft_Resident_Until:
            return ".ft_Resident_Until"
        case .ft_Authority_Code:
            return ".ft_Authority_Code"
        case .ft_Place_of_Birth_Area:
            return ".ft_Place_of_Birth_Area"
        case .ft_Place_of_Birth_StateCode:
            return ".ft_Place_of_Birth_StateCode"
        case .ft_Address_Street:
            return ".ft_Address_Street"
        case .ft_Address_City:
            return ".ft_Address_City"
        case .ft_Address_Jurisdiction_Code:
            return ".ft_Address_Jurisdiction_Code"
        case .ft_Address_Postal_Code:
            return ".ft_Address_Postal_Code"
        case .ft_Document_Number_CheckDigit:
            return ".ft_Document_Number_CheckDigit"
        case .ft_Date_of_Birth_CheckDigit:
            return ".ft_Date_of_Birth_CheckDigit"
        case .ft_Date_of_Expiry_CheckDigit:
            return ".ft_Date_of_Expiry_CheckDigit"
        case .ft_Personal_Number_CheckDigit:
            return ".ft_Personal_Number_CheckDigit"
        case .ft_FinalCheckDigit:
            return ".ft_FinalCheckDigit"
        case .ft_Passport_Number_CheckDigit:
            return ".ft_Passport_Number_CheckDigit"
        case .ft_Invitation_Number_CheckDigit:
            return ".ft_Invitation_Number_CheckDigit"
        case .ft_Visa_ID_CheckDigit:
            return ".ft_Visa_ID_CheckDigit"
        case .ft_Surname_And_Given_Names_CheckDigit:
            return ".ft_Surname_And_Given_Names_CheckDigit"
        case .ft_Visa_Valid_Until_CheckDigit:
            return ".ft_Visa_Valid_Until_CheckDigit"
        case .ft_Permit_DL_Class:
            return ".ft_Permit_DL_Class"
        case .ft_Permit_Date_of_Expiry:
            return ".ft_Permit_Date_of_Expiry"
        case .ft_Permit_Identifier:
            return ".ft_Permit_Identifier"
        case .ft_Permit_Date_of_Issue:
            return ".ft_Permit_Date_of_Issue"
        case .ft_Permit_Restriction_Code:
            return ".ft_Permit_Restriction_Code"
        case .ft_Permit_Endorsed:
            return ".ft_Permit_Endorsed"
        case .ft_Issue_Timestamp:
            return ".ft_Issue_Timestamp"
        case .ft_Number_of_Duplicates:
            return ".ft_Number_of_Duplicates"
        case .ft_Medical_Indicator_Codes:
            return ".ft_Medical_Indicator_Codes"
        case .ft_Non_Resident_Indicator:
            return ".ft_Non_Resident_Indicator"
        case .ft_Visa_Type:
            return ".ft_Visa_Type"
        case .ft_Visa_Valid_From:
            return ".ft_Visa_Valid_From"
        case .ft_Visa_Valid_Until:
            return ".ft_Visa_Valid_Until"
        case .ft_Duration_of_Stay:
            return ".ft_Duration_of_Stay"
        case .ft_Number_of_Entries:
            return ".ft_Number_of_Entries"
        case .ft_Day:
            return ".ft_Day"
        case .ft_Month:
            return ".ft_Month"
        case .ft_Year:
            return ".ft_Year"
        case .ft_Unique_Customer_Identifier:
            return ".ft_Unique_Customer_Identifier"
        case .ft_Commercial_Vehicle_Codes:
            return ".ft_Commercial_Vehicle_Codes"
        case .ft_AKA_Date_of_Birth:
            return ".ft_AKA_Date_of_Birth"
        case .ft_AKA_Social_Security_Number:
            return ".ft_AKA_Social_Security_Number"
        case .ft_AKA_Surname:
            return ".ft_AKA_Surname"
        case .ft_AKA_Given_Names:
            return ".ft_AKA_Given_Names"
        case .ft_AKA_Name_Suffix:
            return ".ft_AKA_Name_Suffix"
        case .ft_AKA_Name_Prefix:
            return ".ft_AKA_Name_Prefix"
        case .ft_Mailing_Address_Street:
            return ".ft_Mailing_Address_Street"
        case .ft_Mailing_Address_City:
            return ".ft_Mailing_Address_City"
        case .ft_Mailing_Address_Jurisdiction_Code:
            return ".ft_Mailing_Address_Jurisdiction_Code"
        case .ft_Mailing_Address_Postal_Code:
            return ".ft_Mailing_Address_Postal_Code"
        case .ft_Audit_Information:
            return ".ft_Audit_Information"
        case .ft_Inventory_Number:
            return ".ft_Inventory_Number"
        case .ft_Race_Ethnicity:
            return ".ft_Race_Ethnicity"
        case .ft_Jurisdiction_Vehicle_Class:
            return ".ft_Jurisdiction_Vehicle_Class"
        case .ft_Jurisdiction_Endorsement_Code:
            return ".ft_Jurisdiction_Endorsement_Code"
        case .ft_Jurisdiction_Restriction_Code:
            return ".ft_Jurisdiction_Restriction_Code"
        case .ft_Family_Name:
            return ".ft_Family_Name"
        case .ft_Given_Names_RUS:
            return ".ft_Given_Names_RUS"
        case .ft_Visa_ID_RUS:
            return ".ft_Visa_ID_RUS"
        case .ft_Fathers_Name:
            return ".ft_Fathers_Name"
        case .ft_Fathers_Name_RUS:
            return ".ft_Fathers_Name_RUS"
        case .ft_Surname_And_Given_Names_RUS:
            return ".ft_Surname_And_Given_Names_RUS"
        case .ft_Place_Of_Birth_RUS:
            return ".ft_Place_Of_Birth_RUS"
        case .ft_Authority_RUS:
            return ".ft_Authority_RUS"
        case .ft_Issuing_State_Code_Numeric:
            return ".ft_Issuing_State_Code_Numeric"
        case .ft_Nationality_Code_Numeric:
            return ".ft_Nationality_Code_Numeric"
        case .ft_Engine_Power:
            return ".ft_Engine_Power"
        case .ft_Engine_Volume:
            return ".ft_Engine_Volume"
        case .ft_Chassis_Number:
            return ".ft_Chassis_Number"
        case .ft_Engine_Number:
            return ".ft_Engine_Number"
        case .ft_Engine_Model:
            return ".ft_Engine_Model"
        case .ft_Vehicle_Category:
            return ".ft_Vehicle_Category"
        case .ft_Identity_Card_Number:
            return ".ft_Identity_Card_Number"
        case .ft_Control_No:
            return ".ft_Control_No"
        case .ft_Parrent_s_Given_Names:
            return ".ft_Parrent_s_Given_Names"
        case .ft_Second_Surname:
            return ".ft_Second_Surname"
        case .ft_Middle_Name:
            return ".ft_Middle_Name"
        case .ft_RegCert_VIN:
            return ".ft_RegCert_VIN"
        case .ft_RegCert_VIN_CheckDigit:
            return ".ft_RegCert_VIN_CheckDigit"
        case .ft_RegCert_VIN_Checksum:
            return ".ft_RegCert_VIN_Checksum"
        case .ft_Line1_CheckDigit:
            return ".ft_Line1_CheckDigit"
        case .ft_Line2_CheckDigit:
            return ".ft_Line2_CheckDigit"
        case .ft_Line3_CheckDigit:
            return ".ft_Line3_CheckDigit"
        case .ft_Line1_Checksum:
            return ".ft_Line1_Checksum"
        case .ft_Line2_Checksum:
            return ".ft_Line2_Checksum"
        case .ft_Line3_Checksum:
            return ".ft_Line3_Checksum"
        case .ft_RegCert_RegNumber_CheckDigit:
            return ".ft_RegCert_RegNumber_CheckDigit"
        case .ft_RegCert_RegNumber_Checksum:
            return ".ft_RegCert_RegNumber_Checksum"
        case .ft_RegCert_Vehicle_ITS_Code:
            return ".ft_RegCert_Vehicle_ITS_Code"
        case .ft_Card_Access_Number:
            return ".ft_Card_Access_Number"
        case .ft_Marital_Status:
            return ".ft_Marital_Status"
        case .ft_Company_Name:
            return ".ft_Company_Name"
        case .ft_Special_Notes:
            return ".ft_Special_Notes"
        case .ft_Surname_of_Spose:
            return ".ft_Surname_of_Spose"
        case .ft_Tracking_Number:
            return ".ft_Tracking_Number"
        case .ft_Booklet_Number:
            return ".ft_Booklet_Number"
        case .ft_Children:
            return ".ft_Children"
        case .ft_Copy:
            return ".ft_Copy"
        case .ft_Serial_Number:
            return ".ft_Serial_Number"
        case .ft_Dossier_Number:
            return ".ft_Dossier_Number"
        case .ft_AKA_Surname_And_Given_Names:
            return ".ft_AKA_Surname_And_Given_Names"
        case .ft_Territorial_Validity:
            return ".ft_Territorial_Validity"
        case .ft_MRZ_Strings_With_Correct_CheckSums:
            return ".ft_MRZ_Strings_With_Correct_CheckSums"
        case .ft_DL_CDL_Restriction_Code:
            return ".ft_DL_CDL_Restriction_Code"
        case .ft_DL_Under_18_Date:
            return ".ft_DL_Under_18_Date"
        case .ft_DL_Record_Created:
            return ".ft_DL_Record_Created"
        case .ft_DL_Duplicate_Date:
            return ".ft_DL_Duplicate_Date"
        case .ft_DL_Iss_Type:
            return ".ft_DL_Iss_Type"
        case .ft_Military_Book_Number:
            return ".ft_Military_Book_Number"
        case .ft_Destination:
            return ".ft_Destination"
        case .ft_Blood_Group:
            return ".ft_Blood_Group"
        case .ft_Sequence_Number:
            return ".ft_Sequence_Number"
        case .ft_RegCert_BodyType:
            return ".ft_RegCert_BodyType"
        case .ft_RegCert_CarMark:
            return ".ft_RegCert_CarMark"
        case .ft_Transaction_Number:
            return ".ft_Transaction_Number"
        case .ft_Age:
            return ".ft_Age"
        case .ft_Folio_Number:
            return ".ft_Folio_Number"
        case .ft_Voter_Key:
            return ".ft_Voter_Key"
        case .ft_Address_Municipality:
            return ".ft_Address_Municipality"
        case .ft_Address_Location:
            return ".ft_Address_Location"
        case .ft_Section:
            return ".ft_Section"
        case .ft_OCR_Number:
            return ".ft_OCR_Number"
        case .ft_Federal_Elections:
            return ".ft_Federal_Elections"
        case .ft_Reference_Number:
            return ".ft_Reference_Number"
        case .ft_Optional_Data_Checksum:
            return ".ft_Optional_Data_Checksum"
        case .ft_Optional_Data_CheckDigit:
            return ".ft_Optional_Data_CheckDigit"
        case .ft_Visa_Number:
            return ".ft_Visa_Number"
        case .ft_Visa_Number_Checksum:
            return ".ft_Visa_Number_Checksum"
        case .ft_Visa_Number_CheckDigit:
            return ".ft_Visa_Number_CheckDigit"
        case .ft_Voter:
            return ".ft_Voter"
        case .ft_Previous_Type:
            return ".ft_Previous_Type"
        case .ft_FieldFromMRZ:
            return ".ft_FieldFromMRZ"
        case .ft_CurrentDate:
            return ".ft_CurrentDate"
        case .ft_Status_Date_of_Expiry:
            return ".ft_Status_Date_of_Expiry"
        case .ft_Banknote_Number:
            return ".ft_Banknote_Number"
        case .ft_CSC_Code:
            return ".ft_CSC_Code"
        case .ft_Artistic_Name:
            return ".ft_Artistic_Name"
        case .ft_Academic_Title:
            return ".ft_Academic_Title"
        case .ft_Address_Country:
            return ".ft_Address_Country"
        case .ft_Address_Zipcode:
            return ".ft_Address_Zipcode"
        case .ft_EID_Residence_Permit1:
            return ".ft_EID_Residence_Permit1"
        case .ft_EID_Residence_Permit2:
            return ".ft_EID_Residence_Permit2"
        case .ft_EID_PlaceOfBirth_Street:
            return ".ft_EID_PlaceOfBirth_Street"
        case .ft_EID_PlaceOfBirth_City:
            return ".ft_EID_PlaceOfBirth_City"
        case .ft_EID_PlaceOfBirth_State:
            return ".ft_EID_PlaceOfBirth_State"
        case .ft_EID_PlaceOfBirth_Country:
            return ".ft_EID_PlaceOfBirth_Country"
        case .ft_EID_PlaceOfBirth_Zipcode:
            return ".ft_EID_PlaceOfBirth_Zipcode"
        case .ft_CDL_Class:
            return ".ft_CDL_Class"
        case .ft_DL_Under_19_Date:
            return ".ft_DL_Under_19_Date"
        case .ft_Weight_pounds:
            return ".ft_Weight_pounds"
        case .ft_Limited_Duration_Document_Indicator:
            return ".ft_Limited_Duration_Document_Indicator"
        case .ft_Endorsement_Expiration_Date:
            return ".ft_Endorsement_Expiration_Date"
        case .ft_Revision_Date:
            return ".ft_Revision_Date"
        case .ft_Compliance_Type:
            return ".ft_Compliance_Type"
        case .ft_Family_name_truncation:
            return ".ft_Family_name_truncation"
        case .ft_First_name_truncation:
            return ".ft_First_name_truncation"
        case .ft_Middle_name_truncation:
            return ".ft_Middle_name_truncation"
        case .ft_Exam_Date:
            return ".ft_Exam_Date"
        case .ft_Organization:
            return ".ft_Organization"
        case .ft_Department:
            return ".ft_Department"
        case .ft_Pay_Grade:
            return ".ft_Pay_Grade"
        case .ft_Rank:
            return ".ft_Rank"
        case .ft_Benefits_Number:
            return ".ft_Benefits_Number"
        case .ft_Sponsor_Service:
            return ".ft_Sponsor_Service"
        case .ft_Sponsor_Status:
            return ".ft_Sponsor_Status"
        case .ft_Sponsor:
            return ".ft_Sponsor"
        case .ft_Relationship:
            return ".ft_Relationship"
        case .ft_USCIS:
            return ".ft_USCIS"
        case .ft_Category:
            return ".ft_Category"
        case .ft_Conditions:
            return ".ft_Conditions"
        case .ft_Identifier:
            return ".ft_Identifier"
        case .ft_Configuration:
            return ".ft_Configuration"
        case .ft_Discretionary_data:
            return ".ft_Discretionary_data"
        case .ft_Line1_Optional_Data:
            return ".ft_Line1_Optional_Data"
        case .ft_Line2_Optional_Data:
            return ".ft_Line2_Optional_Data"
        case .ft_Line3_Optional_Data:
            return ".ft_Line3_Optional_Data"
        case .ft_EQV_Code:
            return ".ft_EQV_Code"
        case .ft_ALT_Code:
            return ".ft_ALT_Code"
        case .ft_Binary_Code:
            return ".ft_Binary_Code"
        case .ft_Pseudo_Code:
            return ".ft_Pseudo_Code"
        case .ft_Fee:
            return ".ft_Fee"
        case .ft_Stamp_Number:
            return ".ft_Stamp_Number"
        case .ft_SBH_SecurityOptions:
            return ".ft_SBH_SecurityOptions"
        case .ft_SBH_IntegrityOptions:
            return ".ft_SBH_IntegrityOptions"
        case .ft_Date_of_Creation:
            return ".ft_Date_of_Creation"
        case .ft_Validity_Period:
            return ".ft_Validity_Period"
        case .ft_Patron_Header_Version:
            return ".ft_Patron_Header_Version"
        case .ft_BDB_Type:
            return ".ft_BDB_Type"
        case .ft_Biometric_Type:
            return ".ft_Biometric_Type"
        case .ft_Biometric_Subtype:
            return ".ft_Biometric_Subtype"
        case .ft_Biometric_ProductID:
            return ".ft_Biometric_ProductID"
        case .ft_Biometric_Format_Owner:
            return ".ft_Biometric_Format_Owner"
        case .ft_Biometric_Format_Type:
            return ".ft_Biometric_Format_Type"
        case .ft_Phone:
            return ".ft_Phone"
        case .ft_Profession:
            return ".ft_Profession"
        case .ft_Title:
            return ".ft_Title"
        case .ft_Personal_Summary:
            return ".ft_Personal_Summary"
        case .ft_Other_Valid_ID:
            return ".ft_Other_Valid_ID"
        case .ft_Custody_Info:
            return ".ft_Custody_Info"
        case .ft_Other_Name:
            return ".ft_Other_Name"
        case .ft_Observations:
            return ".ft_Observations"
        case .ft_Tax:
            return ".ft_Tax"
        case .ft_Date_of_Personalization:
            return ".ft_Date_of_Personalization"
        case .ft_Personalization_SN:
            return ".ft_Personalization_SN"
        case .ft_OtherPerson_Name:
            return ".ft_OtherPerson_Name"
        case .ft_PersonToNotify_Date_of_Record:
            return ".ft_PersonToNotify_Date_of_Record"
        case .ft_PersonToNotify_Name:
            return ".ft_PersonToNotify_Name"
        case .ft_PersonToNotify_Phone:
            return ".ft_PersonToNotify_Phone"
        case .ft_PersonToNotify_Address:
            return ".ft_PersonToNotify_Address"
        case .ft_DS_Certificate_Issuer:
            return ".ft_DS_Certificate_Issuer"
        case .ft_DS_Certificate_Subject:
            return ".ft_DS_Certificate_Subject"
        case .ft_DS_Certificate_ValidFrom:
            return ".ft_DS_Certificate_ValidFrom"
        case .ft_DS_Certificate_ValidTo:
            return ".ft_DS_Certificate_ValidTo"
        case .ft_VRC_DataObject_Entry:
            return ".ft_VRC_DataObject_Entry"
        case .ft_TypeApprovalNumber:
            return ".ft_TypeApprovalNumber"
        case .ft_AdministrativeNumber:
            return ".ft_AdministrativeNumber"
        case .ft_DocumentDiscriminator:
            return ".ft_DocumentDiscriminator"
        case .ft_DataDiscriminator:
            return ".ft_DataDiscriminator"
        case .ft_ISO_Issuer_ID_Number:
            return ".ft_ISO_Issuer_ID_Number"
        case .ft_GNIB_Number:
            return ".ft_GNIB_Number"
        case .ft_Dept_Number:
            return ".ft_Dept_Number"
        case .ft_Telex_Code:
            return ".ft_Telex_Code"
        case .ft_Allergies:
            return ".ft_Allergies"
        case .ft_Sp_Code:
            return ".ft_Sp_Code"
        case .ft_Court_Code:
            return ".ft_Court_Code"
        case .ft_Cty:
            return ".ft_Cty"
        case .ft_Sponsor_SSN:
            return ".ft_Sponsor_SSN"
        case .ft_DoD_Number:
            return ".ft_DoD_Number"
        case .ft_MC_Novice_Date:
            return ".ft_MC_Novice_Date"
        case .ft_DUF_Number:
            return ".ft_DUF_Number"
        case .ft_AGY:
            return ".ft_AGY"
        case .ft_PNR_Code:
            return ".ft_PNR_Code"
        case .ft_From_Airport_Code:
            return ".ft_From_Airport_Code"
        case .ft_To_Airport_Code:
            return ".ft_To_Airport_Code"
        case .ft_Flight_Number:
            return ".ft_Flight_Number"
        case .ft_Date_of_Flight:
            return ".ft_Date_of_Flight"
        case .ft_Seat_Number:
            return ".ft_Seat_Number"
        case .ft_Date_of_Issue_Boarding_Pass:
            return ".ft_Date_of_Issue_Boarding_Pass"
        case .ft_CCW_Until:
            return ".ft_CCW_Until"
        case .ft_Reference_Number_Checksum:
            return ".ft_Reference_Number_Checksum"
        case .ft_Reference_Number_CheckDigit:
            return ".ft_Reference_Number_CheckDigit"
        case .ft_Room_Number:
            return ".ft_Room_Number"
        case .ft_Religion:
            return ".ft_Religion"
        case .ft_RemainderTerm:
            return ".ft_RemainderTerm"
        case .ft_Electronic_Ticket_Indicator:
            return ".ft_Electronic_Ticket_Indicator"
        case .ft_Compartment_Code:
            return ".ft_Compartment_Code"
        case .ft_CheckIn_Sequence_Number:
            return ".ft_CheckIn_Sequence_Number"
        case .ft_Airline_Designator_of_boarding_pass_issuer:
            return ".ft_Airline_Designator_of_boarding_pass_issuer"
        case .ft_Airline_Numeric_Code:
            return ".ft_Airline_Numeric_Code"
        case .ft_Ticket_Number:
            return ".ft_Ticket_Number"
        case .ft_Frequent_Flyer_Airline_Designator:
            return ".ft_Frequent_Flyer_Airline_Designator"
        case .ft_Frequent_Flyer_Number:
            return ".ft_Frequent_Flyer_Number"
        case .ft_Free_Baggage_Allowance:
            return ".ft_Free_Baggage_Allowance"
        case .ft_PDF417Codec:
            return ".ft_PDF417Codec"
        case .ft_Identity_Card_Number_Checksum:
            return ".ft_Identity_Card_Number_Checksum"
        case .ft_Identity_Card_Number_CheckDigit:
            return ".ft_Identity_Card_Number_CheckDigit"
        case .ft_Veteran:
            return ".ft_Veteran"
        case .ft_DLClassCode_A1_From:
            return ".ft_DLClassCode_A1_From"
        case .ft_DLClassCode_A1_To:
            return ".ft_DLClassCode_A1_To"
        case .ft_DLClassCode_A1_Notes:
            return ".ft_DLClassCode_A1_Notes"
        case .ft_DLClassCode_A_From:
            return ".ft_DLClassCode_A_From"
        case .ft_DLClassCode_A_To:
            return ".ft_DLClassCode_A_To"
        case .ft_DLClassCode_A_Notes:
            return ".ft_DLClassCode_A_Notes"
        case .ft_DLClassCode_B_From:
            return ".ft_DLClassCode_B_From"
        case .ft_DLClassCode_B_To:
            return ".ft_DLClassCode_B_To"
        case .ft_DLClassCode_B_Notes:
            return ".ft_DLClassCode_B_Notes"
        case .ft_DLClassCode_C1_From:
            return ".ft_DLClassCode_C1_From"
        case .ft_DLClassCode_C1_To:
            return ".ft_DLClassCode_C1_To"
        case .ft_DLClassCode_C1_Notes:
            return ".ft_DLClassCode_C1_Notes"
        case .ft_DLClassCode_C_From:
            return ".ft_DLClassCode_C_From"
        case .ft_DLClassCode_C_To:
            return ".ft_DLClassCode_C_To"
        case .ft_DLClassCode_C_Notes:
            return ".ft_DLClassCode_C_Notes"
        case .ft_DLClassCode_D1_From:
            return ".ft_DLClassCode_D1_From"
        case .ft_DLClassCode_D1_To:
            return ".ft_DLClassCode_D1_To"
        case .ft_DLClassCode_D1_Notes:
            return ".ft_DLClassCode_D1_Notes"
        case .ft_DLClassCode_D_From:
            return ".ft_DLClassCode_D_From"
        case .ft_DLClassCode_D_To:
            return ".ft_DLClassCode_D_To"
        case .ft_DLClassCode_D_Notes:
            return ".ft_DLClassCode_D_Notes"
        case .ft_DLClassCode_BE_From:
            return ".ft_DLClassCode_BE_From"
        case .ft_DLClassCode_BE_To:
            return ".ft_DLClassCode_BE_To"
        case .ft_DLClassCode_BE_Notes:
            return ".ft_DLClassCode_BE_Notes"
        case .ft_DLClassCode_C1E_From:
            return ".ft_DLClassCode_C1E_From"
        case .ft_DLClassCode_C1E_To:
            return ".ft_DLClassCode_C1E_To"
        case .ft_DLClassCode_C1E_Notes:
            return ".ft_DLClassCode_C1E_Notes"
        case .ft_DLClassCode_CE_From:
            return ".ft_DLClassCode_CE_From"
        case .ft_DLClassCode_CE_To:
            return ".ft_DLClassCode_CE_To"
        case .ft_DLClassCode_CE_Notes:
            return ".ft_DLClassCode_CE_Notes"
        case .ft_DLClassCode_D1E_From:
            return ".ft_DLClassCode_D1E_From"
        case .ft_DLClassCode_D1E_To:
            return ".ft_DLClassCode_D1E_To"
        case .ft_DLClassCode_D1E_Notes:
            return ".ft_DLClassCode_D1E_Notes"
        case .ft_DLClassCode_DE_From:
            return ".ft_DLClassCode_DE_From"
        case .ft_DLClassCode_DE_To:
            return ".ft_DLClassCode_DE_To"
        case .ft_DLClassCode_DE_Notes:
            return ".ft_DLClassCode_DE_Notes"
        case .ft_DLClassCode_M_From:
            return ".ft_DLClassCode_M_From"
        case .ft_DLClassCode_M_To:
            return ".ft_DLClassCode_M_To"
        case .ft_DLClassCode_M_Notes:
            return ".ft_DLClassCode_M_Notes"
        case .ft_DLClassCode_L_From:
            return ".ft_DLClassCode_L_From"
        case .ft_DLClassCode_L_To:
            return ".ft_DLClassCode_L_To"
        case .ft_DLClassCode_L_Notes:
            return ".ft_DLClassCode_L_Notes"
        case .ft_DLClassCode_T_From:
            return ".ft_DLClassCode_T_From"
        case .ft_DLClassCode_T_To:
            return ".ft_DLClassCode_T_To"
        case .ft_DLClassCode_T_Notes:
            return ".ft_DLClassCode_T_Notes"
        case .ft_DLClassCode_AM_From:
            return ".ft_DLClassCode_AM_From"
        case .ft_DLClassCode_AM_To:
            return ".ft_DLClassCode_AM_To"
        case .ft_DLClassCode_AM_Notes:
            return ".ft_DLClassCode_AM_Notes"
        case .ft_DLClassCode_A2_From:
            return ".ft_DLClassCode_A2_From"
        case .ft_DLClassCode_A2_To:
            return ".ft_DLClassCode_A2_To"
        case .ft_DLClassCode_A2_Notes:
            return ".ft_DLClassCode_A2_Notes"
        case .ft_DLClassCode_B1_From:
            return ".ft_DLClassCode_B1_From"
        case .ft_DLClassCode_B1_To:
            return ".ft_DLClassCode_B1_To"
        case .ft_DLClassCode_B1_Notes:
            return ".ft_DLClassCode_B1_Notes"
        case .ft_Surname_at_Birth:
            return ".ft_Surname_at_Birth"
        case .ft_Civil_Status:
            return ".ft_Civil_Status"
        case .ft_Number_of_Seats:
            return ".ft_Number_of_Seats"
        case .ft_Number_of_Standing_Places:
            return ".ft_Number_of_Standing_Places"
        case .ft_Max_Speed:
            return ".ft_Max_Speed"
        case .ft_Fuel_Type:
            return ".ft_Fuel_Type"
        case .ft_EC_Environmental_Type:
            return ".ft_EC_Environmental_Type"
        case .ft_Power_Weight_Ratio:
            return ".ft_Power_Weight_Ratio"
        case .ft_Max_Mass_of_Trailer_Braked:
            return ".ft_Max_Mass_of_Trailer_Braked"
        case .ft_Max_Mass_of_Trailer_Unbraked:
            return ".ft_Max_Mass_of_Trailer_Unbraked"
        case .ft_Transmission_Type:
            return ".ft_Transmission_Type"
        case .ft_Trailer_Hitch:
            return ".ft_Trailer_Hitch"
        case .ft_Accompanied_by:
            return ".ft_Accompanied_by"
        case .ft_Police_District:
            return ".ft_Police_District"
        case .ft_First_Issue_Date:
            return ".ft_First_Issue_Date"
        case .ft_Payload_Capacity:
            return ".ft_Payload_Capacity"
        case .ft_Number_of_Axels:
            return ".ft_Number_of_Axels"
        case .ft_Permissible_Axle_Load:
            return ".ft_Permissible_Axle_Load"
        case .ft_Precinct:
            return ".ft_Precinct"
        case .ft_Invited_by:
            return ".ft_Invited_by"
        case .ft_Purpose_of_Entry:
            return ".ft_Purpose_of_Entry"
        case .ft_Skin_Color:
            return ".ft_Skin_Color"
        case .ft_Complexion:
            return ".ft_Complexion"
        case .ft_Airport_From:
            return ".ft_Airport_From"
        case .ft_Airport_To:
            return ".ft_Airport_To"
        case .ft_Airline_Name:
            return ".ft_Airline_Name"
        case .ft_Airline_Name_Frequent_Flyer:
            return ".ft_Airline_Name_Frequent_Flyer"
        case .ft_License_Number:
            return ".ft_License_Number"
        case .ft_In_Tanks:
            return ".ft_In_Tanks"
        case .ft_Exept_In_Tanks:
            return ".ft_Exept_In_Tanks"
        case .ft_Fast_Track:
            return ".ft_Fast_Track"
        case .ft_Owner:
            return ".ft_Owner"
        case .ft_MRZ_Strings_ICAO_RFID:
            return ".ft_MRZ_Strings_ICAO_RFID"
        case .ft_Number_of_Card_Issuance:
            return ".ft_Number_of_Card_Issuance"
        case .ft_Number_of_Card_Issuance_Checksum:
            return ".ft_Number_of_Card_Issuance_Checksum"
        case .ft_Number_of_Card_Issuance_CheckDigit:
            return ".ft_Number_of_Card_Issuance_CheckDigit"
        case .ft_Century_Date_of_Birth:
            return ".ft_Century_Date_of_Birth"
        case .ft_DLClassCode_A3_From:
            return ".ft_DLClassCode_A3_From"
        case .ft_DLClassCode_A3_To:
            return ".ft_DLClassCode_A3_To"
        case .ft_DLClassCode_A3_Notes:
            return ".ft_DLClassCode_A3_Notes"
        case .ft_DLClassCode_C2_From:
            return ".ft_DLClassCode_C2_From"
        case .ft_DLClassCode_C2_To:
            return ".ft_DLClassCode_C2_To"
        case .ft_DLClassCode_C2_Notes:
            return ".ft_DLClassCode_C2_Notes"
        case .ft_DLClassCode_B2_From:
            return ".ft_DLClassCode_B2_From"
        case .ft_DLClassCode_B2_To:
            return ".ft_DLClassCode_B2_To"
        case .ft_DLClassCode_B2_Notes:
            return ".ft_DLClassCode_B2_Notes"
        case .ft_DLClassCode_D2_From:
            return ".ft_DLClassCode_D2_From"
        case .ft_DLClassCode_D2_To:
            return ".ft_DLClassCode_D2_To"
        case .ft_DLClassCode_D2_Notes:
            return ".ft_DLClassCode_D2_Notes"
        case .ft_DLClassCode_B2E_From:
            return ".ft_DLClassCode_B2E_From"
        case .ft_DLClassCode_B2E_To:
            return ".ft_DLClassCode_B2E_To"
        case .ft_DLClassCode_B2E_Notes:
            return ".ft_DLClassCode_B2E_Notes"
        case .ft_DLClassCode_G_From:
            return ".ft_DLClassCode_G_From"
        case .ft_DLClassCode_G_To:
            return ".ft_DLClassCode_G_To"
        case .ft_DLClassCode_G_Notes:
            return ".ft_DLClassCode_G_Notes"
        case .ft_DLClassCode_J_From:
            return ".ft_DLClassCode_J_From"
        case .ft_DLClassCode_J_To:
            return ".ft_DLClassCode_J_To"
        case .ft_DLClassCode_J_Notes:
            return ".ft_DLClassCode_J_Notes"
        case .ft_DLClassCode_LC_From:
            return ".ft_DLClassCode_LC_From"
        case .ft_DLClassCode_LC_To:
            return ".ft_DLClassCode_LC_To"
        case .ft_DLClassCode_LC_Notes:
            return ".ft_DLClassCode_LC_Notes"
        case .ft_BankCardNumber:
            return ".ft_BankCardNumber"
        case .ft_BankCardValidThru:
            return ".ft_BankCardValidThru"
        case .ft_TaxNumber:
            return ".ft_TaxNumber"
        case .ft_HealthNumber:
            return ".ft_HealthNumber"
        case .ft_GrandfatherName:
            return ".ft_GrandfatherName"
        case .ft_Selectee_Indicator:
            return ".ft_Selectee_Indicator"
        case .ft_Mother_Surname:
            return ".ft_Mother_Surname"
        case .ft_Mother_GivenName:
            return ".ft_Mother_GivenName"
        case .ft_Father_Surname:
            return ".ft_Father_Surname"
        case .ft_Father_GivenName:
            return ".ft_Father_GivenName"
        case .ft_Mother_DateOfBirth:
            return ".ft_Mother_DateOfBirth"
        case .ft_Father_DateOfBirth:
            return ".ft_Father_DateOfBirth"
        case .ft_Mother_PersonalNumber:
            return ".ft_Mother_PersonalNumber"
        case .ft_Father_PersonalNumber:
            return ".ft_Father_PersonalNumber"
        case .ft_Mother_PlaceOfBirth:
            return ".ft_Mother_PlaceOfBirth"
        case .ft_Father_PlaceOfBirth:
            return ".ft_Father_PlaceOfBirth"
        case .ft_Mother_CountryOfBirth:
            return ".ft_Mother_CountryOfBirth"
        case .ft_Father_CountryOfBirth:
            return ".ft_Father_CountryOfBirth"
        case .ft_Date_First_Renewal:
            return ".ft_Date_First_Renewal"
        case .ft_Date_Second_Renewal:
            return ".ft_Date_Second_Renewal"
        case .ft_PlaceOfExamination:
            return ".ft_PlaceOfExamination"
        case .ft_ApplicationNumber:
            return ".ft_ApplicationNumber"
        case .ft_VoucherNumber:
            return ".ft_VoucherNumber"
        case .ft_AuthorizationNumber:
            return ".ft_AuthorizationNumber"
        case .ft_Faculty:
            return ".ft_Faculty"
        case .ft_FormOfEducation:
            return ".ft_FormOfEducation"
        case .ft_DNINumber:
            return ".ft_DNINumber"
        case .ft_RetirementNumber:
            return ".ft_RetirementNumber"
        case .ft_ProfessionalIdNumber:
            return ".ft_ProfessionalIdNumber"
        case .ft_Age_at_Issue:
            return ".ft_Age_at_Issue"
        case .ft_Years_Since_Issue:
            return ".ft_Years_Since_Issue"
        case .ft_DLClassCode_BTP_From:
            return ".ft_DLClassCode_BTP_From"
        case .ft_DLClassCode_BTP_Notes:
            return ".ft_DLClassCode_BTP_Notes"
        case .ft_DLClassCode_BTP_To:
            return ".ft_DLClassCode_BTP_To"
        case .ft_DLClassCode_C3_From:
            return ".ft_DLClassCode_C3_From"
        case .ft_DLClassCode_C3_Notes:
            return ".ft_DLClassCode_C3_Notes"
        case .ft_DLClassCode_C3_To:
            return ".ft_DLClassCode_C3_To"
        case .ft_DLClassCode_E_From:
            return ".ft_DLClassCode_E_From"
        case .ft_DLClassCode_E_Notes:
            return ".ft_DLClassCode_E_Notes"
        case .ft_DLClassCode_E_To:
            return ".ft_DLClassCode_E_To"
        case .ft_DLClassCode_F_From:
            return ".ft_DLClassCode_F_From"
        case .ft_DLClassCode_F_Notes:
            return ".ft_DLClassCode_F_Notes"
        case .ft_DLClassCode_F_To:
            return ".ft_DLClassCode_F_To"
        case .ft_DLClassCode_FA_From:
            return ".ft_DLClassCode_FA_From"
        case .ft_DLClassCode_FA_Notes:
            return ".ft_DLClassCode_FA_Notes"
        case .ft_DLClassCode_FA_To:
            return ".ft_DLClassCode_FA_To"
        case .ft_DLClassCode_FA1_From:
            return ".ft_DLClassCode_FA1_From"
        case .ft_DLClassCode_FA1_Notes:
            return ".ft_DLClassCode_FA1_Notes"
        case .ft_DLClassCode_FA1_To:
            return ".ft_DLClassCode_FA1_To"
        case .ft_DLClassCode_FB_From:
            return ".ft_DLClassCode_FB_From"
        case .ft_DLClassCode_FB_Notes:
            return ".ft_DLClassCode_FB_Notes"
        case .ft_DLClassCode_FB_To:
            return ".ft_DLClassCode_FB_To"
        case .ft_DLClassCode_G1_From:
            return ".ft_DLClassCode_G1_From"
        case .ft_DLClassCode_G1_Notes:
            return ".ft_DLClassCode_G1_Notes"
        case .ft_DLClassCode_G1_To:
            return ".ft_DLClassCode_G1_To"
        case .ft_DLClassCode_H_From:
            return ".ft_DLClassCode_H_From"
        case .ft_DLClassCode_H_Notes:
            return ".ft_DLClassCode_H_Notes"
        case .ft_DLClassCode_H_To:
            return ".ft_DLClassCode_H_To"
        case .ft_DLClassCode_I_From:
            return ".ft_DLClassCode_I_From"
        case .ft_DLClassCode_I_Notes:
            return ".ft_DLClassCode_I_Notes"
        case .ft_DLClassCode_I_To:
            return ".ft_DLClassCode_I_To"
        case .ft_DLClassCode_K_From:
            return ".ft_DLClassCode_K_From"
        case .ft_DLClassCode_K_Notes:
            return ".ft_DLClassCode_K_Notes"
        case .ft_DLClassCode_K_To:
            return ".ft_DLClassCode_K_To"
        case .ft_DLClassCode_LK_From:
            return ".ft_DLClassCode_LK_From"
        case .ft_DLClassCode_LK_Notes:
            return ".ft_DLClassCode_LK_Notes"
        case .ft_DLClassCode_LK_To:
            return ".ft_DLClassCode_LK_To"
        case .ft_DLClassCode_N_From:
            return ".ft_DLClassCode_N_From"
        case .ft_DLClassCode_N_Notes:
            return ".ft_DLClassCode_N_Notes"
        case .ft_DLClassCode_N_To:
            return ".ft_DLClassCode_N_To"
        case .ft_DLClassCode_S_From:
            return ".ft_DLClassCode_S_From"
        case .ft_DLClassCode_S_Notes:
            return ".ft_DLClassCode_S_Notes"
        case .ft_DLClassCode_S_To:
            return ".ft_DLClassCode_S_To"
        case .ft_DLClassCode_TB_From:
            return ".ft_DLClassCode_TB_From"
        case .ft_DLClassCode_TB_Notes:
            return ".ft_DLClassCode_TB_Notes"
        case .ft_DLClassCode_TB_To:
            return ".ft_DLClassCode_TB_To"
        case .ft_DLClassCode_TM_From:
            return ".ft_DLClassCode_TM_From"
        case .ft_DLClassCode_TM_Notes:
            return ".ft_DLClassCode_TM_Notes"
        case .ft_DLClassCode_TM_To:
            return ".ft_DLClassCode_TM_To"
        case .ft_DLClassCode_TR_From:
            return ".ft_DLClassCode_TR_From"
        case .ft_DLClassCode_TR_Notes:
            return ".ft_DLClassCode_TR_Notes"
        case .ft_DLClassCode_TR_To:
            return ".ft_DLClassCode_TR_To"
        case .ft_DLClassCode_TV_From:
            return ".ft_DLClassCode_TV_From"
        case .ft_DLClassCode_TV_Notes:
            return ".ft_DLClassCode_TV_Notes"
        case .ft_DLClassCode_TV_To:
            return ".ft_DLClassCode_TV_To"
        case .ft_DLClassCode_V_From:
            return ".ft_DLClassCode_V_From"
        case .ft_DLClassCode_V_Notes:
            return ".ft_DLClassCode_V_Notes"
        case .ft_DLClassCode_V_To:
            return ".ft_DLClassCode_V_To"
        case .ft_DLClassCode_W_From:
            return ".ft_DLClassCode_W_From"
        case .ft_DLClassCode_W_Notes:
            return ".ft_DLClassCode_W_Notes"
        case .ft_DLClassCode_W_To:
            return ".ft_DLClassCode_W_To"
        case .ft_URL:
            return ".ft_URL"
        case .ft_Caliber:
            return ".ft_Caliber"
        case .ft_Model:
            return ".ft_Model"
        case .ft_Make:
            return ".ft_Make"
        case .ft_NumberOfCylinders:
            return ".ft_NumberOfCylinders"
        case .ft_SurnameOfHusbandAfterRegistration:
            return ".ft_SurnameOfHusbandAfterRegistration"
        case .ft_SurnameOfWifeAfterRegistration:
            return ".ft_SurnameOfWifeAfterRegistration"
        case .ft_DateOfBirthOfWife:
            return ".ft_DateOfBirthOfWife"
        case .ft_DateOfBirthOfHusband:
            return ".ft_DateOfBirthOfHusband"
        case .ft_CitizenshipOfFirstPerson:
            return ".ft_CitizenshipOfFirstPerson"
        case .ft_CitizenshipOfSecondPerson:
            return ".ft_CitizenshipOfSecondPerson"
        case .ft_CVV:
            return ".ft_CVV"
        case .ft_Date_of_Insurance_Expiry:
            return ".ft_Date_of_Insurance_Expiry"
        case .ft_Mortgage_by:
            return ".ft_Mortgage_by"
        case .ft_Old_Document_Number:
            return ".ft_Old_Document_Number"
        case .ft_Old_Date_of_Issue:
            return ".ft_Old_Date_of_Issue"
        case .ft_Old_Place_of_Issue:
            return ".ft_Old_Place_of_Issue"
        case .ft_DLClassCode_LR_From:
            return ".ft_DLClassCode_LR_From"
        case .ft_DLClassCode_LR_To:
            return ".ft_DLClassCode_LR_To"
        case .ft_DLClassCode_LR_Notes:
            return ".ft_DLClassCode_LR_Notes"
        case .ft_DLClassCode_MR_From:
            return ".ft_DLClassCode_MR_From"
        case .ft_DLClassCode_MR_To:
            return ".ft_DLClassCode_MR_To"
        case .ft_DLClassCode_MR_Notes:
            return ".ft_DLClassCode_MR_Notes"
        case .ft_DLClassCode_HR_From:
            return ".ft_DLClassCode_HR_From"
        case .ft_DLClassCode_HR_To:
            return ".ft_DLClassCode_HR_To"
        case .ft_DLClassCode_HR_Notes:
            return ".ft_DLClassCode_HR_Notes"
        case .ft_DLClassCode_HC_From:
            return ".ft_DLClassCode_HC_From"
        case .ft_DLClassCode_HC_To:
            return ".ft_DLClassCode_HC_To"
        case .ft_DLClassCode_HC_Notes:
            return ".ft_DLClassCode_HC_Notes"
        case .ft_DLClassCode_MC_From:
            return ".ft_DLClassCode_MC_From"
        case .ft_DLClassCode_MC_To:
            return ".ft_DLClassCode_MC_To"
        case .ft_DLClassCode_MC_Notes:
            return ".ft_DLClassCode_MC_Notes"
        case .ft_DLClassCode_RE_From:
            return ".ft_DLClassCode_RE_From"
        case .ft_DLClassCode_RE_To:
            return ".ft_DLClassCode_RE_To"
        case .ft_DLClassCode_RE_Notes:
            return ".ft_DLClassCode_RE_Notes"
        case .ft_DLClassCode_R_From:
            return ".ft_DLClassCode_R_From"
        case .ft_DLClassCode_R_To:
            return ".ft_DLClassCode_R_To"
        case .ft_DLClassCode_R_Notes:
            return ".ft_DLClassCode_R_Notes"
        case .ft_DLClassCode_CA_From:
            return ".ft_DLClassCode_CA_From"
        case .ft_DLClassCode_CA_To:
            return ".ft_DLClassCode_CA_To"
        case .ft_DLClassCode_CA_Notes:
            return ".ft_DLClassCode_CA_Notes"
        @unknown default:
            return ""
        }
    }
}

extension FieldType {
    static var allCases: [FieldType] = [
        .ft_Document_Class_Code, .ft_Issuing_State_Code, .ft_Document_Number,
        .ft_Date_of_Expiry, .ft_Date_of_Issue, .ft_Date_of_Birth, .ft_Place_of_Birth,
        .ft_Personal_Number, .ft_Surname, .ft_Given_Names, .ft_Mothers_Name, .ft_Nationality,
        .ft_Sex, .ft_Height, .ft_Weight, .ft_Eyes_Color, .ft_Hair_Color, .ft_Address, .ft_Donor,
        .ft_Social_Security_Number, .ft_DL_Class, .ft_DL_Endorsed, .ft_DL_Restriction_Code,
        .ft_DL_Under_21_Date, .ft_Authority, .ft_Surname_And_Given_Names, .ft_Nationality_Code,
        .ft_Passport_Number, .ft_Invitation_Number, .ft_Visa_ID, .ft_Visa_Class, .ft_Visa_SubClass,
        .ft_MRZ_String1, .ft_MRZ_String2, .ft_MRZ_String3, .ft_MRZ_Type, .ft_Optional_Data,
        .ft_Document_Class_Name, .ft_Issuing_State_Name, .ft_Place_of_Issue, .ft_Document_Number_Checksum,
        .ft_Date_of_Birth_Checksum, .ft_Date_of_Expiry_Checksum, .ft_Personal_Number_Checksum,
        .ft_FinalChecksum, .ft_Passport_Number_Checksum, .ft_Invitation_Number_Checksum, .ft_Visa_ID_Checksum,
        .ft_Surname_And_Given_Names_Checksum, .ft_Visa_Valid_Until_Checksum, .ft_Other, .ft_MRZ_Strings,
        .ft_Name_Suffix, .ft_Name_Prefix, .ft_Date_of_Issue_Checksum, .ft_Date_of_Issue_CheckDigit,
        .ft_Document_Series, .ft_RegCert_RegNumber, .ft_RegCert_CarModel, .ft_RegCert_CarColor,
        .ft_RegCert_BodyNumber, .ft_RegCert_CarType, .ft_RegCert_MaxWeight, .ft_Reg_Cert_Weight,
        .ft_Address_Area, .ft_Address_State, .ft_Address_Building, .ft_Address_House, .ft_Address_Flat,
        .ft_Place_of_Registration, .ft_Date_of_Registration, .ft_Resident_From, .ft_Resident_Until,
        .ft_Authority_Code, .ft_Place_of_Birth_Area, .ft_Place_of_Birth_StateCode, .ft_Address_Street,
        .ft_Address_City, .ft_Address_Jurisdiction_Code, .ft_Address_Postal_Code,
        .ft_Document_Number_CheckDigit, .ft_Date_of_Birth_CheckDigit, .ft_Date_of_Expiry_CheckDigit,
        .ft_Personal_Number_CheckDigit, .ft_FinalCheckDigit, .ft_Passport_Number_CheckDigit,
        .ft_Invitation_Number_CheckDigit, .ft_Visa_ID_CheckDigit, .ft_Surname_And_Given_Names_CheckDigit,
        .ft_Visa_Valid_Until_CheckDigit, .ft_Permit_DL_Class, .ft_Permit_Date_of_Expiry,
        .ft_Permit_Identifier, .ft_Permit_Date_of_Issue, .ft_Permit_Restriction_Code,
        .ft_Permit_Endorsed, .ft_Issue_Timestamp, .ft_Number_of_Duplicates,
        .ft_Medical_Indicator_Codes, .ft_Non_Resident_Indicator, .ft_Visa_Type,
        .ft_Visa_Valid_From, .ft_Visa_Valid_Until, .ft_Duration_of_Stay, .ft_Number_of_Entries,
        .ft_Day, .ft_Month, .ft_Year, .ft_Unique_Customer_Identifier, .ft_Commercial_Vehicle_Codes,
        .ft_AKA_Date_of_Birth, .ft_AKA_Social_Security_Number, .ft_AKA_Surname, .ft_AKA_Given_Names,
        .ft_AKA_Name_Suffix, .ft_AKA_Name_Prefix, .ft_Mailing_Address_Street, .ft_Mailing_Address_City,
        .ft_Mailing_Address_Jurisdiction_Code, .ft_Mailing_Address_Postal_Code, .ft_Audit_Information,
        .ft_Inventory_Number, .ft_Race_Ethnicity, .ft_Jurisdiction_Vehicle_Class,
        .ft_Jurisdiction_Endorsement_Code, .ft_Jurisdiction_Restriction_Code, .ft_Family_Name,
        .ft_Given_Names_RUS, .ft_Visa_ID_RUS, .ft_Fathers_Name, .ft_Fathers_Name_RUS,
        .ft_Surname_And_Given_Names_RUS, .ft_Place_Of_Birth_RUS, .ft_Authority_RUS,
        .ft_Issuing_State_Code_Numeric, .ft_Nationality_Code_Numeric, .ft_Engine_Power, .ft_Engine_Volume,
        .ft_Chassis_Number, .ft_Engine_Number, .ft_Engine_Model, .ft_Vehicle_Category,
        .ft_Identity_Card_Number, .ft_Control_No, .ft_Parrent_s_Given_Names, .ft_Second_Surname,
        .ft_Middle_Name, .ft_RegCert_VIN, .ft_RegCert_VIN_CheckDigit, .ft_RegCert_VIN_Checksum,
        .ft_Line1_CheckDigit, .ft_Line2_CheckDigit, .ft_Line3_CheckDigit, .ft_Line1_Checksum,
        .ft_Line2_Checksum, .ft_Line3_Checksum, .ft_RegCert_RegNumber_CheckDigit,
        .ft_RegCert_RegNumber_Checksum, .ft_RegCert_Vehicle_ITS_Code, .ft_Card_Access_Number,
        .ft_Marital_Status, .ft_Company_Name, .ft_Special_Notes, .ft_Surname_of_Spose, .ft_Tracking_Number,
        .ft_Booklet_Number, .ft_Children, .ft_Copy, .ft_Serial_Number, .ft_Dossier_Number,
        .ft_AKA_Surname_And_Given_Names, .ft_Territorial_Validity, .ft_MRZ_Strings_With_Correct_CheckSums,
        .ft_DL_CDL_Restriction_Code, .ft_DL_Under_18_Date, .ft_DL_Record_Created, .ft_DL_Duplicate_Date,
        .ft_DL_Iss_Type, .ft_Military_Book_Number, .ft_Destination, .ft_Blood_Group, .ft_Sequence_Number,
        .ft_RegCert_BodyType, .ft_RegCert_CarMark, .ft_Transaction_Number, .ft_Age, .ft_Folio_Number,
        .ft_Voter_Key, .ft_Address_Municipality, .ft_Address_Location, .ft_Section, .ft_OCR_Number,
        .ft_Federal_Elections, .ft_Reference_Number, .ft_Optional_Data_Checksum,
        .ft_Optional_Data_CheckDigit, .ft_Visa_Number, .ft_Visa_Number_Checksum,
        .ft_Visa_Number_CheckDigit, .ft_Voter, .ft_Previous_Type, .ft_FieldFromMRZ, .ft_CurrentDate,
        .ft_Status_Date_of_Expiry, .ft_Banknote_Number, .ft_CSC_Code, .ft_Artistic_Name,
        .ft_Academic_Title, .ft_Address_Country, .ft_Address_Zipcode, .ft_EID_Residence_Permit1,
        .ft_EID_Residence_Permit2, .ft_EID_PlaceOfBirth_Street, .ft_EID_PlaceOfBirth_City,
        .ft_EID_PlaceOfBirth_State, .ft_EID_PlaceOfBirth_Country, .ft_EID_PlaceOfBirth_Zipcode,
        .ft_CDL_Class, .ft_DL_Under_19_Date, .ft_Weight_pounds, .ft_Limited_Duration_Document_Indicator,
        .ft_Endorsement_Expiration_Date, .ft_Revision_Date, .ft_Compliance_Type,
        .ft_Family_name_truncation, .ft_First_name_truncation, .ft_Middle_name_truncation, .ft_Exam_Date,
        .ft_Organization, .ft_Department, .ft_Pay_Grade, .ft_Rank, .ft_Benefits_Number,
        .ft_Sponsor_Service, .ft_Sponsor_Status, .ft_Sponsor, .ft_Relationship, .ft_USCIS,
        .ft_Category, .ft_Conditions, .ft_Identifier, .ft_Configuration, .ft_Discretionary_data,
        .ft_Line1_Optional_Data, .ft_Line2_Optional_Data, .ft_Line3_Optional_Data, .ft_EQV_Code,
        .ft_ALT_Code, .ft_Binary_Code, .ft_Pseudo_Code, .ft_Fee, .ft_Stamp_Number, .ft_SBH_SecurityOptions,
        .ft_SBH_IntegrityOptions, .ft_Date_of_Creation, .ft_Validity_Period, .ft_Patron_Header_Version,
        .ft_BDB_Type, .ft_Biometric_Type, .ft_Biometric_Subtype, .ft_Biometric_ProductID,
        .ft_Biometric_Format_Owner, .ft_Biometric_Format_Type, .ft_Phone, .ft_Profession, .ft_Title,
        .ft_Personal_Summary, .ft_Other_Valid_ID, .ft_Custody_Info, .ft_Other_Name, .ft_Observations,
        .ft_Tax, .ft_Date_of_Personalization, .ft_Personalization_SN, .ft_OtherPerson_Name,
        .ft_PersonToNotify_Date_of_Record, .ft_PersonToNotify_Name, .ft_PersonToNotify_Phone,
        .ft_PersonToNotify_Address, .ft_DS_Certificate_Issuer, .ft_DS_Certificate_Subject,
        .ft_DS_Certificate_ValidFrom, .ft_DS_Certificate_ValidTo, .ft_VRC_DataObject_Entry,
        .ft_TypeApprovalNumber, .ft_AdministrativeNumber, .ft_DocumentDiscriminator, .ft_DataDiscriminator,
        .ft_ISO_Issuer_ID_Number, .ft_GNIB_Number, .ft_Dept_Number, .ft_Telex_Code, .ft_Allergies,
        .ft_Sp_Code, .ft_Court_Code, .ft_Cty, .ft_Sponsor_SSN, .ft_DoD_Number, .ft_MC_Novice_Date,
        .ft_DUF_Number, .ft_AGY, .ft_PNR_Code, .ft_From_Airport_Code, .ft_To_Airport_Code,
        .ft_Flight_Number, .ft_Date_of_Flight, .ft_Seat_Number, .ft_Date_of_Issue_Boarding_Pass,
        .ft_CCW_Until, .ft_Reference_Number_Checksum, .ft_Reference_Number_CheckDigit,
        .ft_Room_Number, .ft_Religion, .ft_RemainderTerm, .ft_Electronic_Ticket_Indicator,
        .ft_Compartment_Code, .ft_CheckIn_Sequence_Number, .ft_Airline_Designator_of_boarding_pass_issuer, .ft_Airline_Numeric_Code, .ft_Ticket_Number, .ft_Frequent_Flyer_Airline_Designator,
        .ft_Frequent_Flyer_Number, .ft_Free_Baggage_Allowance, .ft_PDF417Codec,
        .ft_Identity_Card_Number_Checksum, .ft_Identity_Card_Number_CheckDigit, .ft_Veteran,
        .ft_DLClassCode_A1_From, .ft_DLClassCode_A1_To, .ft_DLClassCode_A1_Notes, .ft_DLClassCode_A_From,
        .ft_DLClassCode_A_To, .ft_DLClassCode_A_Notes, .ft_DLClassCode_B_From, .ft_DLClassCode_B_To,
        .ft_DLClassCode_B_Notes, .ft_DLClassCode_C1_From, .ft_DLClassCode_C1_To, .ft_DLClassCode_C1_Notes,
        .ft_DLClassCode_C_From, .ft_DLClassCode_C_To, .ft_DLClassCode_C_Notes, .ft_DLClassCode_D1_From,
        .ft_DLClassCode_D1_To, .ft_DLClassCode_D1_Notes, .ft_DLClassCode_D_From, .ft_DLClassCode_D_To,
        .ft_DLClassCode_D_Notes, .ft_DLClassCode_BE_From, .ft_DLClassCode_BE_To, .ft_DLClassCode_BE_Notes,
        .ft_DLClassCode_C1E_From, .ft_DLClassCode_C1E_To, .ft_DLClassCode_C1E_Notes,
        .ft_DLClassCode_CE_From, .ft_DLClassCode_CE_To, .ft_DLClassCode_CE_Notes,
        .ft_DLClassCode_D1E_From, .ft_DLClassCode_D1E_To, .ft_DLClassCode_D1E_Notes,
        .ft_DLClassCode_DE_From, .ft_DLClassCode_DE_To, .ft_DLClassCode_DE_Notes,
        .ft_DLClassCode_M_From, .ft_DLClassCode_M_To, .ft_DLClassCode_M_Notes,
        .ft_DLClassCode_L_From, .ft_DLClassCode_L_To, .ft_DLClassCode_L_Notes,
        .ft_DLClassCode_T_From, .ft_DLClassCode_T_To, .ft_DLClassCode_T_Notes,
        .ft_DLClassCode_AM_From, .ft_DLClassCode_AM_To, .ft_DLClassCode_AM_Notes,
        .ft_DLClassCode_A2_From, .ft_DLClassCode_A2_To, .ft_DLClassCode_A2_Notes,
        .ft_DLClassCode_B1_From, .ft_DLClassCode_B1_To, .ft_DLClassCode_B1_Notes,
        .ft_Surname_at_Birth, .ft_Civil_Status, .ft_Number_of_Seats, .ft_Number_of_Standing_Places,
        .ft_Max_Speed, .ft_Fuel_Type, .ft_EC_Environmental_Type, .ft_Power_Weight_Ratio,
        .ft_Max_Mass_of_Trailer_Braked, .ft_Max_Mass_of_Trailer_Unbraked, .ft_Transmission_Type,
        .ft_Trailer_Hitch, .ft_Accompanied_by, .ft_Police_District, .ft_First_Issue_Date,
        .ft_Payload_Capacity, .ft_Number_of_Axels, .ft_Permissible_Axle_Load, .ft_Precinct,
        .ft_Invited_by, .ft_Purpose_of_Entry, .ft_Skin_Color, .ft_Complexion, .ft_Airport_From,
        .ft_Airport_To, .ft_Airline_Name, .ft_Airline_Name_Frequent_Flyer, .ft_License_Number,
        .ft_In_Tanks, .ft_Exept_In_Tanks, .ft_Fast_Track, .ft_Owner, .ft_MRZ_Strings_ICAO_RFID,
        .ft_Number_of_Card_Issuance, .ft_Number_of_Card_Issuance_Checksum,
        .ft_Number_of_Card_Issuance_CheckDigit, .ft_Century_Date_of_Birth, .ft_DLClassCode_A3_From,
        .ft_DLClassCode_A3_To, .ft_DLClassCode_A3_Notes, .ft_DLClassCode_C2_From, .ft_DLClassCode_C2_To,
        .ft_DLClassCode_C2_Notes, .ft_DLClassCode_B2_From, .ft_DLClassCode_B2_To, .ft_DLClassCode_B2_Notes,
        .ft_DLClassCode_D2_From, .ft_DLClassCode_D2_To, .ft_DLClassCode_D2_Notes, .ft_DLClassCode_B2E_From,
        .ft_DLClassCode_B2E_To, .ft_DLClassCode_B2E_Notes, .ft_DLClassCode_G_From, .ft_DLClassCode_G_To,
        .ft_DLClassCode_G_Notes, .ft_DLClassCode_J_From, .ft_DLClassCode_J_To, .ft_DLClassCode_J_Notes,
        .ft_DLClassCode_LC_From, .ft_DLClassCode_LC_To, .ft_DLClassCode_LC_Notes, .ft_BankCardNumber,
        .ft_BankCardValidThru, .ft_TaxNumber, .ft_HealthNumber, .ft_GrandfatherName, .ft_Selectee_Indicator,
        .ft_Mother_Surname, .ft_Mother_GivenName, .ft_Father_Surname, .ft_Father_GivenName,
        .ft_Mother_DateOfBirth, .ft_Father_DateOfBirth, .ft_Mother_PersonalNumber,
        .ft_Father_PersonalNumber, .ft_Mother_PlaceOfBirth, .ft_Father_PlaceOfBirth,
        .ft_Mother_CountryOfBirth, .ft_Father_CountryOfBirth, .ft_Date_First_Renewal,
        .ft_Date_Second_Renewal, .ft_PlaceOfExamination, .ft_ApplicationNumber,
        .ft_VoucherNumber, .ft_AuthorizationNumber, .ft_Faculty, .ft_FormOfEducation,
        .ft_DNINumber, .ft_RetirementNumber, .ft_ProfessionalIdNumber, .ft_Age_at_Issue,
        .ft_Years_Since_Issue, .ft_DLClassCode_BTP_From, .ft_DLClassCode_BTP_Notes,
        .ft_DLClassCode_BTP_To, .ft_DLClassCode_C3_From, .ft_DLClassCode_C3_Notes,
        .ft_DLClassCode_C3_To, .ft_DLClassCode_E_From, .ft_DLClassCode_E_Notes,
        .ft_DLClassCode_E_To, .ft_DLClassCode_F_From, .ft_DLClassCode_F_Notes, .ft_DLClassCode_F_To,
        .ft_DLClassCode_FA_From, .ft_DLClassCode_FA_Notes, .ft_DLClassCode_FA_To,
        .ft_DLClassCode_FA1_From, .ft_DLClassCode_FA1_Notes, .ft_DLClassCode_FA1_To,
        .ft_DLClassCode_FB_From, .ft_DLClassCode_FB_Notes, .ft_DLClassCode_FB_To,
        .ft_DLClassCode_G1_From, .ft_DLClassCode_G1_Notes, .ft_DLClassCode_G1_To,
        .ft_DLClassCode_H_From, .ft_DLClassCode_H_Notes, .ft_DLClassCode_H_To,
        .ft_DLClassCode_I_From, .ft_DLClassCode_I_Notes, .ft_DLClassCode_I_To,
        .ft_DLClassCode_K_From, .ft_DLClassCode_K_Notes, .ft_DLClassCode_K_To,
        .ft_DLClassCode_LK_From, .ft_DLClassCode_LK_Notes, .ft_DLClassCode_LK_To,
        .ft_DLClassCode_N_From, .ft_DLClassCode_N_Notes, .ft_DLClassCode_N_To,
        .ft_DLClassCode_S_From, .ft_DLClassCode_S_Notes, .ft_DLClassCode_S_To,
        .ft_DLClassCode_TB_From, .ft_DLClassCode_TB_Notes, .ft_DLClassCode_TB_To,
        .ft_DLClassCode_TM_From, .ft_DLClassCode_TM_Notes, .ft_DLClassCode_TM_To,
        .ft_DLClassCode_TR_From, .ft_DLClassCode_TR_Notes, .ft_DLClassCode_TR_To,
        .ft_DLClassCode_TV_From, .ft_DLClassCode_TV_Notes, .ft_DLClassCode_TV_To,
        .ft_DLClassCode_V_From, .ft_DLClassCode_V_Notes, .ft_DLClassCode_V_To,
        .ft_DLClassCode_W_From, .ft_DLClassCode_W_Notes, .ft_DLClassCode_W_To,
        .ft_URL, .ft_Caliber, .ft_Model, .ft_Make, .ft_NumberOfCylinders,
        .ft_SurnameOfHusbandAfterRegistration, .ft_SurnameOfWifeAfterRegistration,
        .ft_DateOfBirthOfWife, .ft_DateOfBirthOfHusband, .ft_CitizenshipOfFirstPerson,
        .ft_CitizenshipOfSecondPerson, .ft_CVV, .ft_Date_of_Insurance_Expiry,
        .ft_Mortgage_by, .ft_Old_Document_Number, .ft_Old_Date_of_Issue, .ft_Old_Place_of_Issue,
        .ft_DLClassCode_LR_From, .ft_DLClassCode_LR_To, .ft_DLClassCode_LR_Notes,
        .ft_DLClassCode_MR_From, .ft_DLClassCode_MR_To, .ft_DLClassCode_MR_Notes,
        .ft_DLClassCode_HR_From, .ft_DLClassCode_HR_To, .ft_DLClassCode_HR_Notes,
        .ft_DLClassCode_HC_From, .ft_DLClassCode_HC_To, .ft_DLClassCode_HC_Notes,
        .ft_DLClassCode_MC_From, .ft_DLClassCode_MC_To, .ft_DLClassCode_MC_Notes,
        .ft_DLClassCode_RE_From, .ft_DLClassCode_RE_To, .ft_DLClassCode_RE_Notes,
        .ft_DLClassCode_R_From, .ft_DLClassCode_R_To, .ft_DLClassCode_R_Notes,
        .ft_DLClassCode_CA_From, .ft_DLClassCode_CA_To, .ft_DLClassCode_CA_Notes
    ]
}
