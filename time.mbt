///|
fn leap(year : Int32) -> Bool {
  year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
}

///|
fn month_days(year : Int32, month : Int32) -> Int32 {
  match month {
    2 => if leap(year) { 29 } else { 28 }
    4 | 6 | 9 | 11 => 30
    _ => 31
  }
}

///|
fn decimal_part(
  s : String,
  start : Int32,
  end : Int32,
) -> Int32 raise TemplateError {
  if start >= end || end > s.length() {
    raise Invalid("invalid date component")
  }
  let mut n = 0
  for i = start; i < end; i = i + 1 {
    let c = s.code_unit_at(i).to_int()
    if !digit(c) {
      raise Invalid("expected decimal date component")
    }
    n = n * 10 + c - 48
  }
  n
}

///|
fn offset_seconds(offset : String, b : Budget) -> Double raise TemplateError {
  let s = offset.trim().to_string()
  let mut i = 0
  let mut sign = 1.0
  if s.has_prefix("-") || s.has_prefix("+") {
    if s.has_prefix("-") {
      sign = -1
    }
    i = 1
  }
  let mut last = -1
  let mut total = 0.0
  while i < s.length() {
    b.tick(0)
    while i < s.length() && [32, 9, 10, 13].contains(s.code_unit_at(i).to_int()) {
      i += 1
    }
    if i == s.length() {
      break
    }
    let begin = i
    while i < s.length() && digit(s.code_unit_at(i).to_int()) {
      i += 1
    }
    if begin == i {
      raise Invalid("invalid relative time")
    }
    let count = @string.parse_double(s[begin:i]) catch {
      _ => raise Invalid("relative time magnitude")
    }
    while i < s.length() && [32, 9, 10, 13].contains(s.code_unit_at(i).to_int()) {
      i += 1
    }
    let begin = i
    while i < s.length() && alpha(s.code_unit_at(i).to_int()) {
      i += 1
    }
    let unit = s[begin:i].to_string()
    let (order, factor) = match unit {
      "years" | "year" | "yr" | "y" => (0, 31536000.0)
      "months" | "month" | "mo" => (1, 2592000.0)
      "weeks" | "week" | "wk" | "w" => (2, 604800.0)
      "days" | "day" | "d" => (3, 86400.0)
      "hours" | "hour" | "hr" | "h" => (4, 3600.0)
      "minutes" | "minute" | "min" | "m" => (5, 60.0)
      "seconds" | "second" | "sec" | "s" => (6, 1.0)
      _ => raise Invalid("invalid relative time unit")
    }
    if order <= last {
      raise Invalid("relative units must be unique and descending")
    }
    last = order
    total += count * factor
    if total > 315537897599.0 {
      raise Limit("relative time exceeds year range")
    }
  }
  total * sign
}

///|
fn pad(n : Int32, width : Int32) -> String {
  let mut s = n.to_string()
  while s.length() < width {
    s = "0" + s
  }
  s
}

///|
fn relative_time(
  offset : String,
  reference : String,
  b : Budget,
) -> String raise TemplateError {
  if reference.length() != 24 ||
    reference[4:5] != "-" ||
    reference[7:8] != "-" ||
    reference[10:11] != "T" ||
    reference[13:14] != ":" ||
    reference[16:17] != ":" ||
    reference[19:20] != "." ||
    reference[23:24] != "Z" {
    raise Invalid("reference must be YYYY-MM-DDTHH:mm:ss.sssZ")
  }
  let mut year = decimal_part(reference, 0, 4)
  let mut month = decimal_part(reference, 5, 7)
  let mut day = decimal_part(reference, 8, 10)
  let hour = decimal_part(reference, 11, 13)
  let minute = decimal_part(reference, 14, 16)
  let second = decimal_part(reference, 17, 19)
  let ms = decimal_part(reference, 20, 23)
  if year < 1 ||
    month < 1 ||
    month > 12 ||
    day < 1 ||
    day > month_days(year, month) ||
    hour > 23 ||
    minute > 59 ||
    second > 59 {
    raise Invalid("invalid UTC date")
  }
  let seconds = offset_seconds(offset, b) +
    (hour * 3600 + minute * 60 + second).to_double()
  let mut days = @math.floor(seconds / 86400).to_int()
  let rest = (seconds - days.to_double() * 86400).to_int()
  while days > 0 {
    b.tick(0)
    let count = month_days(year, month) - day + 1
    if days < count {
      day += days
      days = 0
    } else {
      days -= count
      day = 1
      month += 1
      if month > 12 {
        month = 1
        year += 1
      }
    }
    if year > 9999 {
      raise Limit("date exceeds year 9999")
    }
  }
  while days < 0 {
    b.tick(0)
    if -days < day {
      day += days
      days = 0
    } else {
      days += day
      month -= 1
      if month < 1 {
        month = 12
        year -= 1
      }
      if year < 1 {
        raise Limit("date precedes year 1")
      }
      day = month_days(year, month)
    }
  }
  pad(year, 4) +
  "-" +
  pad(month, 2) +
  "-" +
  pad(day, 2) +
  "T" +
  pad(rest / 3600, 2) +
  ":" +
  pad(rest / 60 % 60, 2) +
  ":" +
  pad(rest % 60, 2) +
  "." +
  pad(ms, 3) +
  "Z"
}
