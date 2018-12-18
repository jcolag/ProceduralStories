var today = new Date();
var day = Math.random() * 365;
var outdate = new Date(
  new Date(
    today
      .setMonth(0)
  ).setDate(day)
);
console.log(`${day} -> ${outdate.toDateString()}, ${outdate.toLocaleTimeString()}`);

