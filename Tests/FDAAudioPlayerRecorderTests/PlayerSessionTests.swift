import XCTest
@testable import FDAAudioPlayerRecorder

final class PlayerSessionTests: XCTestCase {
    var sut: _PlayerSession!

    override func setUpWithError() throws {
        sut = _PlayerSession()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

}
