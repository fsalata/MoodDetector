//
//  SentimentMocks.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 17/04/21.
//

import Foundation

func mockHappySentimentResponse() -> Data {
    return  """
            {
              "documentSentiment" : {
                "magnitude" : 1.3999999999999999,
                "score" : 0.69999999999999996
              },
              "language" : "en"
            }
            """.data(using: .utf8)!
}

func mockNeutralSentimentResponse() -> Data {
    return  """
            {
              "documentSentiment" : {
                "magnitude" : 1.3999999999999999,
                "score" : 0.0
              },
              "language" : "en"
            }
            """.data(using: .utf8)!
}

func mockSadSentimentResponse() -> Data {
    return  """
            {
              "documentSentiment" : {
                "magnitude" : 1.3999999999999999,
                "score" : -0.899999999999
              },
              "language" : "en"
            }
            """.data(using: .utf8)!
}

func mockSentimentPayload() -> Data {
    return  """
            {
              "document" : {
                "type" : "PLAIN_TEXT",
                "content" : "Wishing a safe and peaceful month of Ramadan to all those observing around the world. Ramadan Mubarak!"
              },
              "encodingType" : "UTF8"
            }
            """.data(using: .utf8)!
}
