import Foundation

/// Peak timer manager.
final class PeakTimerManager {
    private var timer: Timer?
    
    /// Timer thread.
    private lazy var timerThread: DispatchQueue = {
        DispatchQueue(label: "com.fdaAudioPlayerRecorder.timerThread",
                      qos: .background,
                      attributes: .concurrent)
    }()
    
    /// Start the timer.
    /// - Parameter block: the block to execute.
    func start(_ block: @escaping ((Timer) -> Void)) {
        timerThread.async { [weak self] in
            guard let self else { return }
            self.timer = Timer
                .scheduledTimer(withTimeInterval: 0.3,
                                repeats: true,
                                block: block)
            self.timer?.fire()
            
            RunLoop.current.add(self.timer!, forMode: .common)
            RunLoop.current.run()
        }
    }
    
    /// Stop the timer.
    func stop() {
        timerThread.async { [weak self] in
            self?.timer?.invalidate()
            self?.timer = nil
        }
    }
}
