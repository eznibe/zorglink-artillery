module.exports = {
  logResponse: function(requestParams, response, context, ee, next) {
    console.log('=== RESPONSE ===');
    console.log('Status:', response.statusCode);
    console.log('Headers:', JSON.stringify(response.headers, null, 2));
    console.log('Body:', JSON.stringify(response.body, null, 2));
    console.log('===============');
    return next();
  }
};