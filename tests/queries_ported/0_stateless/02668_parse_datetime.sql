-- { echoOn }
-- year
select parse_datetime('2020', '%Y', 'UTC') = to_datetime('2020-01-01', 'UTC');

-- month
select parse_datetime('02', '%m', 'UTC') = to_datetime('2000-02-01', 'UTC');
select parse_datetime('07', '%m', 'UTC') = to_datetime('2000-07-01', 'UTC');
select parse_datetime('11-', '%m-', 'UTC') = to_datetime('2000-11-01', 'UTC');
select parse_datetime('00', '%m'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('13', '%m'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('12345', '%m'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('02', '%c', 'UTC') = to_datetime('2000-02-01', 'UTC');
select parse_datetime('07', '%c', 'UTC') = to_datetime('2000-07-01', 'UTC');
select parse_datetime('11-', '%c-', 'UTC') = to_datetime('2000-11-01', 'UTC');
select parse_datetime('00', '%c'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('13', '%c'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('12345', '%c'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('jun', '%b', 'UTC') = to_datetime('2000-06-01', 'UTC');
select parse_datetime('JUN', '%b', 'UTC') = to_datetime('2000-06-01', 'UTC');
select parse_datetime('abc', '%b'); -- { serverError CANNOT_PARSE_DATETIME }
set formatdatetime_parsedatetime_m_is_month_name = 1;
select parse_datetime('may', '%M', 'UTC') = to_datetime('2000-05-01', 'UTC');
select parse_datetime('MAY', '%M', 'UTC') = to_datetime('2000-05-01', 'UTC');
select parse_datetime('september', '%M', 'UTC') = to_datetime('2000-09-01', 'UTC');
select parse_datetime('summer', '%M'); -- { serverError CANNOT_PARSE_DATETIME }
set formatdatetime_parsedatetime_m_is_month_name = 0;
select parse_datetime('08', '%M', 'UTC') = to_datetime('1970-01-01 00:08:00', 'UTC');
select parse_datetime('59', '%M', 'UTC') = to_datetime('1970-01-01 00:59:00', 'UTC');
select parse_datetime('00/', '%M/', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('60', '%M', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('-1', '%M', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('123456789', '%M', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
set formatdatetime_parsedatetime_m_is_month_name = 1;

-- day of month
select parse_datetime('07', '%d', 'UTC') = to_datetime('2000-01-07', 'UTC');
select parse_datetime('01', '%d', 'UTC') = to_datetime('2000-01-01', 'UTC');
select parse_datetime('/11', '/%d', 'UTC') = to_datetime('2000-01-11', 'UTC');
select parse_datetime('00', '%d'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('32', '%d'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('12345', '%d'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('02-31', '%m-%d'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('04-31', '%m-%d'); -- { serverError CANNOT_PARSE_DATETIME }
-- The last one is chosen if multiple months of year if supplied
select parse_datetime('01 31 20 02', '%m %d %d %m', 'UTC') = to_datetime('2000-02-20', 'UTC');
select parse_datetime('02 31 20 04', '%m %d %d %m', 'UTC') = to_datetime('2000-04-20', 'UTC');
select parse_datetime('02 31 01', '%m %d %m', 'UTC') = to_datetime('2000-01-31', 'UTC');
select parse_datetime('2000-02-29', '%Y-%m-%d', 'UTC') = to_datetime('2000-02-29', 'UTC');
select parse_datetime('2001-02-29', '%Y-%m-%d'); -- { serverError CANNOT_PARSE_DATETIME }

-- day of year
select parse_datetime('001', '%j', 'UTC') = to_datetime('2000-01-01', 'UTC');
select parse_datetime('007', '%j', 'UTC') = to_datetime('2000-01-07', 'UTC');
select parse_datetime('/031/', '/%j/', 'UTC') = to_datetime('2000-01-31', 'UTC');
select parse_datetime('032', '%j', 'UTC') = to_datetime('2000-02-01', 'UTC');
select parse_datetime('060', '%j', 'UTC') = to_datetime('2000-02-29', 'UTC');
select parse_datetime('365', '%j', 'UTC') = to_datetime('2000-12-30', 'UTC');
select parse_datetime('366', '%j', 'UTC') = to_datetime('2000-12-31', 'UTC');
select parse_datetime('1980 001', '%Y %j', 'UTC') = to_datetime('1980-01-01', 'UTC');
select parse_datetime('1980 007', '%Y %j', 'UTC') = to_datetime('1980-01-07', 'UTC');
select parse_datetime('1980 /007', '%Y /%j', 'UTC') = to_datetime('1980-01-07', 'UTC');
select parse_datetime('1980 /031/', '%Y /%j/', 'UTC') = to_datetime('1980-01-31', 'UTC');
select parse_datetime('1980 032', '%Y %j', 'UTC') = to_datetime('1980-02-01', 'UTC');
select parse_datetime('1980 060', '%Y %j', 'UTC') = to_datetime('1980-02-29', 'UTC');
select parse_datetime('1980 366', '%Y %j', 'UTC') = to_datetime('1980-12-31', 'UTC');
select parse_datetime('1981 366', '%Y %j'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('367', '%j'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('000', '%j'); -- { serverError CANNOT_PARSE_DATETIME }
-- The last one is chosen if multiple day of years are supplied.
select parse_datetime('2000 366 2001', '%Y %j %Y'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('2001 366 2000', '%Y %j %Y', 'UTC') = to_datetime('2000-12-31', 'UTC');

-- hour of day
select parse_datetime('07', '%H', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('23', '%H', 'UTC') = to_datetime('1970-01-01 23:00:00', 'UTC');
select parse_datetime('00', '%H', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('10', '%H', 'UTC') = to_datetime('1970-01-01 10:00:00', 'UTC');
select parse_datetime('24', '%H', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('-1', '%H', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('1234567', '%H', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('07', '%k', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('23', '%k', 'UTC') = to_datetime('1970-01-01 23:00:00', 'UTC');
select parse_datetime('00', '%k', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('10', '%k', 'UTC') = to_datetime('1970-01-01 10:00:00', 'UTC');
select parse_datetime('24', '%k', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('-1', '%k', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('1234567', '%k', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- hour of half day
select parse_datetime('07', '%h', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('12', '%h', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('01', '%h', 'UTC') = to_datetime('1970-01-01 01:00:00', 'UTC');
select parse_datetime('10', '%h', 'UTC') = to_datetime('1970-01-01 10:00:00', 'UTC');
select parse_datetime('00', '%h', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('13', '%h', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('123456789', '%h', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('07', '%I', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('12', '%I', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('01', '%I', 'UTC') = to_datetime('1970-01-01 01:00:00', 'UTC');
select parse_datetime('10', '%I', 'UTC') = to_datetime('1970-01-01 10:00:00', 'UTC');
select parse_datetime('00', '%I', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('13', '%I', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('123456789', '%I', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('07', '%l', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('12', '%l', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('01', '%l', 'UTC') = to_datetime('1970-01-01 01:00:00', 'UTC');
select parse_datetime('10', '%l', 'UTC') = to_datetime('1970-01-01 10:00:00', 'UTC');
select parse_datetime('00', '%l', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('13', '%l', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('123456789', '%l', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- half of day
select parse_datetime('07 PM', '%H %p', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('07 AM', '%H %p', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('07 pm', '%H %p', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('07 am', '%H %p', 'UTC') = to_datetime('1970-01-01 07:00:00', 'UTC');
select parse_datetime('00 AM', '%H %p', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('00 PM', '%H %p', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('00 am', '%H %p', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('00 pm', '%H %p', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('01 PM', '%h %p', 'UTC') = to_datetime('1970-01-01 13:00:00', 'UTC');
select parse_datetime('01 AM', '%h %p', 'UTC') = to_datetime('1970-01-01 01:00:00', 'UTC');
select parse_datetime('06 PM', '%h %p', 'UTC') = to_datetime('1970-01-01 18:00:00', 'UTC');
select parse_datetime('06 AM', '%h %p', 'UTC') = to_datetime('1970-01-01 06:00:00', 'UTC');
select parse_datetime('12 PM', '%h %p', 'UTC') = to_datetime('1970-01-01 12:00:00', 'UTC');
select parse_datetime('12 AM', '%h %p', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');

-- minute
select parse_datetime('08', '%i', 'UTC') = to_datetime('1970-01-01 00:08:00', 'UTC');
select parse_datetime('59', '%i', 'UTC') = to_datetime('1970-01-01 00:59:00', 'UTC');
select parse_datetime('00/', '%i/', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('60', '%i', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('-1', '%i', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('123456789', '%i', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }

-- second
select parse_datetime('09', '%s', 'UTC') = to_datetime('1970-01-01 00:00:09', 'UTC');
select parse_datetime('58', '%s', 'UTC') = to_datetime('1970-01-01 00:00:58', 'UTC');
select parse_datetime('00/', '%s/', 'UTC') = to_datetime('1970-01-01 00:00:00', 'UTC');
select parse_datetime('60', '%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('-1', '%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
select parse_datetime('123456789', '%s', 'UTC'); -- { serverError CANNOT_PARSE_DATETIME }
-- mixed YMD format
select parse_datetime('2021-01-04+23:00:00', '%Y-%m-%d+%H:%i:%s', 'UTC') = to_datetime('2021-01-04 23:00:00', 'UTC');
select parse_datetime('2019-07-03 11:04:10', '%Y-%m-%d %H:%i:%s', 'UTC') = to_datetime('2019-07-03 11:04:10', 'UTC');
select parse_datetime('10:04:11 03-07-2019', '%s:%i:%H %d-%m-%Y', 'UTC') = to_datetime('2019-07-03 11:04:10', 'UTC');

-- { echoOff }