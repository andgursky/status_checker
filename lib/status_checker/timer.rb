module StatusChecker
  class Timer
    def initialize(interval)
      raise ArgumentError, "Illegal interval" if interval < 0
      extend MonitorMixin
      @run = nil
      @th = nil
      @delay = interval
    end

    def start(&handler)
      @run = true
      @th = Thread.new do
        t = Time.now
        while run?
          t += @delay
          (handler.call rescue nil) and
            sleep(t - Time.now) rescue nil
        end
      end
    end

    def stop
      synchronize do
        @run = false
      end
      @th.join
    end

    private

    def run?
      synchronize do
        @run
      end
    end
  end
end
