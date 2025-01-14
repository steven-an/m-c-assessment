# This class will schedule your meetings in a 9-5 working hours
class MeetingsScheduler
  attr_reader :onsite_meetings, :offsite_meetings, :scheduled_meetings
  attr_accessor :start_time

  HOURS_SPAN = 8

  def initialize(meetings)
    raise 'Invalid argument structure.' unless meetings.is_a? Array

    @onsite_meetings = meetings.select { |m| m[:type] == :onsite }
    @offsite_meetings = meetings.select { |m| m[:type] == :offsite }
    ctime = Time.now
    @start_time = Time.new(ctime.year, ctime.month, ctime.day, 9, 0, 0) # 9 AM time object initialized
    @scheduled_meetings = []
  end

  def schedule
    unless can_fit?
      puts 'No, can’t fit.'
      return
    end

    onsite_meetings.each { |meeting| assign_slot meeting }

    offsite_meetings.each do |meeting|
      @start_time += 1800 # pad 30 minutes for offsite meetings
      assign_slot meeting
    end

    puts 'Yes, can fit. One possible solution would be:'
    @scheduled_meetings.each { |m| puts m  }
  end

  def can_fit?
    total_hours = 0
    onsite_meetings.each { |m| total_hours += m[:duration] }
    offsite_meetings.each { |m| total_hours += m[:duration] + 0.5 }

    total_hours <= HOURS_SPAN
  end

  private

  def format(time)
    time.strftime("%l:%M %p")
  end

  def assign_slot(meeting)
    end_time = start_time + ( meeting[:duration] * 3600 )
    @scheduled_meetings << "#{format(start_time)} - #{format(end_time)} - #{meeting[:name]}"
    @start_time = end_time
  end
end
