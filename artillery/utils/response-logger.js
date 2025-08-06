module.exports = {
  logResponse: function(requestParams, response, context, ee, next) {
    console.log('=== RESPONSE ===');
    console.log('Status:', response.statusCode);
    console.log('Headers:', JSON.stringify(response.headers, null, 2));
    // console.log('Body:', JSON.stringify(response.body, null, 2));
    console.log('===============');
    return next();
  },

   logErrorResponse: function(requestParams, response, context, ee, next) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      console.error('=== ERROR RESPONSE ===');
      console.error('Status:', response.statusCode);
      // console.error('Headers:', JSON.stringify(response.headers, null, 2));
      console.error('Body:', JSON.stringify(response.body, null, 2));
      console.log('======================');
    }
    return next();
  }
};