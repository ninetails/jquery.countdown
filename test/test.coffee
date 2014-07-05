# dependencies
expect = require 'expect.js'
countdown = $.Countdown
InvalidDateError = countdown.InvalidDateError
parse_date_string = countdown.parse_date_string
parse_date = countdown.parse_date
get_message = countdown.get_message
date_diff = countdown.date_diff

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
  describe '#get_message', () ->
    it 'should return only number if message is not passed', () ->
      expect(get_message(1)).to.be '1'
      return

    it 'should return "1 valor" if is passed 1 and message.singular = valor', () ->
      expect(get_message(1, {singular: '% valor', plural: '% valores'})).to.be '1 valor'
      return

    it 'should return "2 valor" if is passed 1 and message.plural = valores', () ->
      expect(get_message(2, {singular: '% valor', plural: '% valores'})).to.be '2 valores'
      return

    it 'should return "Falta 1 valor" if is passed 1 and message.singular = valor and prefix.singular = "Falta"', () ->
      expect(get_message(1, {singular: '% valor', plural: '% valores'}, {singular: 'Falta %', plural: 'Falta %'})).to.be 'Falta 1 valor'
      return

    it 'should return "Faltam 2 valor" if is passed 1 and message.plural = valores and prefix.plural = "Faltam"', () ->
      expect(get_message(2, {singular: '% valor', plural: '% valores'}, {singular: 'Falta %', plural: 'Faltam %'})).to.be 'Faltam 2 valores'
      return

    return
  describe '#date_diff', () ->
    it 'should return right values with simple comparisons', () ->
      df = date_diff new Date(1441668306007), new Date(1404501600000)
      expect(df.years).to.be 1
      expect(df.months).to.be 2
      expect(df.days).to.be 3
      expect(df.hours).to.be 4
      expect(df.minutes).to.be 5
      expect(df.seconds).to.be 6
      expect(df.milliseconds).to.be 7
      return

    it 'should give no errors between others comparisons', () ->
      df = date_diff new Date(1436037600000), new Date(1404501600001)
      expect(df.years).to.be 0
      expect(df.months).to.be 11
      expect(df.days).to.be 29
      expect(df.hours).to.be 23
      expect(df.minutes).to.be 59
      expect(df.seconds).to.be 59
      expect(df.milliseconds).to.be 999
      return

    return
  describe '#static_countdown', () ->
    it 'should warn that the first argument is required', () ->
      expect(countdown).withArgs().to.throwException /first argument is required/i
      return

    it 'should warn if first argument is not datable', () ->
      expect(countdown).withArgs('I am a string').to.throwException InvalidDateError
      return

    it 'should warn if second argument is not datable', () ->
      expect(countdown).withArgs('2015-01-01', 'I am a string').to.throwException InvalidDateError
      return

    # it 'should give "2 seconds" when two dates have 2 seconds of difference between them', () ->
    #   expect(countdown('2014-07-03T21:46:43', '2014-07-03T21:46:41')).to.be '2 seconds left'
    #   return

    # it 'should give "1 minute" when two dates have 1 minute of difference between them', () ->
    #   expect(countdown('2014-07-03T21:47:41', '2014-07-03T21:46:41')).to.be '1 minute left'
    #   return

    # it 'should give "59 minutes" when two dates have 59 minutes of difference between them', () ->
    #   expect(countdown('2014-07-03T22:46:40', '2014-07-03T21:46:41')).to.be '59 minutes left'
    #   return

    # it 'should give "1 hour" when two dates have 1 hour of difference between them', () ->
    #   expect(countdown('2014-07-03T22:46:41', '2014-07-03T21:46:41')).to.be '1 hour left'
    #   return

    # it 'should return "1 year left" when two dates have 1 year of difference between them', () ->
    #   expect(countdown('2015-08-03T21:46:43', '2014-07-03T21:46:42')).to.be '1 year left'
    #   return

    # it 'should return "5 years left" when two dates have 1 year of difference between them', () ->
    #   expect(countdown('2020-04-03T21:46:43', '2014-07-03T21:46:42')).to.be '5 years left'
    #   return

    # it 'should give "1 second" when two dates have 1 second of difference between them', () ->
    #   expect(countdown('2014-07-03T21:46:43', '2014-07-03T21:46:42')).to.be '1 second left'
    #   return

    return
  return
