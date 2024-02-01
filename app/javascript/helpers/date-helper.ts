export const formatDate = (date: string): string => {
  let utcDate = new Date(date);
  let dateFormatter = new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });

  let timeFormatter = new Intl.DateTimeFormat('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true,
  });

  return dateFormatter.format(utcDate) + ' at ' + timeFormatter.format(utcDate).replace(" ", "").replace('AM', 'am').replace('PM', 'pm');
}