//
//  MacroExecutorTests.swift
//  background-toyTests
//
//  Created by 윤하연 on 2023/01/30.
//

import Foundation
import XCTest

@testable import background_toy

final class MacroExecutorTests: XCTest {
    func testNewMacroExecutorFromJSONString_WorksFine() {
        // (
        //      input JSON String,
        //      exepcted macro keys
        // )
        let cases = [
            (
                "{}",
                []
            ),
            (
                """
                {
                    "macro1": [
                        {
                            "type": "type1",
                            "payload": "Sample Payload1",
                        }
                    ],
                    "macro2": [
                        {
                            "type": "type2",
                            "payload": "Sample Payload2"
                        },
                        {
                            "type": "type3",
                            "payload": "Sample Payload3"
                        }
                    ],
                    "macro3": []
                }
                """,
                ["macro1", "macro2", "macro3"]
            ),
        ]

        cases.forEach {
            do {
                let e = try newMacroExecutorFromJSONString($0)
                $1.forEach {
                    XCTAssertNotNil(e.getMacro($0))
                }
            } catch {
                XCTFail("Fn should not throw any errors")
            }
        }
    }
}
