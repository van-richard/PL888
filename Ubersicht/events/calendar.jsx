// based on: https://github.com/knazarov/ubersicht-calendar-widget
// requires ical-buddy: brew install ical-buddy

// --------------- CUSTOMIZE ME ---------------
// the following dimensions are specified in pixels
const WIDTH = 200; // width of the widget (px)
const TOP = 275; // top margin (px)
const LEFT = 10; // left margin (px)
const BOTTOM = 0; // bottom margin (px)
const BACKGROUND_COLOR = 'rgba(0, 0, 0, 0)';
const REFRESH_FREQUENCY = 3600; // widget refresh frequency in seconds
const CALENDAR_APP = '/System/Applications/Calendar.app';
const DEBUG_LOG = false;
// --------------------------------------------

import { run } from 'uebersicht';

export function command(dispatch) {
  DEBUG_LOG && console.log("called 'command'");
  getData(dispatch, undefined);
}

function getData(dispatch, offset) {
  if (offset === undefined) {
    const dateElement = document.getElementById('shown-date');
    offset = dateElement === null ? 0 : parseInt(dateElement.dataset.offset);
  }
  const offsetString = offset >= 0 ? `+${offset}` : `${offset}`;
  // construct bash command to grab today's events
  // Refer to https://hasseg.org/icalBuddy/man.html
  const commandString =
    '/opt/homebrew/bin/icalbuddy ' +
    '-npn -nrd -b "<newevent>" -nnr "<newline>" -ps "||" ' +
    '-iep "datetime,title,location,notes" ' +
    '-po "datetime,title,location,notes" ' +
    '-tf "%H:%M" -df "%Y-%m-%d" ' +
    `eventsFrom:today${offsetString} to:today${offsetString}`;
  run(commandString).then((output) =>
    dispatch({ type: 'UB/COMMAND_RAN', output })
  );
}

export const initialState = {
  output: '',
  offset: 0,
  show_events: true,
};

// refresh frequency in milliseconds
export const refreshFrequency = REFRESH_FREQUENCY * 1000;

export const className = `
  top: ${TOP}px;
  left: ${LEFT}px;
  bottom: ${BOTTOM}px;
  width: ${WIDTH}px;

  .calendar-widget {
    padding-top: 5px;
    padding-bottom: 5px;
    padding-left: 10px;
    padding-right: 10px;
    border-radius: 10px;
    background: ${BACKGROUND_COLOR};
    backdrop-filter: blur(2px);
    color: #FFFFFF;
    font-family: system-ui;
    overflow: hidden;
    z-index: 0;
  }
  .header {
    display: inline-block;
    margin-bottom: 5px;
  }
  .date-header {
    font-size: 18px;
    margin-left: 8px;
    margin-right: 8px;
  }
  .left-margin {
    margin-left: 5px;
  }
  .event {
    font-size: 14px;
    color: #FFFFFF;
  }
  .event-details {
    font-weight: bold;
    border-left: solid 4px;
    border-radius: 2px;
    padding-top: 2px;
    padding-bottom: 2px;
    padding-left: 5px;
    overflow: hidden;
    margin-bottom: 5px;
    width: ${WIDTH - 5}px;
    left: 0px;
  }
  .meetingLink {
    margin-left: 5px;
  }
`;

const line_regex = /^(\d+-\d+-\d+)?(?: at )?(\d+:\d+) - (\d+-\d+-\d+)?(?: at )?((?:\d+:\d+)|(?:\.\.\.))([^]*)?([^]*)?([^]*)?$/;
const zoom_link_regex = /(https:\/\/[a-z]{2,20}.zoom.[a-z]{2,3}\/j\/[^\n <>"]*)/;
const gmeet_link_regex = /(https:\/\/meet\.google\.com\/[^\n <>"]*)/;
const teams_link_regex = /(https:\/\/teams\.microsoft\.com\/l\/meetup-join\/[^\n <>"]*)/;

function processEvents(output) {
  DEBUG_LOG && console.log({ output });
  const lines =
    output === undefined
      ? []
      : output.split('<newevent>').filter((item) => item);
  DEBUG_LOG && console.log({ lines });
  const events = [];
  lines.forEach((line) => {
    const result = line_regex.exec(line);
    if (result === null) {
      const info = line.split(/\u001f/g);
      events.push({
        all_day: true,
        calendar: info[1].match(/.*\(([^)]+)\)/)[1],
        title: info[1].substring(0, info[1].lastIndexOf('(')),
      });
    } else {
      // console.log(line.split(''));
      // console.log(result);
      result[7] =
        result[7] === undefined ? '' : result[7].replace(/<newline>/g, '\n');
      events.push({
        all_day: false,
        calendar: result[5].match(/.*\(([^)]+)\)/)[1],
        start_time_str: result[2].replace(/^0/, ''),
        start_time: convertStrTimeToDecimal(result[2]),
        end_time_str: result[4].replace(/^0/, ''),
        end_time: convertStrTimeToDecimal(result[4]),
        title: result[5].substring(0, result[5].lastIndexOf('(')),
        location: result[6],
        zoom_link: getLink(result[6] + ' ' + result[7], zoom_link_regex),
        gmeet_link: getLink(result[6] + ' ' + result[7], gmeet_link_regex),
        teams_link: getLink(result[6] + ' ' + result[7], teams_link_regex),
        notes: result[7],
      });
    }
  });
  return events;
}

function convertStrTimeToDecimal(str) {
  const result = str.split(':');
  return parseInt(result[0]) + parseInt(result[1]) / 60;
}

function getLink(str, regex) {
  const links = regex.exec(str);
  if (Array.isArray(links) && links.length > 1) {
    return [...new Set(links)];
  } else {
    return '';
  }
}

function changeOffset(offset, val, dispatch) {
  DEBUG_LOG && console.log(`changing offset by ${val}`);
  dispatch({ type: 'LOADING' });
  dispatch({ type: 'CHANGE_OFFSET', offset: offset + val });
  getData(dispatch, offset + val);
}

function resetOffset(dispatch) {
  DEBUG_LOG && console.log('resetting offset');
  dispatch({ type: 'LOADING' });
  dispatch({ type: 'CHANGE_OFFSET', offset: 0 });
  getData(dispatch, 0);
}

function changeShowEvents(dispatch) {
  DEBUG_LOG && console.log('change setting to show/hide events');
  dispatch({ type: 'SHOW_EVENTS' });
}

function Header({ date, offset, show_events, dispatch }) {
  const month_names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return (
    <div id="header">
      <i
        title="Open Calendar application"
        className="fa fa-calendar-days header button-offset left-margin"
        onClick={() => run(`open ${CALENDAR_APP}`)}
      />
      <div id="shown-date" className="header date-header" data-offset={offset}>
        {`Today's Events!`}
      </div>
    </div>
  );
}

function Events({ date, offset, events }) {
  DEBUG_LOG && console.log({ events });
  const current_time = date.getHours() + date.getMinutes() / 60;
  return (
    <div id="events">
      {events
        .sort((a, b) => a.start_time - b.start_time || a.end_time - b.end_time)
        .map((event) => {
          return (
            <Event
              key={event.title}
              offset={offset}
              event={event}
              current_time={current_time}
            />
          );
        })}
    </div>
  );
}

function Event({ event, offset, current_time }) {
  if (event.all_day) {
    const color = offset < 0 ? '#808080' : '#FFF';
    return (
      <div
        key={event.title}
        className="event event-details"
        title={`Calendar: ${event.calendar}`}
        style={{ color: color }}
      >
        {event.title}
      </div>
    );
  } else {
    const border_thickness =
      offset > 0 || offset < 0
        ? 4
        : event.start_time <= current_time && event.end_time >= current_time
        ? 8
        : 4;
    const color =
      offset > 0
        ? '#FFF'
        : offset < 0 || current_time >= event.end_time
        ? '#808080'
        : current_time - event.start_time >= -0.5 &&
          current_time <= event.end_time
        ? '#e74c3c'
        : '#FFFFFF';
    return (
      <div
        key={event.title}
        className="event event-details"
        title={
          (event.calendar !== '' ? `Calendar:\n${event.calendar}` : '') +
          (event.location !== '' ? `\n\nLocation:\n${event.location}` : '') +
          (event.notes !== '' ? `\n\nNotes:\n${event.notes}` : '')
        }
        style={{ color: color, borderLeft: `solid ${border_thickness}px` }}
      >
        {event.start_time_str === '0:00' && event.end_time_str === '0:00'
          ? 'All-day'
          : `${event.start_time_str} - ${event.end_time_str}`}
        <Link label="zoom" values={event.zoom_link} color={color} />
        <Link label="gmeet" values={event.gmeet_link} color={color} />
        <Link label="teams" values={event.teams_link} color={color} />
        <br />
        {event.title}
      </div>
    );
  }
}

function Loading() {
  return <div className="event">...loading...</div>;
}
function NoEvents() {
  return <span className="event">No events.</span>;
}

function Link({ label, values, color }) {
  return values === ''
    ? null
    : values.map((value) => (
        <a
          key={value}
          className="meetingLink"
          href={value}
          style={{ color: color }}
          title={value}
        >
          [{label}]
        </a>
      ));
}

export function render({ output, offset, show_events }, dispatch) {
  if (DEBUG_LOG) {
    console.log('rendering...');
    console.log({ output });
    console.log({ offset });
  }
  const dateToShow = new Date();
  dateToShow.setDate(dateToShow.getDate() + offset);
  const events =
    output === '' || output === 'loading' ? [] : processEvents(output);
  return (
    <div className="calendar-widget">
      <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"
      ></link>
      <Header
        date={dateToShow}
        offset={offset}
        show_events={show_events}
        dispatch={dispatch}
      />
      {show_events !== true ? null : output === 'loading' ? (
        <Loading />
      ) : output === '' ? (
        <NoEvents />
      ) : (
        <Events date={dateToShow} offset={offset} events={events} />
      )}
    </div>
  );
}

export function updateState(event, previousState) {
  if (DEBUG_LOG) {
    console.log("called 'updateState'");
    console.log({ event });
  }
  if (event.type === 'UB/COMMAND_RAN' && event.output !== undefined) {
    if (DEBUG_LOG) {
      console.log("mode: 'UB/COMMAND_RAN'");
      console.log({ event });
    }
    return { ...previousState, output: event.output };
  } else if (event.type === 'CHANGE_OFFSET' && event.offset !== undefined) {
    if (DEBUG_LOG) {
      console.log("mode: 'CHANGE_OFFSET'");
      console.log({ event });
    }
    return { ...previousState, offset: event.offset };
  } else if (event.type === 'LOADING') {
    if (DEBUG_LOG) {
      console.log("mode: 'LOADING'");
      console.log({ event });
    }
    return { ...previousState, output: 'loading' };
  } else if (event.type === 'SHOW_EVENTS') {
    if (DEBUG_LOG) {
      console.log("mode: 'SHOW_EVENTS'");
      console.log({ event });
    }
    return { ...previousState, show_events: !previousState.show_events };
  } else {
    DEBUG_LOG && console.log('returning previous state');
    return { ...previousState };
  }
}
