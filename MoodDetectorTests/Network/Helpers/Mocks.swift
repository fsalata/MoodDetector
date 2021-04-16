//
//  APIClientTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import Foundation

func mockTweetResponse() -> Data {
    return  """
            {
              "meta" : {
                "newest_id" : "1382719176096116747",
                "oldest_id" : "1381786256405721090",
                "result_count" : 2
              },
              "data" : [
                {
                  "id" : "1382719176096116747",
                  "text" : "Apple is proud to be carbon neutral &amp; by 2030 our products and manufacturing will be too. We take a new step today with a $200M fund to invest in working forests, one of nature’s best tools to remove carbon.🌳🌎 "
                },
                {
                  "id" : "1381786256405721090",
                  "text" : "Wishing a safe and peaceful month of Ramadan to all those observing around the world. Ramadan Mubarak!"
                }
              ]
            }
           """.data(using: .utf8)!
}

func mockSentimentResponse() -> Data? {
    return  """
            {
              "documentSentiment" : {
                "magnitude" : 1.3999999999999999,
                "score" : 0.69999999999999996
              },
              "sentences" : [
                {
                  "text" : {
                    "content" : "Wishing a safe and peaceful month of Ramadan to all those observing around the world.",
                    "beginOffset" : 0
                  },
                  "sentiment" : {
                    "magnitude" : 0.59999999999999998,
                    "score" : 0.59999999999999998
                  }
                },
                {
                  "text" : {
                    "content" : "Ramadan Mubarak!",
                    "beginOffset" : 86
                  },
                  "sentiment" : {
                    "magnitude" : 0.69999999999999996,
                    "score" : 0.69999999999999996
                  }
                }
              ],
              "language" : "en"
            }
            """.data(using: .utf8)!
}

func mockSentimentPayload() -> Data? {
    return  """
            {
              "document" : {
                "type" : "PLAIN_TEXT",
                "content" : "Wishing a safe and peaceful month of Ramadan to all those observing around the world. Ramadan Mubarak!"
              },
              "encodingType" : "UTF8"
            }
            """.data(using: .utf8)
}



