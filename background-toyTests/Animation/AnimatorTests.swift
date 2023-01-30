//
//  AnimatorTests.swift
//  background-toyTests
//
//  Created by 윤하연 on 2023/01/31.
//

import Foundation
import XCTest

@testable import background_toy

final class AnimatorTests: XCTest {
    func testNewAnimatorFromJSONString_WorksFine() {
        // (
        //      input JSON String,
        //      exepcted animation clip keys
        // )
        let cases = [
            (
                """
                {
                    "spriteFolderPath": "default",
                    "clips": {
                        "idle": {
                            "count": 3,
                            "playType": "pingpong"
                        },
                        "walk": {
                            "count": 7,
                            "playType": "restart"
                        },
                        "grab": {
                            "count": 3,
                            "playType": "pingpong"
                        },
                        "touch": {
                            "count": 2,
                            "playType": "restart"
                        },
                        "playingcursor": {
                            "count": 6,
                            "playType": "restart"
                        }
                    }
                }
                """,
                ["idle", "walk", "grab", "touch", "playingcursor"]
            ),
            (
                """
                {
                    "spriteFolderPath": "default",
                    "clips": {
                        "idle": {
                            "count": 1,
                            "playType": "pingpong"
                        },
                        "walk": {
                            "count": 1,
                            "playType": "pingpong"
                        },
                        "grab": {
                            "count": 12,
                            "playType": "pingpong"
                        },
                        "touch": {
                            "count": 7,
                            "playType": "pingpong"
                        },
                        "playingcursor": {
                            "count": 4,
                            "playType": "pingpong"
                        }
                    }
                }
                """,
                ["idle", "walk", "grab", "touch", "playingcursor"]
            ),
        ]

        cases.forEach({
            do {
                let a = try newAnimatorFromJSONString($0)
                $1.forEach({
                    XCTAssertNotNil(a.getClip($0))
                })
            } catch {
                XCTFail("Fn should not throw any errors")
            }
        })
    }
}
