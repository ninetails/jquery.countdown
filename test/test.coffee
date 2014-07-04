# dependencies
expect = require 'expect.js'
countdown = $.Countdown
InvalidDateError = countdown.InvalidDateError
parse_date_string = countdown.parse_date_string
parse_date = countdown.parse_date

describe 'countdown', () ->
  describe '#parse_date_string()', () ->
    it 'should accept a full iso 8601 string with America/Sao_Paulo timezone', () ->
      current = parse_date_string '2014-06-30T01:02:30.010-0300'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 1
      expect(current.getMinutes()).to.be 2
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 10

      current = parse_date_string '2014-06-30T01:02:30-03:00'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 1
      expect(current.getMinutes()).to.be 2
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 0
      return

    it 'should accept a full iso 8601 string with UTC timezone', () ->
      current = parse_date_string '2014-06-30T19:15:30.020Z'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 16
      expect(current.getMinutes()).to.be 15
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 20
      return

    it 'should accept a full iso 8601 string with PST timezone', () ->
      current = parse_date_string '2014-06-30T13:40:30.015-07:00'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 17
      expect(current.getMinutes()).to.be 40
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 15
      return

    it 'should assume default timezone offset when timezone is ommited', () ->
      current = parse_date_string '2014-06-30T22:15:30.000'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 22
      expect(current.getMinutes()).to.be 15
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 0
      return

    it 'should accept with a space on "T" reserved place', () ->
      current = parse_date_string '2014-06-30 22:15:30'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 22
      expect(current.getMinutes()).to.be 15
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 0
      return

    it 'should assume midnight when not pass time', () ->
      current = parse_date_string '2014-06-30'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0
      return

    it 'should accept brazillian date format', () ->
      current = parse_date_string '01/07/2014'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0
      return

    it 'should receive incomplete dates too (but giving 4 year length)', () ->
      current = parse_date_string '2014-7-1'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0

      current = parse_date_string '2014-7-1 2:7:5.1'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 2
      expect(current.getMinutes()).to.be 7
      expect(current.getSeconds()).to.be 5
      expect(current.getMilliseconds()).to.be 1
      return

    it 'should receive bizarre dates satisfying last test', () ->
      current = parse_date_string '2014-7-1 2:7:5.1'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 2
      expect(current.getMinutes()).to.be 7
      expect(current.getSeconds()).to.be 5
      expect(current.getMilliseconds()).to.be 1
      return

    it 'should receive incomplete dates too in brazillian format', () ->
      current = parse_date_string '1/7/2014'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0

      current = parse_date_string '1/7/2014 2h7'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 2
      expect(current.getMinutes()).to.be 7
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0

      current = parse_date_string '1/7/2014 2h 7min 5s 3ms'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 2
      expect(current.getMinutes()).to.be 7
      expect(current.getSeconds()).to.be 5
      expect(current.getMilliseconds()).to.be 3
      return
    return
  describe '#parse_date()', () ->
    it 'should return Date when pass Date', () ->
      now = new Date
      expect(parse_date( now )).to.be now
      return

    it 'should return Date for valid date string', () ->
      current = parse_date '2014-06-30'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0
      return

    it 'should return valid dates for invalid dates but valid on js creation', () ->
      current = parse_date '2014-06-31'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0

      current = parse_date '2014-02-29'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 2
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0

      current = parse_date '2014-12-32'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 0
      expect(current.getFullYear()).to.be 2015
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0
      return

    it 'should return date with a complete iso 8601 string', () ->
      current = parse_date '2014-06-30T01:15:30.500Z'
      expect(current.getDate()).to.be 29
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 22
      expect(current.getMinutes()).to.be 15
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 500
      return

    it 'should accept a full iso 8601 string with PST timezone', () ->
      current = parse_date '2014-06-30T13:40:30.015-07:00'
      expect(current.getDate()).to.be 30
      expect(current.getMonth()).to.be 5
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 17
      expect(current.getMinutes()).to.be 40
      expect(current.getSeconds()).to.be 30
      expect(current.getMilliseconds()).to.be 15
      return

    it 'should accept brazillian date format', () ->
      current = parse_date '01/07/2014'
      expect(current.getDate()).to.be 1
      expect(current.getMonth()).to.be 6
      expect(current.getFullYear()).to.be 2014
      expect(current.getHours()).to.be 0
      expect(current.getMinutes()).to.be 0
      expect(current.getSeconds()).to.be 0
      expect(current.getMilliseconds()).to.be 0
      return

    return
  describe '#static_countdown', () ->
    it 'should warn that the first argument is required', () ->
      expect(countdown).withArgs().to.throwException /first argument is required/i
      return

    # it 'should warn if first argument is not datable', () ->
    #   expect(countdown).withArgs('I am a string').to.throwException InvalidDateError
    #   return

    # it 'should warn if second argument is not datable', () ->
    #   expect(countdown).withArgs('2015-01-01', 'I am a string').to.throwException InvalidDateError
    #   return

    # it 'should throw exception when any of initial 2 arguments is not a date', () ->
    #   date = parse_date '2014-07-01'
    #   expect(countdown(date1, date2)).to.throwException('Invalid range.');
    #   return

    return
  return
