//
//  LCID+Extensions.swift
//  DocumentReader-Swift
//
//  Created by Dmitry Evglevsky on 11.02.21.
//  Copyright © 2021 Regula. All rights reserved.
//

import DocumentReader

extension LCID {
    var stringValue: String {
        switch self {
        case .latin:
            return ".latin"
        case .afrikaans:
            return ".afrikaans"
        case .albanian:
            return ".albanian"
        case .arabicAlgeria:
            return ".arabicAlgeria"
        case .arabicBahrain:
            return ".arabicBahrain"
        case .arabicEgypt:
            return ".arabicEgypt"
        case .arabicIraq:
            return ".arabicIraq"
        case .arabicJordan:
            return ".arabicJordan"
        case .arabicKuwait:
            return ".arabicKuwait"
        case .arabicLebanon:
            return ".arabicLebanon"
        case .arabicLibya:
            return ".arabicLibya"
        case .arabicMorocco:
            return ".arabicMorocco"
        case .arabicOman:
            return ".arabicOman"
        case .arabicQatar:
            return ".arabicQatar"
        case .arabicSaudiArabia:
            return ".arabicSaudiArabia"
        case .arabicSyria:
            return ".arabicSyria"
        case .arabicTunisia:
            return ".arabicTunisia"
        case .arabicUAE:
            return ".arabicUAE"
        case .arabicYemen:
            return ".arabicYemen"
        case .arabicArmenian:
            return ".arabicArmenian"
        case .azeriCyrillic:
            return ".azeriCyrillic"
        case .azeriLatin:
            return ".azeriLatin"
        case .basque:
            return ".basque"
        case .belarusian:
            return ".belarusian"
        case .bulgarian:
            return ".bulgarian"
        case .catalan:
            return ".catalan"
        case .chineseHongKongSAR:
            return ".chineseHongKongSAR"
        case .chineseMacaoSAR:
            return ".chineseMacaoSAR"
        case .chinese:
            return ".chinese"
        case .chineseSingapore:
            return ".chineseSingapore"
        case .chineseTaiwan:
            return ".chineseTaiwan"
        case .croatian:
            return ".croatian"
        case .czech:
            return ".czech"
        case .danish:
            return ".danish"
        case .divehi:
            return ".divehi"
        case .dutchBelgium:
            return ".dutchBelgium"
        case .dutchNetherlands:
            return ".dutchNetherlands"
        case .englishAustralia:
            return ".englishAustralia"
        case .englishBelize:
            return ".englishBelize"
        case .englishCanada:
            return ".englishCanada"
        case .englishCaribbean:
            return ".englishCaribbean"
        case .englishIreland:
            return ".englishIreland"
        case .englishJamaica:
            return ".englishJamaica"
        case .englishNewZealand:
            return ".englishNewZealand"
        case .englishPhilippines:
            return ".englishPhilippines"
        case .englishSouthAfrica:
            return ".englishSouthAfrica"
        case .englishTrinidad:
            return ".englishTrinidad"
        case .englishUnitedKingdom:
            return ".englishUnitedKingdom"
        case .englishUnitedStates:
            return ".englishUnitedStates"
        case .englishZimbabwe:
            return ".englishZimbabwe"
        case .estonian:
            return ".estonian"
        case .faroese:
            return ".faroese"
        case .farsi:
            return ".farsi"
        case .finnish:
            return ".finnish"
        case .frenchBelgium:
            return ".frenchBelgium"
        case .frenchCanada:
            return ".frenchCanada"
        case .frenchFrance:
            return ".frenchFrance"
        case .frenchLuxembourg:
            return ".frenchLuxembourg"
        case .frenchMonaco:
            return ".frenchMonaco"
        case .frenchSwitzerland:
            return ".frenchSwitzerland"
        case .fyroMacedonian:
            return ".fyroMacedonian"
        case .galician:
            return ".galician"
        case .georgian:
            return ".georgian"
        case .germanAustria:
            return ".germanAustria"
        case .germanGermany:
            return ".germanGermany"
        case .germanLiechtenstein:
            return ".germanLiechtenstein"
        case .germanLuxembourg:
            return ".germanLuxembourg"
        case .germanSwitzerland:
            return ".germanSwitzerland"
        case .greek:
            return ".greek"
        case .gujarati:
            return ".gujarati"
        case .hebrew:
            return ".hebrew"
        case .hindiIndia:
            return ".hindiIndia"
        case .hungarian:
            return ".hungarian"
        case .icelandic:
            return ".icelandic"
        case .indonesian:
            return ".indonesian"
        case .italianItaly:
            return ".italianItaly"
        case .italianSwitzerland:
            return ".italianSwitzerland"
        case .japanese:
            return ".japanese"
        case .kannada:
            return ".kannada"
        case .kazakh:
            return ".kazakh"
        case .konkani:
            return ".konkani"
        case .korean:
            return ".korean"
        case .kyrgyzCyrillic:
            return ".kyrgyzCyrillic"
        case .latvian:
            return ".latvian"
        case .lithuanian:
            return ".lithuanian"
        case .malayBruneiDarussalam:
            return ".malayBruneiDarussalam"
        case .marathi:
            return ".marathi"
        case .malayMalaysia:
            return ".malayMalaysia"
        case .mongolianCyrillic:
            return ".mongolianCyrillic"
        case .norwegianBokmal:
            return ".norwegianBokmal"
        case .norwegianNynorsk:
            return ".norwegianNynorsk"
        case .polish:
            return ".polish"
        case .portugueseBrazil:
            return ".portugueseBrazil"
        case .portuguesePortugal:
            return ".portuguesePortugal"
        case .punjabi:
            return ".punjabi"
        case .rhaetoRomanic:
            return ".rhaetoRomanic"
        case .romanian:
            return ".romanian"
        case .russian:
            return ".russian"
        case .sanskrit:
            return ".sanskrit"
        case .serbianCyrillic:
            return ".serbianCyrillic"
        case .serbianLatin:
            return ".serbianLatin"
        case .slovak:
            return ".slovak"
        case .slovenian:
            return ".slovenian"
        case .spanishArgentina:
            return ".spanishArgentina"
        case .spanishBolivia:
            return ".spanishBolivia"
        case .spanishChile:
            return ".spanishChile"
        case .spanishColombia:
            return ".spanishColombia"
        case .spanishCostaRica:
            return ".spanishCostaRica"
        case .spanishDominicanRepublic:
            return ".spanishDominicanRepublic"
        case .spanishEcuador:
            return ".spanishEcuador"
        case .spanishElSalvador:
            return ".spanishElSalvador"
        case .spanishGuatemala:
            return ".spanishGuatemala"
        case .spanishHonduras:
            return ".spanishHonduras"
        case .spanishInternationalSort:
            return ".spanishInternationalSort"
        case .spanishMexico:
            return ".spanishMexico"
        case .spanishNicaragua:
            return ".spanishNicaragua"
        case .spanishPanama:
            return ".spanishPanama"
        case .spanishParaguay:
            return ".spanishParaguay"
        case .spanishPeru:
            return ".spanishPeru"
        case .spanishPuertoRico:
            return ".spanishPuertoRico"
        case .spanishTraditionalSort:
            return ".spanishTraditionalSort"
        case .spanishUruguay:
            return ".spanishUruguay"
        case .spanishVenezuela:
            return ".spanishVenezuela"
        case .swahili:
            return ".swahili"
        case .swedish:
            return ".swedish"
        case .swedishFinland:
            return ".swedishFinland"
        case .syriac:
            return ".syriac"
        case .tamil:
            return ".tamil"
        case .tatar:
            return ".tatar"
        case .telugu:
            return ".telugu"
        case .thaiThailand:
            return ".thaiThailand"
        case .turkish:
            return ".turkish"
        case .ukrainian:
            return ".ukrainian"
        case .urdu:
            return ".urdu"
        case .uzbekCyrillic:
            return ".uzbekCyrillic"
        case .uzbekLatin:
            return ".uzbekLatin"
        case .vietnamese:
            return ".vietnamese"
        case .tajikCyrillic:
            return ".tajikCyrillic"
        case .turkmen:
            return ".turkmen"
        case .ctcSimplified:
            return ".ctcSimplified"
        case .ctcTraditional:
            return ".ctcTraditional"
        case .custom:
            return ".custom"
        @unknown default:
            return ""
        }
    }
}

extension LCID {
    static var allCases: [LCID] = [
        .latin, .afrikaans, .albanian, .arabicAlgeria, .arabicBahrain, .arabicEgypt,
        .arabicIraq, .arabicJordan, .arabicKuwait, .arabicLebanon, .arabicLibya,
        .arabicMorocco, .arabicOman, .arabicQatar, .arabicSaudiArabia, .arabicSyria,
        .arabicTunisia, .arabicUAE, .arabicYemen, .arabicArmenian, .azeriCyrillic,
        .azeriLatin, .basque, .belarusian, .bulgarian, .catalan, .chineseHongKongSAR,
        .chineseMacaoSAR, .chinese, .chineseSingapore, .chineseTaiwan, .croatian, .czech,
        .danish, .divehi, .dutchBelgium, .dutchNetherlands, .englishAustralia, .englishBelize,
        .englishCanada, .englishCaribbean, .englishIreland, .englishJamaica, .englishNewZealand,
        .englishPhilippines, .englishSouthAfrica, .englishTrinidad, .englishUnitedKingdom,
        .englishUnitedStates, .englishZimbabwe, .estonian, .faroese, .farsi, .finnish,
        .frenchBelgium, .frenchCanada, .frenchFrance, .frenchLuxembourg, .frenchMonaco,
        .frenchSwitzerland, .fyroMacedonian, .galician, .georgian, .germanAustria,
        .germanGermany, .germanLiechtenstein, .germanLuxembourg, .germanSwitzerland,
        .greek, .gujarati, .hebrew, .hindiIndia, .hungarian, .icelandic, .indonesian,
        .italianItaly, .italianSwitzerland, .japanese, .kannada, .kazakh, .konkani, .korean,
        .kyrgyzCyrillic, .latvian, .lithuanian, .malayBruneiDarussalam, .marathi, .malayMalaysia,
        .mongolianCyrillic, .norwegianBokmal, .norwegianNynorsk, .polish, .portugueseBrazil,
        .portuguesePortugal, .punjabi, .rhaetoRomanic, .romanian, .russian, .sanskrit,
        .serbianCyrillic, .serbianLatin, .slovak, .slovenian, .spanishArgentina, .spanishBolivia,
        .spanishChile, .spanishColombia, .spanishCostaRica, .spanishDominicanRepublic,
        .spanishEcuador, .spanishElSalvador, .spanishGuatemala, .spanishHonduras,
        .spanishInternationalSort, .spanishMexico, .spanishNicaragua, .spanishPanama,
        .spanishParaguay, .spanishPeru, .spanishPuertoRico, .spanishTraditionalSort,
        .spanishUruguay, .spanishVenezuela, .swahili, .swedish, .swedishFinland, .syriac,
        .tamil, .tatar, .telugu, .thaiThailand, .turkish, .ukrainian, .urdu, .uzbekCyrillic,
        .uzbekLatin, .vietnamese, .tajikCyrillic, .turkmen, .ctcSimplified, .ctcTraditional, .custom
    ]
}
