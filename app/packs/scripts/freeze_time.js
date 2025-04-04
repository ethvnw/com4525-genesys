const timestamp = document.querySelector('meta[name="test-timestamp"]').content;

/**
 * Allows the stubbing of new Date objects
 */
class MockDate extends Date {
  constructor(...args) {
    if (args.length === 0) {
      super(timestamp);
    } else {
      super(...args);
    }
  }
}

// Stub if timestamp is not null
if (timestamp !== null) {
  global.Date = MockDate;
}
