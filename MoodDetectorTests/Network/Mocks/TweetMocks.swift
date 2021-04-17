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

func mockNoTweetsResponse() -> Data {
    return  """
            {
                "meta" : {
                    "result_count" : 0
                }
            }
            """.data(using: .utf8)!
}

func mockEmptyResponse() -> Data {
    return  """
            {
              "meta" : nil,
              "data" : [
                {
                  "id" : nil,
                  "text" : "mock"
                }
              ]
            }
            """.data(using: .utf8)!
}




