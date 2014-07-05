
do (
  $ = if jQuery? then jQuery else {}
  window = if window? then window else {}
) ->
  default_opts =
    corrections:
      months: 12
      days: (date) ->
        date = parse_date date.getFullYear() + '-' + (date.getMonth() + 1) + '-01'
        date.setDate date.getDate() - 1
        date.getDate()
      hours: 24
      minutes: 60
      seconds: 60
      milliseconds: 1000
    standards:
      years: (date) ->
        date.getFullYear()
      months: (date) ->
        date.getMonth() + 1
      days: (date) ->
        date.getDate()
      hours: (date) ->
        date.getHours()
      minutes: (date) ->
        date.getMinutes()
      seconds: (date) ->
        date.getSeconds()
      milliseconds: (date) ->
        date.getMilliseconds()
    lang: 'en'
    messages:
      en:
        prefix:
          singular: '% left'
          plural: '% left'
        milliseconds:
          singular: '% millisecond'
          plural: '% milliseconds'
        seconds:
          singular: '% second'
          plural: '% seconds'
        minutes:
          singular: '% minute'
          plural: '% minutes'
        hours:
          singular: '% hour'
          plural: '% hours'
        days:
          singular: '% day'
          plural: '% days'
        months:
          singular: '% month'
          plural: '% months'
        years:
          singular: '% year'
          plural: '% years'
      pt:
        prefix:
          singular: 'Falta'
          plural: 'Faltam'
        milliseconds:
          singular: '% milissegundo'
          plural: '% milissegundos'
        seconds:
          singular: '% segundo'
          plural: '% segundos'
        minutes:
          singular: '% minuto'
          plural: '% minutos'
        hours:
          singular: '% hora'
          plural: '% horas'
        days:
          singular: '% dia'
          plural: '% dias'
        months:
          singular: '% mês'
          plural: '% meses'
        years:
          singular: '% ano'
          plural: '% anos'

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

  get_message = (date_diff, messages, prefix) ->
    output = '' + date_diff

    if not not messages
      message = messages[if date_diff is 1 then 'singular' else 'plural']
      output = message.replace '%', output

    if not not prefix
      message = prefix[if date_diff is 1 then 'singular' else 'plural']
      output = message.replace '%', output

    output

  date_diff = (date_end, date_start, custom_opts) ->
    opts = $.extend {}, true, default_opts, custom_opts
    units = []
    output = {}

    for unit, callback of opts.standards
      output[unit] = parseInt(callback(date_end), 10) - parseInt(callback(date_start), 10)
      units.push unit

    units.reverse()

    for unit, i in units
      if output[unit] < 0 && units[i+1]?
        output[units[i+1]] -= 1
        if typeof opts.corrections[unit] is 'function'
          output[unit] += opts.corrections[unit]( date_end )
        else
          output[unit] += opts.corrections[unit]

    output

  countdown = (date_end, date_start, custom_opts) ->
    opts = $.extend {}, true, default_opts, custom_opts
    messages = opts.messages[opts.lang]

    if not date_end
      throw new Error 'First argument is required to calculate Countdown.'
    if not (date_end instanceof Date)
      date_end = parse_date date_end
    if not date_start
      date_start = new Date()
    if not (date_start instanceof Date)
      date_start = parse_date date_start

    # date_diff = parseInt(date_end.getFullYear(), 10) - parseInt(date_start.getFullYear(), 10)
    # if date_diff > 0
    #   return get_message date_diff, messages.years, messages.prefix

    # if date_diff < 60
    #   return get_message date_diff, messages.seconds, messages.prefix
    # else
    #   date_diff /= 60
    #   date_diff = Math.floor date_diff
    #   if date_diff < 60
    #     return get_message date_diff, messages.minutes, messages.prefix
    #   else
    #     date_diff /= 60
    #     date_diff = Math.floor date_diff
    #     return get_message date_diff, messages.hours, messages.prefix

    return

  $.Countdown = countdown
  $.Countdown.parse_date_string = parse_date_string
  $.Countdown.parse_date = parse_date
  $.Countdown.get_message = get_message
  $.Countdown.date_diff = date_diff
  $.Countdown.InvalidDateError = InvalidDateError
  # if module.exports?
  #   module.exports =
  #     countdown: countdown
  #     parse_date_string: parse_date_string
  #     parse_date: parse_date
  #     InvalidDateError: InvalidDateError
  return
