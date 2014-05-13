(function() {
  define(function(require) {
    var tz;
    tz = require('moment-timezone');
    tz.tz.add({
      zones: {
        "America/Chicago": ["-5:50:36 - LMT 1883_10_18_12_9_24 -5:50:36", "-6 US C%sT 1920 -6", "-6 Chicago C%sT 1936_2_1_2 -6", "-5 - EST 1936_10_15_2 -5", "-6 Chicago C%sT 1942 -6", "-6 US C%sT 1946 -6", "-6 Chicago C%sT 1967 -6", "-6 US C%sT"],
        "America/Denver": ["-6:59:56 - LMT 1883_10_18_12_0_4 -6:59:56", "-7 US M%sT 1920 -7", "-7 Denver M%sT 1942 -7", "-7 US M%sT 1946 -7", "-7 Denver M%sT 1967 -7", "-7 US M%sT"],
        "America/Los_Angeles": ["-7:52:58 - LMT 1883_10_18_12_7_2 -7:52:58", "-8 US P%sT 1946 -8", "-8 CA P%sT 1967 -8", "-8 US P%sT"],
        "America/New_York": ["-4:56:2 - LMT 1883_10_18_12_3_58 -4:56:2", "-5 US E%sT 1920 -5", "-5 NYC E%sT 1942 -5", "-5 US E%sT 1946 -5", "-5 NYC E%sT 1967 -5", "-5 US E%sT"]
      },
      rules: {
        US: ["1918 1919 2 0 8 2 0 1 D", "1918 1919 9 0 8 2 0 0 S", "1942 1942 1 9 7 2 0 1 W", "1945 1945 7 14 7 23 1 1 P", "1945 1945 8 30 7 2 0 0 S", "1967 2006 9 0 8 2 0 0 S", "1967 1973 3 0 8 2 0 1 D", "1974 1974 0 6 7 2 0 1 D", "1975 1975 1 23 7 2 0 1 D", "1976 1986 3 0 8 2 0 1 D", "1987 2006 3 1 0 2 0 1 D", "2007 9999 2 8 0 2 0 1 D", "2007 9999 10 1 0 2 0 0 S"],
        Chicago: ["1920 1920 5 13 7 2 0 1 D", "1920 1921 9 0 8 2 0 0 S", "1921 1921 2 0 8 2 0 1 D", "1922 1966 3 0 8 2 0 1 D", "1922 1954 8 0 8 2 0 0 S", "1955 1966 9 0 8 2 0 0 S"],
        Denver: ["1920 1921 2 0 8 2 0 1 D", "1920 1920 9 0 8 2 0 0 S", "1921 1921 4 22 7 2 0 0 S", "1965 1966 3 0 8 2 0 1 D", "1965 1966 9 0 8 2 0 0 S"],
        CA: ["1948 1948 2 14 7 2 0 1 D", "1949 1949 0 1 7 2 0 0 S", "1950 1966 3 0 8 2 0 1 D", "1950 1961 8 0 8 2 0 0 S", "1962 1966 9 0 8 2 0 0 S"],
        NYC: ["1920 1920 2 0 8 2 0 1 D", "1920 1920 9 0 8 2 0 0 S", "1921 1966 3 0 8 2 0 1 D", "1921 1954 8 0 8 2 0 0 S", "1955 1966 9 0 8 2 0 0 S"]
      },
      links: {}
    });
  });

}).call(this);

/*
//@ sourceMappingURL=data.timezone.js.map
*/