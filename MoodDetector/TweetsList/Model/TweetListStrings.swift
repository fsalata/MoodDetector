//
//  TweetListStrings.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 21/04/21.
//

import Foundation

struct TweetListStrings {
    static let title = "tweets"
    
    struct NotFoundError {
        static let message = "Não foram encontrados resultados"
        static let buttonTitle = "Voltar"
    }
    
    struct ServiceError {
        static let message = "Ocorreu um erro com a sua solicitação"
        static let buttonTitle = "Tentar novamente"
    }
}
