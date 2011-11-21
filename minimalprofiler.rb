#***********************************************************************************
#
# The simplest useful profiler. See the end of the file for usage examples.
#
# (C) Pete Warden <pete@jetpac.com>
#
#***********************************************************************************

$profiler_start_time = {}
$profiler_total_time = {}

class MinimalProfiler

  def self.start(label)

    if label == 'MAIN'
      $profiler_start_time = {}
      $profiler_total_time = {}
    end

    $profiler_start_time[label] = Time.now

  end

  def self.stop(label, do_print=false)

    if !$profiler_start_time[label]
      return nil
    end

    end_time = Time.now
    duration = end_time-$profiler_start_time[label]
    if !$profiler_total_time[label]
      $profiler_total_time[label] = 0
    end
    $profiler_total_time[label] += duration;

    if do_print
      $stderr.puts "#{label}: Took #{duration.to_s} seconds"
    end
    
    if label == 'MAIN'
      total_time = $profiler_total_time['MAIN']
      $stderr.puts "Total time #{total_time.to_s} seconds"
      $profiler_total_time.each do |name, current_total|
        if name != 'MAIN'
          $stderr.puts "#{((current_total*100)/total_time).floor}% - #{name} (#{current_total.to_s} seconds)"
        end
      end 
    
    end
    
    return duration

  end
  
end

if __FILE__ == $0
  
  MinimalProfiler.start('MAIN')
  
  MinimalProfiler.start('Doing something')
  sleep 2
  MinimalProfiler.stop('Doing something')
  
  MinimalProfiler.start('Something else')
  sleep 1
  MinimalProfiler.stop('Something else')

  MinimalProfiler.stop('MAIN')
  
end
