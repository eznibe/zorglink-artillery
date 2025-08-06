const { v4: uuidv4 } = require('uuid');

module.exports = {
  generateUuid: function(requestParams, context, ee, next) {
    // Generate a UUID and store it in context variables
    context.vars.custom_uuid = uuidv4();
    // console.log('Generated UUID:', context.vars.custom_uuid);
    return next();
  },

  logRequest: function(requestParams, context, ee, next) {
    console.log('=== REQUEST ===');
    console.log('URL:', requestParams.url);
    console.log('Method:', requestParams.method);
    if (requestParams.json) {
      console.log('JSON Payload:', JSON.stringify(requestParams.json, null, 2));
    }
    if (requestParams.headers) {
      console.log('Headers:', JSON.stringify(requestParams.headers, null, 2));
    }
    console.log('===============');
    return next();
  },

  logResponse: function(requestParams, response, context, ee, next) {
    console.log('=== RESPONSE ===');
    console.log('Status:', response.statusCode);
    // console.log('Headers:', JSON.stringify(response.headers, null, 2));
    // console.log('Body:', JSON.stringify(response.body, null, 2));
    if (requestParams.json) {
      console.log('JSON Payload:', JSON.stringify(requestParams.json, null, 2));
    }
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