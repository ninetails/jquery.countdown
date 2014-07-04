
do (
  $ = if jQuery? then jQuery else {}
  window = if window? then window else {}
) ->
  default_opts = {}

  # date regexes
  strict_date_regex = /^([0-9]{4})\-([0-9]{2})\-([0-9]{2})([T\s]([0-9]{2}):([0-9]{2}):([0-9]{2})[:\.]?([0-9]{3})?(Z|((\+|\-)([0-9]{2}):?([0-9]{2})))?)?/i
  date_regex = /^([0-9]{1,4})[\-\/]([0-9]{1,2})[\-\/]([0-9]{1,4})([T\s]([0-9]{1,2})h?\s?:?([0-9]{1,2})m?i?n?\s?:?([0-9]{1,2})?s?[:\.\s]?([0-9]{1,3})?m?s?(Z|((\+|\-)([0-9]{2}):?([0-9]{2})))?)?/i

  # get default timezone offset
  date_get_timezone_offset = do () ->
    new Date()
      .getTimezoneOffset()

  # calculate offset in minutes given hours, minutes and signal for timezone (used in -0300 timezone format)
  calculate_minute_timezone_offset = (signal, hours, minutes) ->
    ( if signal is '+' then 1 else -1 ) * ( 60 * parseInt( hours, 10 ) ) + parseInt( minutes, 10 )

  InvalidDateError = do () ->
    error = (message) ->
      this.name = "InvalidDateError"
      this.message = message || "Invalid Date"
      return

    error.prototype = new Error()
    error.prototype.constructor = error

    error

  parse_date_string = (date_string) ->
    matches = date_string.match date_regex
    date_parts = {}
    if matches[3].length > 2
      date_parts['year'] = parseInt matches[3] , 10
      date_parts['month'] = parseInt matches[2] , 10
      date_parts['date'] = parseInt matches[1] , 10
    else
      date_parts['year'] = parseInt matches[1] , 10
      date_parts['month'] = parseInt matches[2] , 10
      date_parts['date'] = parseInt matches[3] , 10

    if not not matches[5] && not not matches[6]
      date_parts['hours'] = parseInt matches[5] , 10
      date_parts['minutes'] = parseInt matches[6] , 10
      date_parts['seconds'] = if not matches[7] then 0 else parseInt matches[7] , 10
    else
      date_parts['hours'] = date_parts['minutes'] = date_parts['seconds'] = 0

    date_parts['milliseconds'] = if not matches[8] then 0 else parseInt matches[8] , 10

    if not not matches[9]
      date_parts['timezone_offset'] = date_get_timezone_offset
      if matches[9] isnt 'Z' and matches[11]? and matches[12]? and matches[13]?
        date_parts['timezone_offset'] += calculate_minute_timezone_offset matches[11], matches[12], matches[13]
    else
      date_parts['timezone_offset'] = 0

    parsed_date = new Date date_parts['year'], date_parts['month'] - 1, date_parts['date'], date_parts['hours'], date_parts['minutes'], date_parts['seconds'], date_parts['milliseconds']

    if date_parts['timezone_offset'] isnt 0
      parsed_date.setTime parsed_date.getTime() - date_parts[ 'timezone_offset' ] * 60000

    parsed_date

  parse_date = (date_string) ->
    if date_string instanceof Date
      return date_string

    if strict_date_regex.test date_string
      parsed_date = new Date date_string
      matches = date_string.match date_regex
      if parsed_date instanceof Date and not isNaN parsed_date
        if not matches[9]
          parsed_date.setTime parsed_date.getTime() + date_get_timezone_offset * 60000
        return parsed_date

    parsed_date = parse_date_string date_string
    if parsed_date instanceof Date and not isNaN parsed_date
      return parsed_date

    throw new Error parsed_date.toString()
    return

  countdown = (date_end, date_start, custom_opts) ->
    opts = $.extend {}, true, default_opts, custom_opts
    if not date_end
      throw new Error 'First argument is required to calculate Countdown.'

      # if ( typeof date_end === 'undefined' ) {
      #   throw new Error( 'First argument is required to calculate Countdown.' ) ;
      # }
      # if ( ! ( date_end instanceof Date ) ) {
      #   date_end = parse_date( date_end ) ;
      # }

      # if ( typeof date_start === 'undefined' ) {
      #   date_start = new Date() ;
      # }
      # if ( ! ( date_start instanceof Date ) ) {
      #   date_start = parse_date( date_start ) ;
      # }
    return

  $.Countdown = countdown
  $.Countdown.parse_date_string = parse_date_string
  $.Countdown.parse_date = parse_date
  $.Countdown.InvalidDateError = InvalidDateError
  # if module.exports?
  #   module.exports =
  #     countdown: countdown
  #     parse_date_string: parse_date_string
  #     parse_date: parse_date
  #     InvalidDateError: InvalidDateError
  return
