import AVFAudio
import XCTest
@testable import FDAAudioPlayerRecorder

final class MicrophonePermissionTests: XCTestCase {
    var sut: _MicrophonePermission!
    var sessionMock: AudioSessionMock!

    override func setUpWithError() throws {
        sessionMock = AudioSessionMock()
        sut = _MicrophonePermission(instance: sessionMock)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_shared_shouldReturnExpectedInstance() {
        if #available(iOS 17.0, *) {
            // Given
            let sut = _MicrophonePermission.shared

            // When
            let instance = sut.microphoneInstance

            // Then
            XCTAssertNotNil(instance as? AVAudioApplication)

        } else {
            // Given
            let sut = _MicrophonePermission.shared

            // When
            let instance = sut.microphoneInstance

            // Then
            XCTAssertNotNil(instance as? AVAudioSession)
        }
    }

    func test_status_defaultShouldReturnUnknown() {
        // When
        let result = sut.status

        // Then
        XCTAssertEqual(result, .unknown)
    }

    func test_arePermissionGranteed_defaultShouldReturnFalse() {
        // When
        let result = sut.arePermissionGranteed

        // Then
        XCTAssertFalse(result)
    }

    func test_askForPermission_defaultShouldReturnFalse() async {
        // When
        let result = await sut.askForPermission()

        // Then
        XCTAssertFalse(result)
    }

    func test_status_permissionGranteed_ShouldReturnGranteed() {
        // Given
        sessionMock._permission = .granted

        // When
        let result = sut.status

        // Then
        XCTAssertEqual(result, .granted)
    }

    func test_arePermissionGranteed_permissionGranteed_ShouldReturntrue() {
        // Given
        sessionMock._permission = .granted

        // When
        let result = sut.arePermissionGranteed

        // Then
        XCTAssertTrue(result)
    }

    func test_askForPermission_permissionGranteed_ShouldReturnFalse() async {
        // Given
        sessionMock._permission = .granted
        // When
        let result = await sut.askForPermission()

        // Then
        XCTAssertTrue(result)
    }
}
