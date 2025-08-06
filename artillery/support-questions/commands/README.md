# Artillery CSV-driven POST Request Script

This Artillery.io script reads data from a CSV file and sends POST requests with JSON payloads for each row in the CSV.

## Features

- ✅ Reads data from CSV file
- ✅ Sends POST requests with JSON payloads
- ✅ Maps CSV columns to JSON fields
- ✅ Includes response logging
- ✅ Environment variable support
- ✅ Request tracking with UUIDs
- ✅ Optional follow-up GET requests for verification

## Usage

### 1. Prerequisites

Make sure you have Artillery.io installed:
```bash
npm install -g artillery
```

### 2. Environment Variables

Set the following environment variables:
```bash
export API_BASE_URL="https://your-api-endpoint.com"
export ACCESS_TOKEN="your-bearer-token"
```

### 3. CSV File Format

The CSV file should be located at `./data/questions.csv` with the following columns:
- `title`: Question title
- `description`: Question description  
- `category`: Question category
- `priority`: Priority level (Low, Medium, High, Critical)
- `user_id`: User identifier
- `tags`: Comma-separated tags

Example CSV:
```csv
title,description,category,priority,user_id,tags
"Login Issues","User cannot log into the application","Authentication","High","user123","login,auth,urgent"
"Password Reset","Need help resetting password","Account","Medium","user456","password,reset"
```

### 4. Running the Script

```bash
# From the commands directory
cd /home/ezequiel/git/zorglink-artillery/artillery/support-questions/commands

# Run the Artillery script
artillery run create_question.yml
```

### 5. Expected API Endpoint

The script expects a POST endpoint at `/api/support-questions` that accepts:
```json
{
  "title": "string",
  "description": "string", 
  "category": "string",
  "priority": "string",
  "user_id": "string",
  "tags": "string",
  "created_at": "timestamp",
  "request_id": "uuid"
}
```

## Customization

### Modifying CSV Fields

To use different CSV columns, update the `payload.fields` section in the YAML:
```yaml
payload:
  path: './data/your-file.csv'
  fields:
    - 'your_field1'
    - 'your_field2'
    - 'your_field3'
```

### Changing the JSON Payload

Modify the `json` section in the POST request:
```yaml
json:
  your_field1: '{{ your_field1 }}'
  your_field2: '{{ your_field2 }}'
  custom_field: 'static_value'
```

### Load Testing Configuration

Adjust the `phases` section to control load:
```yaml
phases:
  - duration: 120        # Run for 2 minutes
    arrivalRate: 5       # 5 requests per second
    name: "Load test"
```

## Monitoring

The script includes:
- Response logging via the custom `response-logger.js` utility
- Metrics collection with `metrics-by-endpoint` plugin
- Request/response status tracking
- UUID-based request tracking for debugging

## Troubleshooting

1. **CSV not found**: Ensure the CSV file exists at `./data/questions.csv`
2. **Authentication errors**: Check your `ACCESS_TOKEN` environment variable
3. **Network errors**: Verify the `API_BASE_URL` is correct and accessible
4. **Field mapping issues**: Ensure CSV column names match the `fields` configuration
