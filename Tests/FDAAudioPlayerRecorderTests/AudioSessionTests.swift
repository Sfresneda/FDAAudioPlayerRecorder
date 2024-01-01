import XCTest
@testable import FDAAudioPlayerRecorder

final class AudioSessionTests: XCTestCase {
    var sut: _AudioSession!
    var audioSessionSpy: AudioSessionSpy!

    override func setUpWithError() throws {
        sut = _AudioSession()
        audioSessionSpy = AudioSessionSpy()
    }

    override func tearDownWithError() throws {
        sut = nil
        audioSessionSpy = nil
    }

    func test_start_shouldSucceed() throws {
        // When
        try sut.start(session: audioSessionSpy)

        // Then
        XCTAssertTrue(audioSessionSpy.setCategorySpy)
        XCTAssertTrue(audioSessionSpy.setActiveSpy)
    }

    func test_stop_shouldSucceed() throws {
        // When
        try sut.start(session: audioSessionSpy)
        try sut.stop()

        // Then
        XCTAssertFalse(audioSessionSpy.setActiveSpy)
    }

    func test_setAudioOutput_shouldSucceed() throws {
        // When
        try sut.start(session: audioSessionSpy)
        try sut.setAudioOutput(false)

        // Then
        XCTAssertTrue(audioSessionSpy.overrideOutputAudioPortSpy)
    }

    func test_stop_withoutStartBefore_shouldFail() throws {
        // When
        try sut.stop()

        // Then
        XCTAssertFalse(audioSessionSpy.setActiveSpy)
    }

    func test_setAudioOutput_withoutStartBefore_shouldFail() throws {
        // When
        try sut.setAudioOutput(false)

        // Then
        XCTAssertFalse(audioSessionSpy.overrideOutputAudioPortSpy)
    }

}
